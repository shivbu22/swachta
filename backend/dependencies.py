"""
FastAPI dependency: get current authenticated user from JWT Bearer token.
"""
import uuid

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from auth import decode_token
from database import get_db
from models import Household, OpsUser, UserRole, Worker

bearer_scheme = HTTPBearer()


async def get_current_household(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> Household:
    exc = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_token(credentials.credentials)
        if payload.get("role") != UserRole.household:
            raise exc
        phone: str = payload["sub"]
    except (JWTError, KeyError):
        raise exc

    result = await db.execute(select(Household).where(Household.phone == phone))
    household = result.scalar_one_or_none()
    if household is None:
        raise exc
    return household


async def get_current_worker(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> Worker:
    exc = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_token(credentials.credentials)
        if payload.get("role") != UserRole.worker:
            raise exc
        worker_id: str = payload["sub"]
    except (JWTError, KeyError):
        raise exc

    try:
        w_uuid = uuid.UUID(worker_id)
    except ValueError:
        raise exc

    result = await db.execute(select(Worker).where(Worker.id == w_uuid))
    worker = result.scalar_one_or_none()
    if worker is None or not worker.is_active:
        raise exc
    return worker


async def get_current_ops_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> OpsUser:
    exc = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_token(credentials.credentials)
        role = payload.get("role")
        if role not in (UserRole.ops_lead, UserRole.founder):
            raise exc
        user_id: str = payload["sub"]
    except (JWTError, KeyError):
        raise exc

    try:
        u_uuid = uuid.UUID(user_id)
    except ValueError:
        raise exc

    result = await db.execute(select(OpsUser).where(OpsUser.id == u_uuid))
    user = result.scalar_one_or_none()
    if user is None or not user.is_active:
        raise exc
    return user


def require_founder(current_user: OpsUser = Depends(get_current_ops_user)) -> OpsUser:
    if current_user.role != UserRole.founder:
        raise HTTPException(status_code=403, detail="Founder access required")
    return current_user
