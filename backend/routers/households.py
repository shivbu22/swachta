"""
Household router: onboarding completion, profile management, subscriptions.
"""
import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from dependencies import get_current_household, get_current_ops_user
from models import Household, SubscriptionStatus, Ward

router = APIRouter(prefix="/households", tags=["households"])


# ─── Schemas ──────────────────────────────────────────────────────────────────

class HouseholdProfileUpdate(BaseModel):
    address_line: str = Field(..., min_length=5)
    ward_id: int
    household_size_band: str | None = None
    schedule_preference: str | None = None
    language_pref: str = "hi"
    push_token: str | None = None


class HouseholdProfileResponse(BaseModel):
    id: str
    phone: str
    address_line: str
    ward_id: int
    ward_name: str
    household_size_band: str | None
    subscription_status: str
    fee_amount: float
    schedule_preference: str | None
    language_pref: str

    class Config:
        from_attributes = True


class SubscriptionResponse(BaseModel):
    status: str
    fee_amount: float
    next_pickup: str | None = None


# ─── Routes ───────────────────────────────────────────────────────────────────

@router.get("/me", response_model=HouseholdProfileResponse)
async def get_my_profile(
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
) -> HouseholdProfileResponse:
    ward_result = await db.execute(select(Ward).where(Ward.id == current.ward_id))
    ward = ward_result.scalar_one_or_none()
    return HouseholdProfileResponse(
        id=str(current.id),
        phone=current.phone,
        address_line=current.address_line,
        ward_id=current.ward_id,
        ward_name=ward.name if ward else "",
        household_size_band=current.household_size_band,
        subscription_status=current.subscription_status,
        fee_amount=current.fee_amount,
        schedule_preference=current.schedule_preference,
        language_pref=current.language_pref,
    )


@router.patch("/me", response_model=HouseholdProfileResponse)
async def update_my_profile(
    body: HouseholdProfileUpdate,
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
) -> HouseholdProfileResponse:
    # Validate ward exists
    ward_result = await db.execute(select(Ward).where(Ward.id == body.ward_id, Ward.is_active == True))
    ward = ward_result.scalar_one_or_none()
    if not ward:
        raise HTTPException(status_code=404, detail="Ward not found")

    current.address_line = body.address_line
    current.ward_id = body.ward_id
    current.household_size_band = body.household_size_band
    current.schedule_preference = body.schedule_preference
    current.language_pref = body.language_pref
    if body.push_token:
        current.push_token = body.push_token
    # Activate subscription once address is set
    if current.subscription_status == SubscriptionStatus.pending:
        current.subscription_status = SubscriptionStatus.active

    return HouseholdProfileResponse(
        id=str(current.id),
        phone=current.phone,
        address_line=current.address_line,
        ward_id=current.ward_id,
        ward_name=ward.name,
        household_size_band=current.household_size_band,
        subscription_status=current.subscription_status,
        fee_amount=current.fee_amount,
        schedule_preference=current.schedule_preference,
        language_pref=current.language_pref,
    )


@router.get("/me/subscription", response_model=SubscriptionResponse)
async def get_subscription(
    current: Household = Depends(get_current_household),
) -> SubscriptionResponse:
    return SubscriptionResponse(
        status=current.subscription_status,
        fee_amount=current.fee_amount,
    )


@router.get("/me/impact")
async def get_impact(current: Household = Depends(get_current_household), db: AsyncSession = Depends(get_db)) -> dict:
    """Monthly kg diverted by stream for this household."""
    from sqlalchemy import func as sqlfunc
    from models import Stop, VerificationRecord, Route
    from datetime import datetime

    now = datetime.now(timezone.utc)
    month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    # Get all stops for this household this month
    stops_result = await db.execute(
        select(Stop.id).where(
            Stop.household_id == current.id,
            Stop.completed_at >= month_start,
            Stop.status == "done",
        )
    )
    stop_ids = [row[0] for row in stops_result.fetchall()]

    if not stop_ids:
        return {"month": now.strftime("%Y-%m"), "total_kg": 0, "by_stream": {}, "stops_completed": 0}

    vr_result = await db.execute(
        select(
            VerificationRecord.stream,
            sqlfunc.sum(VerificationRecord.weight_kg).label("total"),
        )
        .where(VerificationRecord.stop_id.in_(stop_ids))
        .group_by(VerificationRecord.stream)
    )
    by_stream = {row.stream: row.total for row in vr_result.fetchall()}
    total = sum(by_stream.values())

    return {
        "month": now.strftime("%Y-%m"),
        "total_kg": round(total, 2),
        "by_stream": {k: round(v, 2) for k, v in by_stream.items()},
        "stops_completed": len(stop_ids),
    }


@router.get("/wards")
async def list_wards(db: AsyncSession = Depends(get_db)) -> list[dict]:
    result = await db.execute(select(Ward).where(Ward.is_active == True))
    return [{"id": w.id, "name": w.name, "city": w.city} for w in result.scalars().all()]
