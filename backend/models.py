"""
Swachta data models — all entities from PRD §8.
The VerificationRecord is the core data asset the entire business model depends on.
"""
from __future__ import annotations

import enum
import uuid
from datetime import datetime

from sqlalchemy import (
    Boolean,
    DateTime,
    Enum,
    Float,
    ForeignKey,
    Integer,
    JSON,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from database import Base


# ─── Enums ────────────────────────────────────────────────────────────────────

class SubscriptionStatus(str, enum.Enum):
    active = "active"
    paused = "paused"
    cancelled = "cancelled"
    pending = "pending"


class PaymentStatus(str, enum.Enum):
    paid = "paid"
    pending = "pending"
    overdue = "overdue"


class PaymentMethod(str, enum.Enum):
    cash = "cash"
    upi_qr = "upi_qr"


class StopStatus(str, enum.Enum):
    pending = "pending"
    done = "done"
    missed = "missed"


class MissedReason(str, enum.Enum):
    not_home = "not_home"
    gate_locked = "gate_locked"
    refused = "refused"
    other = "other"


class WasteStream(str, enum.Enum):
    wet = "wet"
    dry = "dry"
    reject = "reject"


class SegregationQuality(str, enum.Enum):
    clean = "clean"
    partial = "partial"
    none = "none"


class IssueSource(str, enum.Enum):
    household = "household"
    worker = "worker"


class IssueType(str, enum.Enum):
    hotspot_dump = "hotspot_dump"
    missed_pickup = "missed_pickup"
    billing_question = "billing_question"
    segregation_query = "segregation_query"
    unsafe_condition = "unsafe_condition"
    equipment_need = "equipment_need"
    general = "general"


class RecyclableMaterial(str, enum.Enum):
    pet_plastic = "pet_plastic"
    hdpe_plastic = "hdpe_plastic"
    cardboard = "cardboard"
    mixed_paper = "mixed_paper"
    metal = "metal"
    glass = "glass"
    e_waste = "e_waste"


class IssueStatus(str, enum.Enum):
    open = "open"
    in_progress = "in_progress"
    resolved = "resolved"


class UserRole(str, enum.Enum):
    household = "household"
    worker = "worker"
    ops_lead = "ops_lead"
    founder = "founder"


# ─── Mixins ───────────────────────────────────────────────────────────────────

class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )


# ─── Ward ─────────────────────────────────────────────────────────────────────

class Ward(Base, TimestampMixin):
    __tablename__ = "wards"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    city: Mapped[str] = mapped_column(String(100), nullable=False, default="Ghaziabad")
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    households: Mapped[list["Household"]] = relationship(back_populates="ward")
    workers: Mapped[list["Worker"]] = relationship(back_populates="ward")
    routes: Mapped[list["Route"]] = relationship(back_populates="ward")
    hub_intakes: Mapped[list["HubIntake"]] = relationship(back_populates="ward")


# ─── Household ────────────────────────────────────────────────────────────────

class Household(Base, TimestampMixin):
    __tablename__ = "households"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    phone: Mapped[str] = mapped_column(String(15), nullable=False, unique=True, index=True)
    address_line: Mapped[str] = mapped_column(Text, nullable=False)
    latitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    longitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    ward_id: Mapped[int] = mapped_column(ForeignKey("wards.id"), nullable=False, index=True)
    household_size_band: Mapped[str] = mapped_column(String(20), nullable=True)  # e.g. "1-2", "3-4", "5+"
    subscription_status: Mapped[SubscriptionStatus] = mapped_column(
        Enum(SubscriptionStatus), default=SubscriptionStatus.pending
    )
    fee_amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    schedule_preference: Mapped[str] = mapped_column(String(200), nullable=True)  # JSON-encoded day+time prefs
    language_pref: Mapped[str] = mapped_column(String(5), default="hi")  # "hi" or "en"
    notification_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    push_token: Mapped[str | None] = mapped_column(String(500), nullable=True)

    # Gamification & Rewards (Phase 2)
    carbon_credits: Mapped[int] = mapped_column(Integer, default=0)
    wallet_balance: Mapped[float] = mapped_column(Float, default=0.0)
    level_tier: Mapped[str] = mapped_column(String(50), default="Seedling")
    referral_code: Mapped[str | None] = mapped_column(String(50), nullable=True, unique=True, index=True)
    referred_by_code: Mapped[str | None] = mapped_column(String(50), nullable=True)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    # Relationships
    ward: Mapped["Ward"] = relationship(back_populates="households")
    payments: Mapped[list["Payment"]] = relationship(back_populates="household")
    stops: Mapped[list["Stop"]] = relationship(back_populates="household")
    issues: Mapped[list["Issue"]] = relationship(back_populates="household", foreign_keys="Issue.household_id")
    credit_transactions: Mapped[list["CreditTransaction"]] = relationship(back_populates="household")
    referrals_made: Mapped[list["ReferralRecord"]] = relationship(back_populates="referrer_household")


