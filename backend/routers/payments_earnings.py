"""
Payments + Earnings routers.
"""
import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from dependencies import get_current_household, get_current_ops_user, get_current_worker
from models import Earnings, Household, OpsUser, Payment, PaymentMethod, PaymentStatus, Worker

payments_router = APIRouter(prefix="/payments", tags=["payments"])
earnings_router = APIRouter(prefix="/earnings", tags=["earnings"])


# ─── Payments ─────────────────────────────────────────────────────────────────

class PaymentIn(BaseModel):
    month: str  # "2024-07"
    amount: float
    method: PaymentMethod
    notes: str | None = None


@payments_router.get("/me")
async def get_my_payments(
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
) -> list[dict]:
    result = await db.execute(
        select(Payment).where(Payment.household_id == current.id).order_by(Payment.month.desc())
    )
    return [
        {
            "id": str(p.id),
            "month": p.month,
            "status": p.status,
            "amount": p.amount,
            "method": p.method,
            "paid_at": p.paid_at.isoformat() if p.paid_at else None,
        }
        for p in result.scalars().all()
    ]


@payments_router.post("/me/pay", status_code=201)
async def mark_payment(
    body: PaymentIn,
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Household marks their own payment (cash / UPI-QR — manual MVP flow)."""
    result = await db.execute(
        select(Payment).where(Payment.household_id == current.id, Payment.month == body.month)
    )
    payment = result.scalar_one_or_none()
    if payment is None:
        payment = Payment(
            household_id=current.id,
            month=body.month,
            amount=body.amount,
            method=body.method,
        )
        db.add(payment)
    payment.status = PaymentStatus.paid
    payment.method = body.method
    payment.paid_at = datetime.now(timezone.utc)
    payment.notes = body.notes
    await db.flush()
    return {"id": str(payment.id), "status": "paid", "month": body.month}


# ─── Earnings ─────────────────────────────────────────────────────────────────

@earnings_router.get("/me")
async def get_my_earnings(
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> dict:
    result = await db.execute(
        select(Earnings).where(Earnings.worker_id == current.id).order_by(Earnings.date.desc()).limit(30)
    )
    records = result.scalars().all()
    daily = [
        {
            "date": r.date.strftime("%Y-%m-%d"),
            "stops": r.verified_stops_count,
            "rate": r.rate_per_stop,
            "amount": r.computed_amount,
        }
        for r in records
    ]
    total = sum(r.computed_amount for r in records)
    return {
        "worker_id": str(current.id),
        "worker_name": current.name,
        "daily_breakdown": daily,
        "total_last_30_days": round(total, 2),
    }


@earnings_router.post("/compute/{worker_id}/{date}")
async def compute_daily_earnings(
    worker_id: str,
    date: str,
    rate_per_stop: float = 50.0,
    _: OpsUser = Depends(get_current_ops_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Ops: compute and persist earnings for a worker on a given date."""
    from models import Route, Stop, StopStatus
    from sqlalchemy import func

    target_date = datetime.strptime(date, "%Y-%m-%d").replace(tzinfo=timezone.utc)
    next_day = target_date.replace(hour=23, minute=59, second=59)

    stop_count_q = await db.execute(
        select(func.count()).select_from(Stop)
        .join(Route, Stop.route_id == Route.id)
        .where(
            Route.worker_id == worker_id,
            Route.date >= target_date,
            Route.date <= next_day,
            Stop.status == StopStatus.done,
        )
    )
    count = stop_count_q.scalar_one()
    amount = count * rate_per_stop

    existing = (await db.execute(
        select(Earnings).where(Earnings.worker_id == worker_id, Earnings.date == target_date)
    )).scalar_one_or_none()

    if existing:
        existing.verified_stops_count = count
        existing.rate_per_stop = rate_per_stop
        existing.computed_amount = amount
    else:
        earnings = Earnings(
            worker_id=uuid.UUID(worker_id),
            date=target_date,
            verified_stops_count=count,
            rate_per_stop=rate_per_stop,
            computed_amount=amount,
        )
        db.add(earnings)

    return {"worker_id": worker_id, "date": date, "stops": count, "amount": amount}
