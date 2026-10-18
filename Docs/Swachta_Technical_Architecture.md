# Swachta — Technical Architecture Document
### Pilot MVP (2–3 wards, Ghaziabad) — companion to the PRD

---

## 1. System Overview

Three client surfaces, one backend, one database. Deliberately simple — this is a 2–3 ward pilot, not a national platform. Do not over-engineer for scale that doesn't exist yet.

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Requestor App   │     │   Worker App     │     │  Ops Dashboard   │
│ (React Native)   │     │ (React Native)   │     │   (React, web)   │
└────────┬─────────┘     └────────┬─────────┘     └────────┬─────────┘
         │                        │                         │
         │      HTTPS / REST (JSON), JWT auth               │
         └────────────────┬───────┴─────────────────────────┘
                           │
                  ┌────────▼─────────┐
                  │   Backend API     │
                  │  (FastAPI/Node)   │
                  └────────┬─────────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                 │
   ┌──────▼──────┐  ┌──────▼──────┐  ┌───────▼───────┐
   │ PostgreSQL   │  │ Object       │  │ SMS gateway    │
   │ (primary DB) │  │ Storage (S3) │  │ (reminders)    │
   └─────────────┘  └──────────────┘  └────────────────┘
```

## 2. Component Responsibilities

| Component | Responsibility | Explicitly NOT responsible for |
|---|---|---|
| Requestor App | Household scheduling, fee visibility, impact reporting | Payment processing (manual for MVP), route logic |
| Worker App | Route display, stop verification (photo/weight/tag), offline queueing, earnings display | Payment processing, household data editing |
| Ops Dashboard | Metrics rollup, household/worker directories, issue triage | Real-time route re-optimization (static routes in MVP) |
| Backend API | Auth, business logic, data validation, sync coordination | Rendering UI, storing files directly (delegates to object storage) |
| PostgreSQL | System of record for all structured data | Storing photos/binary data |
| Object Storage | Verification photos | Anything queryable/relational |

## 3. Authentication

- **Households:** phone number + OTP (SMS-based), session JWT, 30-day refresh
- **Workers:** phone number + PIN (not OTP-per-session — reduces friction on shared/low-end devices in the field), session JWT, 7-day refresh with re-auth prompt
- **Ops Dashboard:** email + password, role-based (Ward Operations Lead scoped to their ward(s); Founder unrestricted)
- No third-party social login needed for MVP — adds complexity with no pilot-stage benefit

## 4. Offline Architecture (Worker App — mandatory, not optional)

This is the single most important non-standard piece of this architecture. Ghaziabad ward-level connectivity cannot be assumed.

1. On login, the day's route (ordered stop list + household metadata) is cached to local SQLite
2. Each verification action (photo + weight + segregation tag) writes to a local queue table first, UI updates optimistically
3. A background sync process attempts to push queued records whenever connectivity is detected
4. Photos are compressed client-side before queueing (target <300KB per photo) to keep sync fast on poor connections
5. Sync conflicts are not expected (each record is created once, by one worker, never edited by another party) — so this is an append-only sync, not a conflict-resolution problem. Keep it that way; do not add multi-writer editing to verification records.

## 5. Data Flow — Core Verification Loop (the mechanic everything depends on)

```
Worker arrives at stop
   → captures photo + weight per stream (wet/dry/reject)
   → tags segregation quality (Clean/Partial/None)
   → record queued locally (instant UI feedback)
   → synced to backend when online
   → backend writes to VerificationRecord table (immutable once synced)
   → aggregated nightly into Ops Dashboard metrics (compliance rate, tonnage)
   → cross-checked against HubIntake records logged separately by hub staff
```

The **two-sided check** (field-logged weight vs. hub-received weight) is a deliberate architectural decision, not a nice-to-have — it protects the credibility of the compliance-rate number that goes into every financier document. Do not let a build agent "simplify" this into a single log point.

## 6. Environments

| Environment | Purpose | Notes |
|---|---|---|
| Local dev | Individual development | Docker Compose: API + Postgres + local object storage emulator |
| Staging | Pre-pilot testing, demo to advisors/financiers | Mirrors production, seeded with fake ward/household data |
| Production | Live pilot (Days 31+) | Real household and worker data — see Section 9 of the PRD for privacy requirements |

## 7. Scaling Assumptions (deliberately not built for, yet)

Do NOT build for these in the pilot MVP — they are noted here so a future build phase knows what was deliberately deferred, not forgotten:

- Multi-ward route optimization (static assignment is sufficient for 2–3 wards)
- Multi-tenant / multi-city data partitioning
- High-throughput photo processing pipelines
- Real-time dashboard websockets (polling/refresh is sufficient at this scale)

## 8. Third-Party Dependencies (minimum viable set)

- SMS gateway (OTP + pickup reminders) — any standard Indian SMS API provider
- Object storage (S3-compatible) — for verification photos
- Maps/geocoding: **not required for MVP** — ward-based manual address entry is sufficient; do not add a maps SDK dependency for a static-route pilot

## 9. Security Baseline

- All API traffic over HTTPS only
- JWT tokens short-lived with refresh rotation
- Household PII (phone, address) accessible only to: the assigned worker (for their route), the Ward Operations Lead (for their ward), and the Founder — never exposed in any financier-facing export
- Verification photos stored with access-controlled URLs, not public buckets
- No third-party analytics SDKs that phone home household-level data (aggregate, anonymized metrics only, if any analytics tool is added later)
