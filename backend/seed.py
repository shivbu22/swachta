"""
Seed data script for Swachta MVP local pilot.
Creates mock Wards, Households, field workers, ops users, and today's routes/stops.
"""
import asyncio
import uuid
from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from auth import hash_password
from database import engine, Base, AsyncSessionLocal
from models import (
    Earnings,
    Household,
    HubIntake,
    Issue,
    IssueSource,
    IssueStatus,
    IssueType,
    OpsUser,
    Payment,
    PaymentMethod,
    PaymentStatus,
    RecyclableMaterial,
    RecyclablesLedger,
    Route,
    Stop,
    StopStatus,
    SubscriptionStatus,
    UserRole,
    Ward,
    WasteStream,
    Worker,
)


async def seed_data():
    # Sync database schema first
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with AsyncSessionLocal() as db:
        # Check if already seeded
        result = await db.execute(select(Ward).limit(1))
        if result.scalar():
            print("Database already contains data, skipping seed.")
            return

        print("Seeding Wards...")
        ward_12 = Ward(name="Ward 12 (Shalimar Garden)", city="Ghaziabad", is_active=True)
        ward_15 = Ward(name="Ward 15 (Kavi Nagar)", city="Ghaziabad", is_active=True)
        ward_18 = Ward(name="Ward 18 (Sanjay Nagar)", city="Ghaziabad", is_active=True)
        db.add_all([ward_12, ward_15, ward_18])
        await db.flush()

        print("Seeding Ops Users...")
        ops_user = OpsUser(
            email="ops@swachta.co",
            name="Shivam Yadav",
            password_hash=hash_password("swachta123"),
            role=UserRole.ops_lead,
            ward_ids=[ward_12.id, ward_15.id, ward_18.id],
            is_active=True,
        )
        db.add(ops_user)

        print("Seeding Workers...")
        worker_1 = Worker(
            phone="8800112233",
            name="Ramesh Kumar",
            pin_hash=hash_password("1234"),
            ward_id=ward_12.id,
            is_active=True,
        )
        worker_2 = Worker(
            phone="8877665544",
            name="Sunil Prasad",
            pin_hash=hash_password("1234"),
            ward_id=ward_15.id,
            is_active=True,
        )
        db.add_all([worker_1, worker_2])
        await db.flush()

        print("Seeding Households...")
        hh_1 = Household(
            phone="9876543210",
            address_line="G-12, Sector 4, Shalimar Garden",
            latitude=28.6892,
            longitude=77.3412,
            ward_id=ward_12.id,
            household_size_band="3-4",
            subscription_status=SubscriptionStatus.active,
            fee_amount=150.0,
            schedule_preference="Mon, Wed, Fri",
            language_pref="hi",
        )
        hh_2 = Household(
            phone="9988776655",
            address_line="House 43, Ward 12, Main Street",
            latitude=28.6910,
            longitude=77.3435,
            ward_id=ward_12.id,
            household_size_band="1-2",
            subscription_status=SubscriptionStatus.active,
            fee_amount=150.0,
            schedule_preference="Mon, Wed, Fri",
            language_pref="hi",
        )
        hh_3 = Household(
            phone="9123456789",
            address_line="Pocket B, Flat 202, Block A",
            latitude=28.6875,
            longitude=77.3398,
            ward_id=ward_12.id,
            household_size_band="5+",
            subscription_status=SubscriptionStatus.active,
            fee_amount=150.0,
            schedule_preference="Mon, Wed, Fri",
            language_pref="hi",
        )
        hh_4 = Household(
            phone="9811223344",
            address_line="Shop 5, Corner Market, Sector 4",
            latitude=28.6901,
            longitude=77.3420,
            ward_id=ward_12.id,
            household_size_band="3-4",
            subscription_status=SubscriptionStatus.active,
            fee_amount=150.0,
            schedule_preference="Mon, Wed, Fri",
            language_pref="en",
        )
        hh_5 = Household(
            phone="9555666777",
            address_line="House 112, Lane 3, Shalimar Garden",
            latitude=28.6888,
            longitude=77.3450,
            ward_id=ward_12.id,
            household_size_band="3-4",
            subscription_status=SubscriptionStatus.pending,
            fee_amount=150.0,
            schedule_preference="Mon, Wed, Fri",
            language_pref="hi",
        )
        db.add_all([hh_1, hh_2, hh_3, hh_4, hh_5])
        await db.flush()

        print("Seeding Payments...")
        pay_1 = Payment(
            household_id=hh_1.id,
            month="2026-07",
            status=PaymentStatus.paid,
            amount=150.0,
            method=PaymentMethod.upi_qr,
            paid_at=datetime.now(timezone.utc),
        )
        pay_2 = Payment(
            household_id=hh_2.id,
            month="2026-07",
            status=PaymentStatus.pending,
            amount=150.0,
        )
        pay_3 = Payment(
            household_id=hh_3.id,
            month="2026-07",
            status=PaymentStatus.overdue,
            amount=150.0,
        )
        db.add_all([pay_1, pay_2, pay_3])

        print("Seeding Support Issues & Hotspot Dump Tickets...")
        now = datetime.now(timezone.utc)
        
        # Hotspot 1: Open, 24h SLA, near Sector 4 Market
        hotspot_1 = Issue(
            ticket_number="SW-1042",
            source=IssueSource.household,
            type=IssueType.hotspot_dump,
            description="Large illegal dump behind Sector 4 community center. Mixed plastic and organic waste overflowing.",
            status=IssueStatus.open,
            latitude=28.6905,
            longitude=77.3425,
            landmark="Behind Community Hall, Sector 4",
            photo_url="https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=500",
            ward_id=ward_12.id,
            sla_hours=24,
            sla_deadline=now + timedelta(hours=18), # 18 hours left
            household_id=hh_1.id,
            waste_category="MIXED_PLASTIC",
            estimated_volume_m3=2.5,
        )
        
        # Hotspot 2: In Progress, assigned to Ramesh
        hotspot_2 = Issue(
            ticket_number="SW-1043",
            source=IssueSource.household,
            type=IssueType.hotspot_dump,
            description="Construction debris and bags dumped near Kavi Nagar Park entrance.",
            status=IssueStatus.in_progress,
            latitude=28.6720,
            longitude=77.4420,
            landmark="Kavi Nagar D-Block Park Gate 2",
            photo_url="https://images.unsplash.com/photo-1605600659908-0ef719419d41?w=500",
            ward_id=ward_15.id,
            sla_hours=24,
            sla_deadline=now + timedelta(hours=6), # 6 hours left (urgent)
            household_id=hh_2.id,
            assigned_worker_id=worker_1.id,
            waste_category="CONSTRUCTION_MIXED",
            estimated_volume_m3=4.0,
        )

        issue_1 = Issue(
            source=IssueSource.household,
            type=IssueType.missed_pickup,
            description="Worker did not arrive today. Separated wet waste is smelling.",
            status=IssueStatus.open,
            household_id=hh_1.id,
        )
        issue_2 = Issue(
            source=IssueSource.worker,
            type=IssueType.general,
            description="Broken glass in bin at Sector 4 Commercial stop. Need thick gloves.",
            status=IssueStatus.open,
            worker_id=worker_1.id,
        )
        db.add_all([hotspot_1, hotspot_2, issue_1, issue_2])

        print("Seeding Recyclables Resale Ledger (Revenue Stream #3)...")
        rec_1 = RecyclablesLedger(
            date=now,
            ward_id=ward_12.id,
            material=RecyclableMaterial.pet_plastic,
            weight_kg=120.0,
            procured_rate_per_kg=14.0,
            resale_rate_per_kg=22.0,
            gross_revenue=2640.0,
            net_margin=960.0,
            buyer_name="Gupta Scrap Aggregators (Sahibabad)",
            buyer_contact="9810012345",
            logged_by_id=ops_user.id,
            notes="Sorted clear PET bottles",
        )
        rec_2 = RecyclablesLedger(
            date=now,
            ward_id=ward_12.id,
            material=RecyclableMaterial.cardboard,
            weight_kg=350.0,
            procured_rate_per_kg=6.0,
            resale_rate_per_kg=11.5,
            gross_revenue=4025.0,
            net_margin=1925.0,
            buyer_name="Ghaziabad Paper Mills Recyclers",
            buyer_contact="9820054321",
            logged_by_id=ops_user.id,
            notes="Flattened corrugated cardboard bundles",
        )
        db.add_all([rec_1, rec_2])

        print("Seeding Hub Intakes...")
        intake_1 = HubIntake(
            date=now,
            ward_id=ward_12.id,
            stream=WasteStream.wet,
            weight_kg=345.0,
            logged_by_id=ops_user.id,
            notes="Morning shift primary wet intake",
        )
        intake_2 = HubIntake(
            date=now,
            ward_id=ward_12.id,
            stream=WasteStream.dry,
            weight_kg=180.0,
            logged_by_id=ops_user.id,
            notes="Morning shift recyclables sorted",
        )
        db.add_all([intake_1, intake_2])

        print("Seeding Today's Route for Ramesh (Worker 1)...")
        today_route = Route(
            worker_id=worker_1.id,
            ward_id=ward_12.id,
            date=now,
            is_completed=False,
        )
        db.add(today_route)
        await db.flush()

        stop_1 = Stop(route_id=today_route.id, household_id=hh_1.id, sequence_order=1, status=StopStatus.pending)
        stop_2 = Stop(route_id=today_route.id, household_id=hh_2.id, sequence_order=2, status=StopStatus.pending)
        stop_3 = Stop(route_id=today_route.id, household_id=hh_3.id, sequence_order=3, status=StopStatus.pending)
        stop_4 = Stop(route_id=today_route.id, household_id=hh_4.id, sequence_order=4, status=StopStatus.pending)
        stop_5 = Stop(route_id=today_route.id, household_id=hh_5.id, sequence_order=5, status=StopStatus.pending)
        db.add_all([stop_1, stop_2, stop_3, stop_4, stop_5])

        print("Seeding Earnings Ledger...")
        earning_1 = Earnings(
            worker_id=worker_1.id,
            date=now,
            verified_stops_count=5,
            rate_per_stop=50.0,
            computed_amount=250.0,
        )
        db.add(earning_1)

        await db.commit()
        print("Database seeding completed successfully!")


if __name__ == "__main__":
    from datetime import timedelta
    asyncio.run(seed_data())
