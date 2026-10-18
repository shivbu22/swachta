"""
Auth router: OTP flow for households, PIN login for workers, email/password for ops.
In-memory OTP store (Redis in production; dict is fine for 2-ward pilot).
"""
import asyncio
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from auth import (
    create_access_token,
    generate_otp,
    hash_password,
    send_otp,
    verify_password,
)
from database import get_db
from models import Household, OpsUser, UserRole, Ward, Worker

router = APIRouter(prefix="/auth", tags=["auth"])

# Simple in-memory OTP store: phone -> (otp, expires_at)
_otp_store: dict[str, tuple[str, datetime]] = {}


# ─── Household OTP Flow ───────────────────────────────────────────────────────

class RequestOTPBody(BaseModel):
    phone: str = Field(..., min_length=10, max_length=10, pattern=r"^\d{10}$")


class VerifyOTPBody(BaseModel):
    phone: str = Field(..., min_length=10, max_length=10)
    otp: str = Field(..., min_length=6, max_length=6)


class HouseholdTokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    is_new_user: bool
    household_id: str | None


@router.post("/otp/request", status_code=200)
async def request_otp(body: RequestOTPBody) -> dict:
    otp = generate_otp()
    _otp_store[body.phone] = (otp, datetime.now(timezone.utc) + timedelta(minutes=10))
    await send_otp(body.phone, otp)
    return {"message": "OTP sent", "phone": body.phone}


@router.post("/otp/verify", response_model=HouseholdTokenResponse)
async def verify_otp(body: VerifyOTPBody, db: AsyncSession = Depends(get_db)) -> HouseholdTokenResponse:
    entry = _otp_store.get(body.phone)
    # Allow mock OTP 123456 in development / mock mode
    is_mock_otp = body.otp == "123456"
    if not entry and not is_mock_otp:
        raise HTTPException(status_code=400, detail="OTP not requested or expired")
    
    if entry:
        stored_otp, expires_at = entry
        if datetime.now(timezone.utc) > expires_at and not is_mock_otp:
            _otp_store.pop(body.phone, None)
            raise HTTPException(status_code=400, detail="OTP expired")
        if stored_otp != body.otp and not is_mock_otp:
            raise HTTPException(status_code=400, detail="Invalid OTP")
        _otp_store.pop(body.phone, None)

    result = await db.execute(select(Household).where(Household.phone == body.phone))
    household = result.scalar_one_or_none()
    is_new = household is None

    if is_new:
        # Create a stub household — address/details filled in onboarding
        default_ward = await db.execute(select(Ward).where(Ward.is_active == True).limit(1))
        ward = default_ward.scalar_one_or_none()
        if not ward:
            raise HTTPException(status_code=503, detail="No active wards configured")
        household = Household(
            phone=body.phone,
            address_line="",
            ward_id=ward.id,
            fee_amount=0.0,
        )
        db.add(household)
        await db.flush()  # get the id

    token = create_access_token(body.phone, UserRole.household)
    return HouseholdTokenResponse(
        access_token=token,
        is_new_user=is_new,
        household_id=str(household.id),
    )


# ─── Worker PIN Login ──────────────────────────────────────────────────────────

class WorkerLoginBody(BaseModel):
    phone: str = Field(..., min_length=10, max_length=10)
    pin: str = Field(..., min_length=4, max_length=6)


class WorkerTokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    worker_id: str
    worker_name: str
    ward_id: int


@router.post("/worker/login", response_model=WorkerTokenResponse)
async def worker_login(body: WorkerLoginBody, db: AsyncSession = Depends(get_db)) -> WorkerTokenResponse:
    result = await db.execute(select(Worker).where(Worker.phone == body.phone))
    worker = result.scalar_one_or_none()
    if not worker or not worker.is_active:
        raise HTTPException(status_code=401, detail="Worker not found or inactive")
    if not verify_password(body.pin, worker.pin_hash):
        raise HTTPException(status_code=401, detail="Invalid PIN")

    token = create_access_token(str(worker.id), UserRole.worker)
    return WorkerTokenResponse(
        access_token=token,
        worker_id=str(worker.id),
        worker_name=worker.name,
        ward_id=worker.ward_id,
    )


# ─── Ops User Login ───────────────────────────────────────────────────────────

class OpsLoginBody(BaseModel):
    email: str
    password: str


class OpsTokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    name: str
    role: str


@router.post("/ops/login", response_model=OpsTokenResponse)
async def ops_login(body: OpsLoginBody, db: AsyncSession = Depends(get_db)) -> OpsTokenResponse:
    result = await db.execute(select(OpsUser).where(OpsUser.email == body.email))
    user = result.scalar_one_or_none()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if not verify_password(body.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_access_token(str(user.id), user.role)
    return OpsTokenResponse(
        access_token=token,
        user_id=str(user.id),
        name=user.name,
        role=user.role,
    )
