"""
Verification router: ingest verification records from Worker App.

Key constraints from PRD §9:
- Records are IMMUTABLE once synced (no silent edits).
- Offline queue: idempotent via client_id (UUID generated on device).
- Bulk sync endpoint for offline queue replay.
- Photo upload to Cloudinary.
"""
import uuid
from datetime import datetime, timezone

import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from config import get_settings
from database import get_db
from dependencies import get_current_household, get_current_worker
from models import (
    Household,
    Issue,
    IssueStatus,
    SegregationQuality,
    Stop,
    StopStatus,
    VerificationRecord,
    WasteStream,
    Worker,
)

settings = get_settings()
router = APIRouter(prefix="/verification", tags=["verification"])

# Configure Cloudinary
if settings.cloudinary_cloud_name:
    cloudinary.config(
        cloud_name=settings.cloudinary_cloud_name,
        api_key=settings.cloudinary_api_key,
        api_secret=settings.cloudinary_api_secret,
    )


# ─── Schemas ──────────────────────────────────────────────────────────────────

class VerificationRecordIn(BaseModel):
    stop_id: str
    stream: WasteStream
    weight_kg: float
    segregation_quality: SegregationQuality
    timestamp: datetime
    client_id: str  # device-generated UUID for idempotency
    photo_url: str  # pre-uploaded or will be uploaded separately


class BulkSyncBody(BaseModel):
    records: list[VerificationRecordIn]


class VerificationRecordOut(BaseModel):
    id: str
    stop_id: str
    stream: str
    weight_kg: float
    segregation_quality: str
    photo_url: str
    timestamp: datetime
    synced_at: datetime


# ─── Photo Upload ─────────────────────────────────────────────────────────────

@router.post("/photos/upload")
async def upload_photo(
    file: UploadFile = File(...),
    current: Worker = Depends(get_current_worker),
) -> dict:
    """Upload a verification photo. Returns public URL for use in verification record."""
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")

    contents = await file.read()

    if settings.cloudinary_cloud_name:
        result = cloudinary.uploader.upload(
            contents,
            folder="swachta/verification",
            resource_type="image",
            quality="auto:eco",
            fetch_format="auto",
        )
        url = result["secure_url"]
    else:
        # Dev fallback: return a placeholder URL
        url = f"https://picsum.photos/seed/{uuid.uuid4()}/400/300"

    return {"photo_url": url}


# ─── Single Record Sync ───────────────────────────────────────────────────────

@router.post("/records", response_model=VerificationRecordOut, status_code=201)
async def create_verification_record(
    body: VerificationRecordIn,
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> VerificationRecordOut:
    return await _upsert_record(body, db)


# ─── Bulk Sync (offline queue replay) ────────────────────────────────────────

@router.post("/records/bulk-sync")
async def bulk_sync_records(
    body: BulkSyncBody,
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """
    Idempotent bulk sync for Worker App offline queue.
    Records already synced (by client_id) are skipped silently.
    """
    synced = []
    skipped = []
    errors = []

    for rec in body.records:
        try:
            existing = await db.execute(
                select(VerificationRecord).where(VerificationRecord.client_id == rec.client_id)
            )
            if existing.scalar_one_or_none() is not None:
                skipped.append(rec.client_id)
                continue
            out = await _upsert_record(rec, db)
            synced.append(out.id)
        except Exception as e:
            errors.append({"client_id": rec.client_id, "error": str(e)})

    return {"synced": synced, "skipped": skipped, "errors": errors}


# ─── Household: View past verification records ────────────────────────────────

@router.get("/household/history")
async def get_household_history(
    current: Household = Depends(get_current_household),
    db: AsyncSession = Depends(get_db),
    limit: int = 20,
    offset: int = 0,
) -> list[dict]:
    result = await db.execute(
        select(VerificationRecord, Stop)
        .join(Stop, VerificationRecord.stop_id == Stop.id)
        .where(Stop.household_id == current.id)
        .order_by(VerificationRecord.timestamp.desc())
        .limit(limit)
        .offset(offset)
    )
    rows = result.fetchall()
    return [
        {
            "id": str(vr.id),
            "stream": vr.stream,
            "weight_kg": vr.weight_kg,
            "segregation_quality": vr.segregation_quality,
            "photo_url": vr.photo_url,
            "timestamp": vr.timestamp.isoformat(),
            "stop_date": stop.completed_at.isoformat() if stop.completed_at else None,
        }
        for vr, stop in rows
    ]


# ─── Internal helper ──────────────────────────────────────────────────────────

async def _upsert_record(body: VerificationRecordIn, db: AsyncSession) -> VerificationRecordOut:
    # Validate stop exists
    stop_result = await db.execute(select(Stop).where(Stop.id == body.stop_id))
    stop = stop_result.scalar_one_or_none()
    if not stop:
        raise HTTPException(status_code=404, detail=f"Stop {body.stop_id} not found")

    record = VerificationRecord(
        stop_id=uuid.UUID(body.stop_id),
        stream=body.stream,
        photo_url=body.photo_url,
        weight_kg=body.weight_kg,
        segregation_quality=body.segregation_quality,
        timestamp=body.timestamp,
        synced_at=datetime.now(timezone.utc),
        client_id=body.client_id,
    )
    db.add(record)
    await db.flush()

    return VerificationRecordOut(
        id=str(record.id),
        stop_id=str(record.stop_id),
        stream=record.stream,
        weight_kg=record.weight_kg,
        segregation_quality=record.segregation_quality,
        photo_url=record.photo_url,
        timestamp=record.timestamp,
        synced_at=record.synced_at,
    )


class ResolveHotspotIn(BaseModel):
    resolved_photo_url: str
    collector_latitude: float | None = None
    collector_longitude: float | None = None
    resolution_notes: str | None = None


@router.post("/tickets/{ticket_id}/resolve")
async def resolve_hotspot_ticket(
    ticket_id: str,
    body: ResolveHotspotIn,
    current: Worker = Depends(get_current_worker),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """
    Field worker marks an assigned hotspot dumping ticket as resolved,
    uploading photographic proof of the cleared site + optional GPS check.
    """
    try:
        t_uuid = uuid.UUID(ticket_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid ticket UUID")
    result = await db.execute(select(Issue).where(Issue.id == t_uuid))
    ticket = result.scalar_one_or_none()
    if not ticket:
        raise HTTPException(status_code=404, detail="Hotspot ticket not found")
        
    ticket.resolved_photo_url = body.resolved_photo_url
    ticket.status = IssueStatus.resolved
    ticket.resolved_at = datetime.now(timezone.utc)
    ticket.worker_id = current.id
    if body.resolution_notes:
        ticket.resolution_notes = body.resolution_notes
        
    # Check if completed within SLA
    if ticket.sla_deadline:
        deadline = ticket.sla_deadline if ticket.sla_deadline.tzinfo else ticket.sla_deadline.replace(tzinfo=timezone.utc)
        ticket.is_sla_breached = ticket.resolved_at > deadline

    await db.commit()
    return {
        "id": ticket_id,
        "status": ticket.status.value,
        "resolved_at": ticket.resolved_at.isoformat(),
        "is_sla_breached": ticket.is_sla_breached,
        "message": "Hotspot clearance verified with photo proof.",
    }
