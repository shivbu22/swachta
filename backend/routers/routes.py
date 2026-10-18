"""
Routes router: worker route/stop management + stop completion.
"""
import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from database import get_db
from dependencies import get_current_ops_user, get_current_worker
from models import Household, MissedReason, OpsUser, Route, Stop, StopStatus, Worker

router = APIRouter(prefix="/routes", tags=["routes"])


# ─── Schemas ──────────────────────────────────────────────────────────────────

class StopOut(BaseModel):
    id: str
    sequence_order: int
    status: str
    household_id: str
    household_address: str
    household_phone: str
    arrived_at: datetime | None
    completed_at: datetime | None
    missed_reason: str | None


class RouteOut(BaseModel):
    id: str
    date: datetime
    ward_id: int
    is_completed: bool
    stops: list[StopOut]


class ArriveAtStopBody(BaseModel):
    stop_id: str


class MissedStopBody(BaseModel):
    stop_id: str
    reason: MissedReason


class CreateRouteBody(BaseModel):
    worker_id: str
    ward_id: int
    date: datetime
    household_ids: list[str]  # ordered list


# ─── Worker Routes ────────────────────────────────────────────────────────────

@router.get("/today", response_model=RouteOut)
async def get_today_route(
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> RouteOut:
    today = datetime.now(timezone.utc).date()
    result = await db.execute(
        select(Route)
        .where(
            Route.worker_id == current.id,
            Route.date >= datetime.combine(today, datetime.min.time()),
        )
        .options(selectinload(Route.stops).selectinload(Stop.household))
        .order_by(Route.date.desc())
        .limit(1)
    )
    route = result.scalar_one_or_none()
    if not route:
        raise HTTPException(status_code=404, detail="No route assigned for today")

    return _route_to_out(route)


@router.post("/stops/{stop_id}/arrive")
async def arrive_at_stop(
    stop_id: str,
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> dict:
    stop = await _get_stop_for_worker(stop_id, current.id, db)
    stop.arrived_at = datetime.now(timezone.utc)
    stop.status = StopStatus.pending
    return {"stop_id": stop_id, "arrived_at": stop.arrived_at.isoformat()}


@router.post("/stops/{stop_id}/complete")
async def complete_stop(
    stop_id: str,
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> dict:
    stop = await _get_stop_for_worker(stop_id, current.id, db)
    stop.status = StopStatus.done
    stop.completed_at = datetime.now(timezone.utc)
    return {"stop_id": stop_id, "status": "done", "completed_at": stop.completed_at.isoformat()}


@router.post("/stops/{stop_id}/missed")
async def missed_stop(
    stop_id: str,
    body: MissedStopBody,
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> dict:
    stop = await _get_stop_for_worker(stop_id, current.id, db)
    stop.status = StopStatus.missed
    stop.missed_reason = body.reason
    stop.completed_at = datetime.now(timezone.utc)
    return {"stop_id": stop_id, "status": "missed", "reason": body.reason}


# ─── Ops: Create Route ────────────────────────────────────────────────────────

@router.post("/", response_model=RouteOut, status_code=201)
async def create_route(
    body: CreateRouteBody,
    _: OpsUser = Depends(get_current_ops_user),
    db: AsyncSession = Depends(get_db),
) -> RouteOut:
    worker_result = await db.execute(select(Worker).where(Worker.id == body.worker_id))
    worker = worker_result.scalar_one_or_none()
    if not worker:
        raise HTTPException(status_code=404, detail="Worker not found")

    route = Route(
        worker_id=uuid.UUID(body.worker_id),
        ward_id=body.ward_id,
        date=body.date,
    )
    db.add(route)
    await db.flush()

    for i, hh_id in enumerate(body.household_ids):
        stop = Stop(
            route_id=route.id,
            household_id=uuid.UUID(hh_id),
            sequence_order=i + 1,
        )
        db.add(stop)

    await db.flush()
    await db.refresh(route)

    # Reload with relationships
    result = await db.execute(
        select(Route)
        .where(Route.id == route.id)
        .options(selectinload(Route.stops).selectinload(Stop.household))
    )
    route = result.scalar_one()
    return _route_to_out(route)


# ─── Helpers ──────────────────────────────────────────────────────────────────

async def _get_stop_for_worker(stop_id: str, worker_id: uuid.UUID, db: AsyncSession) -> Stop:
    result = await db.execute(
        select(Stop)
        .join(Route, Stop.route_id == Route.id)
        .where(Stop.id == stop_id, Route.worker_id == worker_id)
    )
    stop = result.scalar_one_or_none()
    if not stop:
        raise HTTPException(status_code=404, detail="Stop not found")
    return stop


def _route_to_out(route: Route) -> RouteOut:
    return RouteOut(
        id=str(route.id),
        date=route.date,
        ward_id=route.ward_id,
        is_completed=route.is_completed,
        stops=[
            StopOut(
                id=str(s.id),
                sequence_order=s.sequence_order,
                status=s.status,
                household_id=str(s.household_id),
                household_address=s.household.address_line if s.household else "",
                household_phone=s.household.phone if s.household else "",
                arrived_at=s.arrived_at,
                completed_at=s.completed_at,
                missed_reason=s.missed_reason,
            )
            for s in (route.stops or [])
        ],
    )