# ─── Worker ───────────────────────────────────────────────────────────────────

class Worker(Base, TimestampMixin):
    __tablename__ = "workers"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    phone: Mapped[str] = mapped_column(String(15), nullable=False, unique=True, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    pin_hash: Mapped[str] = mapped_column(String(200), nullable=False)  # bcrypt hashed PIN
    ward_id: Mapped[int] = mapped_column(ForeignKey("wards.id"), nullable=False, index=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    join_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    ward: Mapped["Ward"] = relationship(back_populates="workers")
    routes: Mapped[list["Route"]] = relationship(back_populates="worker")
    earnings: Mapped[list["Earnings"]] = relationship(back_populates="worker")
    issues: Mapped[list["Issue"]] = relationship(back_populates="worker", foreign_keys="Issue.worker_id")


# ─── OpsUser (Ops Lead + Founder) ─────────────────────────────────────────────

class OpsUser(Base, TimestampMixin):
    __tablename__ = "ops_users"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email: Mapped[str] = mapped_column(String(200), nullable=False, unique=True, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    password_hash: Mapped[str] = mapped_column(String(200), nullable=False)
    role: Mapped[UserRole] = mapped_column(Enum(UserRole), nullable=False)
    ward_ids: Mapped[list[int]] = mapped_column(JSON, nullable=False, default=list)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    hub_intakes: Mapped[list["HubIntake"]] = relationship(back_populates="logged_by_user")


# ─── Route ────────────────────────────────────────────────────────────────────

class Route(Base, TimestampMixin):
    __tablename__ = "routes"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    worker_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("workers.id"), nullable=False, index=True)
    ward_id: Mapped[int] = mapped_column(ForeignKey("wards.id"), nullable=False, index=True)
    date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)
    is_completed: Mapped[bool] = mapped_column(Boolean, default=False)

    # Relationships
    worker: Mapped["Worker"] = relationship(back_populates="routes")
    ward: Mapped["Ward"] = relationship(back_populates="routes")
    stops: Mapped[list["Stop"]] = relationship(back_populates="route", order_by="Stop.sequence_order")


# ─── Stop ─────────────────────────────────────────────────────────────────────

class Stop(Base, TimestampMixin):
    __tablename__ = "stops"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    route_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("routes.id"), nullable=False, index=True)
    household_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("households.id"), nullable=False, index=True)
    sequence_order: Mapped[int] = mapped_column(Integer, nullable=False)
    status: Mapped[StopStatus] = mapped_column(Enum(StopStatus), default=StopStatus.pending)
    missed_reason: Mapped[MissedReason | None] = mapped_column(Enum(MissedReason), nullable=True)
    arrived_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    # Relationships
    route: Mapped["Route"] = relationship(back_populates="stops")
    household: Mapped["Household"] = relationship(back_populates="stops")
    verification_records: Mapped[list["VerificationRecord"]] = relationship(back_populates="stop")


# ─── VerificationRecord — THE CORE DATA ASSET ─────────────────────────────────

