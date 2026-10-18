# Swachta — Database Schema (PostgreSQL, Pilot MVP)

Expands the entity summary in the PRD into a build-ready schema. Naming: snake_case tables, UUID primary keys, `created_at`/`updated_at` on every table (omitted below for brevity but assumed).

---

## Core tables

```sql
CREATE TABLE wards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  city TEXT NOT NULL DEFAULT 'Ghaziabad',
  is_active BOOLEAN DEFAULT true
);

CREATE TABLE households (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT UNIQUE NOT NULL,
  address TEXT NOT NULL,
  ward_id UUID REFERENCES wards(id),
  household_size_band TEXT CHECK (household_size_band IN ('1-2','3-5','6+')),
  fee_amount NUMERIC(10,2) NOT NULL DEFAULT 150,
  schedule_days TEXT[] NOT NULL,           -- e.g. {'Mon','Thu'}
  schedule_window TEXT CHECK (schedule_window IN ('morning','evening')),
  language_pref TEXT DEFAULT 'hi' CHECK (language_pref IN ('hi','en')),
  subscription_status TEXT DEFAULT 'active' CHECK (subscription_status IN ('active','paused','cancelled')),
  customer_type TEXT DEFAULT 'household' CHECK (customer_type IN ('household','shop'))
);
CREATE INDEX idx_households_ward ON households(ward_id);

CREATE TABLE workers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT UNIQUE NOT NULL,
  pin_hash TEXT NOT NULL,
  name TEXT NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active','inactive')),
  join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE worker_ward_assignments (
  worker_id UUID REFERENCES workers(id),
  ward_id UUID REFERENCES wards(id),
  PRIMARY KEY (worker_id, ward_id)
);

CREATE TABLE ops_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT CHECK (role IN ('ward_ops_lead','founder')),
  name TEXT NOT NULL
);

CREATE TABLE ops_user_ward_access (
  ops_user_id UUID REFERENCES ops_users(id),
  ward_id UUID REFERENCES wards(id),
  PRIMARY KEY (ops_user_id, ward_id)
);
```

## Routes and stops

```sql
CREATE TABLE routes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id UUID REFERENCES workers(id),
  ward_id UUID REFERENCES wards(id),
  route_date DATE NOT NULL,
  UNIQUE(worker_id, route_date)
);

CREATE TABLE stops (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id UUID REFERENCES routes(id),
  household_id UUID REFERENCES households(id),
  stop_order INT NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','done','missed')),
  missed_reason TEXT CHECK (missed_reason IN ('not_home','gate_locked','refused','other')),
  missed_note TEXT,
  completed_at TIMESTAMPTZ
);
CREATE INDEX idx_stops_route ON stops(route_id);
```

## Verification (the core mechanic — treat as append-only)

```sql
CREATE TABLE verification_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stop_id UUID REFERENCES stops(id),
  stream TEXT NOT NULL CHECK (stream IN ('wet','dry','reject')),
  weight_kg NUMERIC(6,2) NOT NULL,
  photo_url TEXT NOT NULL,
  quality_tag TEXT NOT NULL CHECK (quality_tag IN ('clean','partial','none')),
  client_timestamp TIMESTAMPTZ NOT NULL,   -- when the worker actually captured it
  synced_at TIMESTAMPTZ NOT NULL DEFAULT now()  -- when it reached the server
);
CREATE INDEX idx_verification_stop ON verification_records(stop_id);

-- Immutability: enforce via application layer (no UPDATE endpoint exposed) and,
-- optionally, a DB-level trigger rejecting UPDATE/DELETE after synced_at is set.
```

## Hub intake and reconciliation

```sql
CREATE TABLE hub_intake (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ward_id UUID REFERENCES wards(id),
  intake_date DATE NOT NULL,
  stream TEXT NOT NULL CHECK (stream IN ('wet','dry','reject')),
  weight_kg NUMERIC(8,2) NOT NULL,
  logged_by UUID REFERENCES ops_users(id)
);
CREATE INDEX idx_hub_intake_ward_date ON hub_intake(ward_id, intake_date);

-- field_vs_hub_variance is computed at query time (view or dashboard query),
-- not stored: SUM(verification_records.weight_kg) for the day vs.
-- SUM(hub_intake.weight_kg) for the same ward/date/stream.
```

## Payments and earnings

```sql
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  household_id UUID REFERENCES households(id),
  period_month DATE NOT NULL,              -- first-of-month convention
  amount NUMERIC(10,2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('paid','pending','overdue')),
  method TEXT CHECK (method IN ('cash','upi')),
  paid_at TIMESTAMPTZ,
  UNIQUE(household_id, period_month)
);

CREATE TABLE earnings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id UUID REFERENCES workers(id),
  earning_date DATE NOT NULL,
  verified_stops_count INT NOT NULL,
  computed_amount NUMERIC(10,2) NOT NULL,
  UNIQUE(worker_id, earning_date)
);
```

## Issues

```sql
CREATE TABLE issues (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_type TEXT CHECK (source_type IN ('household','worker')),
  source_id UUID NOT NULL,                 -- household_id or worker_id
  issue_type TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'open' CHECK (status IN ('open','in_progress','resolved')),
  resolution_note TEXT,
  raised_at TIMESTAMPTZ DEFAULT now(),
  resolved_at TIMESTAMPTZ
);
```

---

## Key derived metrics (compute as views or scheduled aggregation, not stored redundantly)

```sql
-- Segregation compliance rate (ward, date range)
-- = COUNT(quality_tag = 'clean') / COUNT(*) FROM verification_records
--   JOIN stops JOIN routes WHERE ward_id = ? AND route_date BETWEEN ? AND ?

-- Fee collection rate (ward, month)
-- = COUNT(status = 'paid') / COUNT(*) FROM payments JOIN households
--   WHERE ward_id = ? AND period_month = ?

-- Cost per household per month
-- = (SUM(earnings.computed_amount) + fixed ops costs) / COUNT(active households)
--   — fixed cost inputs come from the Financial Model, not this database

-- Revenue per tonne by stream
-- = pricing (from config/assumptions, not DB) x SUM(hub_intake.weight_kg) by stream
```

Note: pricing assumptions (compost/recyclables/RDF Rs-per-tonne) live in the Financial Model spreadsheet, not hardcoded in the database — keep a single small `pricing_config` table if the Ops Dashboard needs to compute revenue live, and treat it as an editable input, not a constant.

```sql
CREATE TABLE pricing_config (
  key TEXT PRIMARY KEY,        -- e.g. 'compost_price_per_tonne'
  value NUMERIC(10,2) NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

---

## Explicitly deferred (do not build these tables in MVP)

- `route_optimization_scores` — no live optimization in MVP, routes are seeded manually
- `loyalty_points`, `referrals` — Phase 2 B2C ideas, not pilot scope
- `ulb_reports` — Phase 3, no ULB relationship yet
- `biogas_*` anything — Business Plan Section 6.7 is years away from needing a schema
