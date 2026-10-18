# Swachta — API Specification (v1, Pilot MVP)

Base URL: `https://api.swachta.app/v1` (placeholder — set real domain before build)
Auth: Bearer JWT in `Authorization` header unless noted. All responses JSON.

---

## Conventions

- Timestamps: ISO 8601 UTC
- IDs: UUID strings
- Errors: `{ "error": { "code": "STRING_CODE", "message": "human readable" } }` with appropriate HTTP status
- Pagination: `?page=1&limit=50`, responses include `{ "data": [...], "page": 1, "total": 123 }`

---

## Auth

### `POST /auth/household/otp/request`
Request OTP for household login/signup.
```json
Request:  { "phone": "+91XXXXXXXXXX" }
Response: { "sent": true }
```

### `POST /auth/household/otp/verify`
```json
Request:  { "phone": "+91XXXXXXXXXX", "otp": "123456" }
Response: { "token": "jwt...", "household_id": "uuid", "is_new_user": true }
```

### `POST /auth/worker/login`
```json
Request:  { "phone": "+91XXXXXXXXXX", "pin": "1234" }
Response: { "token": "jwt...", "worker_id": "uuid" }
```

### `POST /auth/ops/login`
```json
Request:  { "email": "ops@swachta.app", "password": "..." }
Response: { "token": "jwt...", "role": "ward_ops_lead", "ward_ids": ["uuid"] }
```

---

## Household (Requestor App)

### `POST /households`
Create household profile (post-OTP onboarding).
```json
Request:
{
  "address": "string", "ward_id": "uuid",
  "household_size_band": "1-2 | 3-5 | 6+",
  "schedule_preference": { "days": ["Mon","Thu"], "window": "morning|evening" },
  "language_pref": "hi|en"
}
Response: { "household_id": "uuid", "fee_amount": 150, "status": "active" }
```

### `GET /households/me`
Returns the logged-in household's profile, current subscription status, next pickup.

### `GET /households/me/history?page=1`
Returns past pickups: date, verification photo thumbnails, weights logged, payment status per month.

### `GET /households/me/impact`
```json
Response: { "month": "2026-07", "kg_diverted": 14.2, "streams": { "wet": 8.1, "dry": 4.5, "reject": 1.6 } }
```

### `POST /households/me/issues`
```json
Request: { "type": "missed_pickup|billing|other", "description": "string" }
Response: { "issue_id": "uuid", "status": "open" }
```

### `PATCH /households/me`
Update address, schedule preference, language.

---

## Worker (Worker App)

### `GET /workers/me/route/today`
```json
Response:
{
  "route_id": "uuid", "date": "2026-07-12",
  "stops": [
    { "stop_id": "uuid", "household_id": "uuid", "address": "string",
      "order": 1, "status": "pending" }
  ]
}
```

### `POST /workers/me/stops/{stop_id}/verify`
Core verification endpoint — the one everything depends on. Supports offline queue replay (client sends `client_timestamp` to preserve actual capture time even if synced later).
```json
Request:
{
  "client_timestamp": "2026-07-12T07:32:00Z",
  "streams": [
    { "stream": "wet", "weight_kg": 3.2, "photo_ref": "local-or-uploaded-ref",
      "quality_tag": "clean" },
    { "stream": "dry", "weight_kg": 1.1, "photo_ref": "...", "quality_tag": "partial" }
  ]
}
Response: { "verification_ids": ["uuid", "uuid"], "stop_status": "done" }
```

### `POST /workers/me/stops/{stop_id}/missed`
```json
Request:  { "reason": "not_home|gate_locked|refused|other", "note": "optional string" }
Response: { "stop_status": "missed" }
```

### `GET /workers/me/day-summary?date=2026-07-12`
```json
Response: { "stops_completed": 42, "stops_missed": 3, "weight_by_stream": { "wet": 118.4, "dry": 52.1, "reject": 20.0 } }
```

### `GET /workers/me/earnings?range=week`
```json
Response: { "verified_stops": 210, "computed_amount": 2940, "breakdown": [ ... ] }
```

### `POST /workers/me/issues`
Same shape as household issues, for safety/equipment reports.

---

## Hub Intake (Ops staff — via Ops Dashboard or lightweight hub interface)

### `POST /hub/intake`
```json
Request: { "date": "2026-07-12", "ward_id": "uuid", "stream": "wet", "weight_kg": 340.5 }
Response: { "intake_id": "uuid" }
```

---

## Ops Dashboard

### `GET /ops/metrics/overview?ward_id=uuid&range=30d`
The headline numbers — Business Plan Section 8.
```json
Response:
{
  "households_active": 812,
  "segregation_compliance_rate": 0.71,
  "fee_collection_rate": 0.89,
  "cost_per_household": 178,
  "revenue_per_tonne": { "wet": 6000, "dry": 12000, "rdf": 3000 }
}
```

### `GET /ops/households?ward_id=uuid&status=overdue&page=1`
Searchable household directory.

### `GET /ops/workers?ward_id=uuid`
Worker directory with stop-completion rate, verified earnings, missed-stop patterns.

### `GET /ops/hub-intake?ward_id=uuid&range=7d`
Daily tonnage by stream, with a `field_vs_hub_variance` field flagging discrepancies between field-logged and hub-received weights (the two-sided check from the Architecture doc, Section 5).

### `GET /ops/issues?status=open`
Unified household + worker issue queue.

### `PATCH /ops/issues/{issue_id}`
```json
Request: { "status": "resolved", "resolution_note": "string" }
```

---

## Explicitly not in v1

- Payment gateway webhook endpoints (manual payment status entry only — `PATCH` on payment status via Ops Dashboard, no gateway integration)
- Route optimization/re-assignment endpoints (routes are static, seeded by Ops)
- ULB-facing API (Phase 3, no ULB relationship yet — do not build)
- Multi-language content beyond `hi`/`en` fields