class VerificationRecord(Base):
    """
    Immutable once synced_at is set. No silent edits permitted.
    This record is the compliance data point the entire business model depends on.
    """
    __tablename__ = "verification_records"
    __table_args__ = (
        UniqueConstraint("stop_id", "stream", name="uq_stop_stream"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    stop_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("stops.id"), nullable=False, index=True)
    stream: Mapped[WasteStream] = mapped_column(Enum(WasteStream), nullable=False)
    photo_url: Mapped[str] = mapped_column(String(1000), nullable=False)
    weight_kg: Mapped[float] = mapped_column(Float, nullable=False)
    segregation_quality: Mapped[SegregationQuality] = mapped_column(Enum(SegregationQuality), nullable=False)
    timestamp: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    collector_latitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    collector_longitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    # synced_at is set server-side on first receipt; record is locked after this
    synced_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    # client_id for idempotent offline queue replay
    client_id: Mapped[str] = mapped_column(String(100), nullable=False, unique=True, index=True)

    # Relationships
    stop: Mapped["Stop"] = relationship(back_populates="verification_records")


# ─── Payment ──────────────────────────────────────────────────────────────────

class Payment(Base, TimestampMixin):
    __tablename__ = "payments"
    __table_args__ = (
        UniqueConstraint("household_id", "month", name="uq_household_month"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    household_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("households.id"), nullable=False, index=True)
    month: Mapped[str] = mapped_column(String(7), nullable=False)  # "2024-07" format
    status: Mapped[PaymentStatus] = mapped_column(Enum(PaymentStatus), default=PaymentStatus.pending)
    amount: Mapped[float] = mapped_column(Float, nullable=False)
    method: Mapped[PaymentMethod | None] = mapped_column(Enum(PaymentMethod), nullable=True)
    paid_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    household: Mapped["Household"] = relationship(back_populates="payments")


# ─── HubIntake ────────────────────────────────────────────────────────────────

class HubIntake(Base, TimestampMixin):
    __tablename__ = "hub_intakes"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)
    ward_id: Mapped[int] = mapped_column(ForeignKey("wards.id"), nullable=False, index=True)
    stream: Mapped[WasteStream] = mapped_column(Enum(WasteStream), nullable=False)
    weight_kg: Mapped[float] = mapped_column(Float, nullable=False)
    logged_by_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("ops_users.id"), nullable=False)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    ward: Mapped["Ward"] = relationship(back_populates="hub_intakes")
    logged_by_user: Mapped["OpsUser"] = relationship(back_populates="hub_intakes")


# ─── Earnings ─────────────────────────────────────────────────────────────────

class Earnings(Base, TimestampMixin):
    __tablename__ = "earnings"
    __table_args__ = (
        UniqueConstraint("worker_id", "date", name="uq_worker_date"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    worker_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("workers.id"), nullable=False, index=True)
    date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)
    verified_stops_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    rate_per_stop: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    computed_amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)

    # Relationships
    worker: Mapped["Worker"] = relationship(back_populates="earnings")


# ─── Issue / Hotspot Dump Ticket ──────────────────────────────────────────────

