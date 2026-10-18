"""
Issues router: households and workers submit structured issue forms & geotagged hotspot dump reports.
"""
import random
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from dependencies import get_current_household, get_current_worker
from models import Household, Issue, IssueSource, IssueStatus, IssueType, Worker

router = APIRouter(prefix="/issues", tags=["issues"])


class HouseholdIssueIn(BaseModel):
    type: IssueType
    description: str = Field(..., min_length=5, max_length=2000)


class HotspotReportIn(BaseModel):
    latitude: float
    longitude: float
    landmark: str | None = None
    photo_url: str
    description: str = Field(..., min_length=3, max_length=2000)
    ward_id: int | None = None


class WorkerIssueIn(BaseModel):
    type: IssueType
    description: str = Field(..., min_length=5, max_length=2000)


@router.post("/hotspots", status_code=201)
async def report_hotspot(
    body: HotspotReportIn,
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """
    Citizen reports an illegal dumping hotspot with photo + GPS geotag.
    Automatically assigns a SW-XXXX ticket number and a 24-hour SLA deadline.
    """
    sla_hours = 24
    sla_deadline = datetime.now(timezone.utc) + timedelta(hours=sla_hours)
    ticket_num = f"SW-{random.randint(1000, 9999)}"

    issue = Issue(
        ticket_number=ticket_num,
        source=IssueSource.household,
        type=IssueType.hotspot_dump,
        description=body.description,
        latitude=body.latitude,
        longitude=body.longitude,
        landmark=body.landmark,
        photo_url=body.photo_url,
        ward_id=body.ward_id or current.ward_id,
        sla_hours=sla_hours,
        sla_deadline=sla_deadline,
        household_id=current.id,
        status=IssueStatus.open,
    )
    db.add(issue)
    await db.commit()
    await db.refresh(issue)
    return {
        "id": str(issue.id),
        "ticket_number": ticket_num,
        "sla_deadline": sla_deadline.isoformat(),
        "status": issue.status.value,
        "message": f"Hotspot reported under Ticket #{ticket_num}. 24-hour SLA initiated.",
    }


@router.get("/household/my-reports")
async def get_my_reports(
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
) -> list[dict]:
    """Citizen tracks all their reported issues and hotspots with live SLA status."""
    stmt = (
        select(Issue)
        .where(Issue.household_id == current.id)
        .order_by(Issue.created_at.desc())
    )
    result = await db.execute(stmt)
    issues = result.scalars().all()
    
    now = datetime.now(timezone.utc)
    out = []
    for iss in issues:
        remaining_seconds = None
        if iss.sla_deadline:
            deadline = iss.sla_deadline if iss.sla_deadline.tzinfo else iss.sla_deadline.replace(tzinfo=timezone.utc)
            remaining_seconds = max(0, int((deadline - now).total_seconds()))
            
        out.append({
            "id": str(iss.id),
            "ticket_number": iss.ticket_number or "GEN-ISSUE",
            "type": iss.type.value,
            "description": iss.description,
            "status": iss.status.value,
            "landmark": iss.landmark,
            "latitude": iss.latitude,
            "longitude": iss.longitude,
            "photo_url": iss.photo_url,
            "resolved_photo_url": iss.resolved_photo_url,
            "created_at": iss.created_at.isoformat() if iss.created_at else None,
            "sla_deadline": iss.sla_deadline.isoformat() if iss.sla_deadline else None,
            "remaining_seconds": remaining_seconds,
            "is_sla_breached": iss.is_sla_breached,
            "resolved_at": iss.resolved_at.isoformat() if iss.resolved_at else None,
        })
    return out


@router.post("/household", status_code=201)
async def submit_household_issue(
    body: HouseholdIssueIn,
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
) -> dict:
    issue = Issue(
        source=IssueSource.household,
        type=body.type,
        description=body.description,
        household_id=current.id,
    )
    db.add(issue)
    await db.flush()
    return {"id": str(issue.id), "message": "Issue submitted. Our team will respond shortly."}


@router.post("/worker", status_code=201)
async def submit_worker_issue(
    body: WorkerIssueIn,
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> dict:
    issue = Issue(
        source=IssueSource.worker,
        type=body.type,
        description=body.description,
        worker_id=current.id,
    )
    db.add(issue)
    await db.flush()
    return {"id": str(issue.id), "message": "Issue reported"}