class Issue(Base, TimestampMixin):
    __tablename__ = "issues"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    ticket_number: Mapped[str | None] = mapped_column(String(20), unique=True, index=True, nullable=True)
    source: Mapped[IssueSource] = mapped_column(Enum(IssueSource), nullable=False)
    type: Mapped[IssueType] = mapped_column(Enum(IssueType), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    status: Mapped[IssueStatus] = mapped_column(Enum(IssueStatus), default=IssueStatus.open)
    
    # Geolocation for Hotspot Mapping
    latitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    longitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    landmark: Mapped[str | None] = mapped_column(String(200), nullable=True)
    ward_id: Mapped[int | None] = mapped_column(ForeignKey("wards.id"), nullable=True, index=True)
    
    # SLA Tracking for ULB & Citizen View
    sla_hours: Mapped[int] = mapped_column(Integer, default=24)
    sla_deadline: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True, index=True)
    is_sla_breached: Mapped[bool] = mapped_column(Boolean, default=False)
    
    # Photos (Citizen before-photo + Collector completion after-photo)
    photo_url: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    resolved_photo_url: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    
    # Phase 2 CV Dataset Pre-instrumentation
    waste_category: Mapped[str | None] = mapped_column(String(50), nullable=True)
    estimated_volume_m3: Mapped[float | None] = mapped_column(Float, nullable=True)
    
    # Foreign Keys & Assignment
    household_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("households.id"), nullable=True, index=True
    )
    worker_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("workers.id"), nullable=True, index=True
    )
    assigned_worker_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("workers.id"), nullable=True, index=True
    )
    resolved_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    resolution_notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    household: Mapped["Household | None"] = relationship(
        back_populates="issues", foreign_keys=[household_id]
    )
    worker: Mapped["Worker | None"] = relationship(
        back_populates="issues", foreign_keys=[worker_id]
    )
    assigned_worker: Mapped["Worker | None"] = relationship(
        foreign_keys=[assigned_worker_id]
    )
    ward: Mapped["Ward | None"] = relationship(foreign_keys=[ward_id])


# ─── Recyclables Ledger (Revenue Stream #3) ───────────────────────────────────

class RecyclablesLedger(Base, TimestampMixin):
    """
    Tracks sorted recyclables aggregation and resale to scrap dealers / kabadiwalas.
    Enables tracking of Swachta's 3rd revenue stream (resale margins).
    """
    __tablename__ = "recyclables_ledger"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)
    ward_id: Mapped[int] = mapped_column(ForeignKey("wards.id"), nullable=False, index=True)
    material: Mapped[RecyclableMaterial] = mapped_column(Enum(RecyclableMaterial), nullable=False)
    weight_kg: Mapped[float] = mapped_column(Float, nullable=False)
    
    # Financials (Margins)
    procured_rate_per_kg: Mapped[float] = mapped_column(Float, default=0.0)
    resale_rate_per_kg: Mapped[float] = mapped_column(Float, nullable=False)
    gross_revenue: Mapped[float] = mapped_column(Float, nullable=False)
    net_margin: Mapped[float] = mapped_column(Float, nullable=False)
    
    buyer_name: Mapped[str] = mapped_column(String(200), nullable=False)
    buyer_contact: Mapped[str | None] = mapped_column(String(50), nullable=True)
    logged_by_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("ops_users.id"), nullable=False)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    ward: Mapped["Ward"] = relationship()
    logged_by_user: Mapped["OpsUser"] = relationship()


# ─── Gamification & Rewards (Phase 2) ─────────────────────────────────────────

class CreditTransaction(Base, TimestampMixin):
    """
    Ledger of Carbon Credits earned (from bookings, tree planting, recycling)
    or redeemed (converted to wallet money at 1 CC = 2.5 INR).
    """
    __tablename__ = "credit_transactions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    household_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("households.id"), nullable=False, index=True)
    amount_cc: Mapped[int] = mapped_column(Integer, nullable=False)
    transaction_type: Mapped[str] = mapped_column(String(50), nullable=False)  # pickup_instant, tree_planting, recyclable_waste, referral_bonus, wallet_conversion
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str | None] = mapped_column(String(500), nullable=True)

    # Relationships
    household: Mapped["Household"] = relationship(back_populates="credit_transactions")


class ReferralRecord(Base, TimestampMixin):
    """
    Tracks citizen referrals (friend invites, signups, and first booking bonuses).
    """
    __tablename__ = "referral_records"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referrer_household_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("households.id"), nullable=False, index=True)
    referee_phone: Mapped[str] = mapped_column(String(15), nullable=False)
    referee_name: Mapped[str | None] = mapped_column(String(100), nullable=True)
    status: Mapped[str] = mapped_column(String(30), default="invited")  # invited, joined, rewarded
    bonus_cc: Mapped[int] = mapped_column(Integer, default=25)

    # Relationships
    referrer_household: Mapped["Household"] = relationship(back_populates="referrals_made")

