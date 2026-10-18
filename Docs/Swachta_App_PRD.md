# Swachta — Product Requirements Document
### Requestor App, Worker App & Ops Dashboard — Ghaziabad Pilot (MVP)

**Version:** 1.0 (Pilot Scope) &nbsp;|&nbsp; **Prepared for:** Development team / AI build agent &nbsp;|&nbsp; **Owner:** Shivam Yadav, Founder

---

## 1. Product Overview

Swachta is a technology layer for verified, source-segregated household waste collection. The product is not a general logistics app — its entire value proposition rests on one mechanic: **segregation quality is verified at the point of collection, not estimated after the fact.** Every other feature exists to support that mechanic or to make the resulting data useful to households, workers, and (eventually) downstream buyers and the ULB.

The MVP covers three surfaces:

1. **Requestor App** (mobile, household/small-business facing) — schedule pickup, pay, see impact
2. **Worker App** (mobile, collection-worker facing) — routes, verification, earnings
3. **Ops Dashboard** (web, Ward Operations Lead / Founder facing) — the source of truth for pilot metrics

This PRD scopes the **90-day pilot MVP only** (2–3 wards, 500–2,000 households). Features explicitly out of scope for MVP are marked and listed again in Section 10.

---

## 2. Goals and Success Metrics

The app's job is to produce the exact metrics the Swachta business plan commits to measuring (Business Plan, Section 8). Every feature should be traceable to one of these:

| Metric | How the app produces it |
|---|---|
| Households onboarded / retained | Requestor App signups + active-subscription tracking |
| % of collected waste correctly segregated at source | Worker App photo + weight verification, logged per stop |
| Cost per household per month | Ops Dashboard rollup of worker time/route data + fixed costs |
| Revenue per tonne, by stream | Ops Dashboard hub-intake logging by stream (wet/dry/RDF) |
| Worker earnings & retention | Worker App verified-stop-based earnings ledger |

**Non-goals for MVP:** route-optimization ML, payment-gateway-embedded wallets, predictive analytics, multi-city support, biogas/energy-infrastructure integration (Section 6.7 of the Business Plan — years away).

---

## 3. Users and Personas

| Persona | Description | Primary surface |
|---|---|---|
| **Household Requestor** | Urban household in a pilot ward; price-sensitive; may have low-to-moderate smartphone literacy | Requestor App |
| **Small Shop Owner (dukaan)** | Tier 1 adjacent-service customer (Business Plan Sec. 7.4.1); similar needs to household but commercial cadence | Requestor App (business mode) |
| **Collection Worker** | Performs door-to-door pickup; may have a basic Android device; needs a fast, low-literacy-friendly interface; earnings-sensitive | Worker App |
| **Ward Operations Lead** | Oversees daily field operations (Business Plan Sec. 10.2); needs real-time visibility, not raw data dumps | Ops Dashboard |
| **Founder** | Needs pilot metrics for financier reporting (Business Plan Sec. 8, 11) | Ops Dashboard |

---

## 4. MVP Scope Summary

| In scope (Pilot MVP) | Out of scope (Phase 2+) |
|---|---|
| Household scheduling & recurring pickup | In-app payments gateway (cash/UPI-QR manual for MVP) |
| Photo + weight verification per stop | Route optimization algorithm (manual/static routes for MVP) |
| Basic route assignment (static, ward-based) | Multi-city / multi-tenant support |
| Household waste-destination transparency | Loyalty/rewards program (Business Plan Sec. "B2C ideas") |
| Worker earnings ledger | Reverse-vending kiosk integration |
| Ops Dashboard for compliance & tonnage metrics | ULB-facing compliance dashboard (Phase 3, needs ULB relationship first) |
| Hindi + English UI | Multi-language beyond Hindi/English |
| Basic offline queueing for Worker App | Full offline-first sync architecture |

---

## 5. Requestor App

### 5.1 Core user flows

**Flow A — Onboarding**
1. Household enters phone number → OTP verification
2. Enters address (manual entry + ward selection from pilot-ward list; no full geocoding needed for MVP)
3. Selects household size / approx. waste volume (used for hub planning, not billing)
4. Reviews fee (transparent, fixed per Business Plan Sec. 7.1) → confirms
5. Selects preferred pickup days/time window
6. Sees a short segregation guide (wet/dry/reject, in Hindi + English, illustrated)

**Flow B — Ongoing service**
1. Home screen shows: next pickup date/time, current subscription status, quick segregation reminder
2. Push/SMS reminder morning of pickup
3. After pickup: household sees a confirmation with photo thumbnail of what was collected (optional, builds trust) and running "impact" stats (kg diverted this month)
4. Household can report a missed pickup or segregation-related question via a simple support flow (not live chat for MVP — a structured issue form routed to Ops Dashboard)

**Flow C — Billing**
1. MVP: manual payment (cash to worker or UPI QR code shown in-app) — no embedded payment gateway
2. App logs payment status per household per month (Paid / Pending / Overdue) — this powers the "fee collection rate" metric
3. Household sees payment history

### 5.2 Screens (MVP)

- Onboarding: Phone/OTP → Address/Ward → Household details → Fee confirmation → Schedule selection → Segregation guide
- Home: Next pickup card, subscription status, "your impact this month"
- History: Past pickups with verification photo + weight, payment history
- Segregation Guide: Static reference screen (wet/dry/reject, illustrated, Hindi/English toggle)
- Support: Structured issue form (missed pickup, billing question, general)
- Profile/Settings: Address, schedule preference, language toggle, notification preferences

### 5.3 Requestor App — future (Phase 2+, do not build in MVP)

- Recyclables buy-back ledger (cash-in-hand tracking) — Business Plan Sec. 7.4/B2C ideas
- Compost retail ordering (buy compost back)
- "Swachta Plus" premium tier toggle
- Referral program / loyalty points
- In-app UPI/payment gateway integration

---

## 6. Worker App

This is the highest-priority surface — it is where the core verification mechanic lives. Design for **low-literacy, low-end Android devices, and inconsistent connectivity.** Large touch targets, minimal text entry, icon-forward UI.

### 6.1 Core user flows

**Flow A — Start of day**
1. Worker logs in (phone + PIN, not OTP-per-session, to reduce friction on shared/low-end devices)
2. Sees today's assigned route: an ordered list of households/stops (static assignment for MVP, not live-optimized)
3. Can see total stops, estimated stream breakdown for the day

**Flow B — At each stop (the core mechanic)**
1. Worker taps "Arrived" on the current stop
2. For each waste category presented at the household (wet / dry / reject):
   - Takes one photo of the material
   - Enters or auto-captures weight (manual entry for MVP; scale integration is a stretch goal, not required for pilot)
3. App flags a simple segregation-quality tag: **Clean / Partially Mixed / Not Segregated** — worker selects based on a simple visual guide (this is the compliance data point the whole business model depends on)
4. Stop marked complete; app auto-advances to next stop
5. If household absent/inaccessible: worker logs "Missed — reason" (not home / gate locked / refused) instead of forcing a fake completion

**Flow C — End of day**
1. Worker sees a day summary: stops completed, total weight by stream, any missed stops
2. Delivers material to the hub; hub staff separately confirm intake (Ops Dashboard, Section 7) — this creates a two-sided check between what the worker logged in the field and what the hub received
3. Worker sees earnings accrued for the day (verified-stop-based, per Business Plan Sec. 10.2 wage model)

### 6.2 Screens (MVP)

- Login: Phone + PIN
- Today's Route: Ordered stop list with status indicators (pending/done/missed)
- Stop Detail / Verification: Photo capture (per stream) → weight entry → segregation-quality tag → confirm
- Missed Stop: Reason selector
- Day Summary: Stops completed, weight by stream, missed count
- Earnings: Daily/weekly verified earnings ledger, transparent calculation breakdown
- Safety/Support: Report an issue (unsafe condition, equipment need) — routed to Ops Dashboard

### 6.3 Offline behavior (MVP requirement, not stretch)

Ghaziabad ward-level connectivity cannot be assumed reliable. The Worker App must:
- Cache the day's route locally at login
- Queue stop-completion records (photo + weight + tag) locally if offline
- Sync queued records automatically when connectivity returns
- Never block a worker from completing their route due to connectivity loss

---

## 7. Ops Dashboard (Web)

Built for the Ward Operations Lead and Founder — this is where pilot metrics (Business Plan Sec. 8) actually get read, not just stored.

### 7.1 Core views

- **Pilot Metrics Overview**: households onboarded/active, segregation compliance rate (trend line), fee collection rate, cost per household, revenue per tonne by stream — the five headline numbers from the Business Plan, always visible on load
- **Household Directory**: searchable list, subscription/payment status, service history
- **Worker Directory**: per-worker stop completion rate, verified earnings, missed-stop patterns (used to catch route or worker-support issues early, not for punitive tracking)
- **Hub Intake Log**: daily tonnage received by stream, cross-checked against field-logged weights (the two-sided check from Section 6.1 Flow C)
- **Issue Queue**: household support requests and worker-reported issues, in one triage view

### 7.2 Access control

- Ward Operations Lead: full access to their ward(s)
- Founder: full access, all wards
- No public or investor-facing access in MVP — reporting to financiers is manual export (CSV/PDF), not a live shared dashboard, to avoid exposing operational data prematurely

---

## 8. Data Model (Key Entities)

```
Household
  id, phone, address, ward_id, household_size_band,
  subscription_status, fee_amount, schedule_preference, language_pref

Worker
  id, phone, name, ward_id(s), status, join_date

Route
  id, worker_id, ward_id, date, ordered_stop_list[]

Stop
  id, route_id, household_id, status (pending/done/missed),
  missed_reason (nullable), timestamp

VerificationRecord
  id, stop_id, stream (wet/dry/reject),
  photo_url, weight_kg, segregation_quality_tag (clean/partial/none),
  timestamp, synced_at

Payment
  id, household_id, month, status (paid/pending/overdue), amount, method

HubIntake
  id, date, ward_id, stream, weight_kg, logged_by (hub_staff_id)

Earnings
  id, worker_id, date, verified_stops_count, computed_amount

Issue
  id, source (household/worker), type, description, status, raised_at
```

This schema is intentionally normalized around **the verification record**, since that's the data asset the entire business model (and every future B2B/B2G revenue stream in the Business Plan) is built on.

---

## 9. Non-Functional Requirements

- **Device support:** Worker App must run acceptably on low-end Android (2GB RAM, Android 8+) — this is the actual device class collection workers will have, not a flagship assumption
- **Language:** Hindi and English, toggleable, for both mobile apps; Hindi as default in Ghaziabad wards
- **Connectivity:** Worker App offline-tolerant (Section 6.3); Requestor App can assume better connectivity but should degrade gracefully
- **Performance:** Stop verification flow (Section 6.1 Flow B) must complete in under 30 seconds per stream on a low-end device — every extra second here is friction multiplied by hundreds of daily stops
- **Data integrity:** Verification records are immutable once synced (no silent edits) — this protects the credibility of the compliance-rate metric that financiers and buyers will scrutinize
- **Privacy:** Household address/phone data not exposed to any party beyond assigned worker and Ops Dashboard; no data sold or shared with third parties

---

## 10. Explicitly Out of Scope for MVP

Restated clearly so a build agent doesn't over-scope:

- Payment gateway integration (manual cash/UPI-QR only)
- Route optimization algorithms (static, ward-based routes only)
- Loyalty/rewards, referral programs, recyclables buy-back ledger
- ULB-facing compliance dashboard
- Multi-city/multi-tenant architecture
- Biogas/energy-infrastructure related features (Business Plan Sec. 6.7 — years away)
- In-app chat/live support (structured issue forms only)
- Predictive analytics or ML-based anything

---

## 11. Suggested Tech Stack

Chosen for founder familiarity (per known stack: React Native, Node.js/FastAPI, React) and pilot-scale simplicity — not over-engineered for a 2–3 ward pilot.

- **Mobile (Requestor + Worker apps):** React Native (single codebase, matches founder's existing stack)
- **Backend API:** FastAPI (Python) or Node.js/Express — either fits; FastAPI preferred if reusing patterns from prior AI-related project work
- **Database:** PostgreSQL (relational integrity matters here — verification records, payments, earnings all need referential consistency)
- **Object storage:** Cloud storage (S3-compatible) for verification photos
- **Ops Dashboard:** React (web), same component sensibilities as the mobile apps for consistency
- **Offline sync (Worker App):** local SQLite queue + background sync on connectivity restore
- **Hosting:** Any standard cloud provider; pilot scale does not require anything exotic

---

## 12. Open Questions / Assumptions to Validate Before Build

- Exact household fee amount and billing cadence — pending Days 1–30 willingness-to-pay survey (Business Plan Sec. 11.1)
- Whether hub staff need their own lightweight intake-logging interface or use the Ops Dashboard directly (assumption: Ops Dashboard, MVP)
- Worker device provisioning — Swachta-provided devices vs. worker's own phone (affects offline/low-end device assumptions)
- SMS vs. push notification reliability in pilot wards — may need SMS fallback for reminders

---

## Appendix A — Ready-to-Use Build Prompt

*Copy the block below into an AI coding agent (Claude Code, v0, bolt.new, etc.) to scaffold the MVP. Adjust the "start with" line depending on which surface you want built first — the Worker App's verification flow is the highest-priority, highest-risk piece and is a reasonable place to start.*

```
Build a React Native mobile app called "Swachta Worker App" for waste-collection
workers in a pilot programme in Ghaziabad, India. The core feature is a
verification flow: for each household stop on a worker's daily route, the
worker must (1) mark arrival, (2) for each waste stream present (wet/dry/reject)
take one photo and enter a weight in kg, (3) select a segregation-quality tag
(Clean / Partially Mixed / Not Segregated), then (4) confirm the stop as
complete. If a household is absent, the worker logs a "missed" reason instead.

Requirements:
- Large touch targets, icon-forward UI, minimal text entry — designed for
  low-literacy users on low-end Android devices (2GB RAM, Android 8+)
- Hindi and English UI toggle, Hindi as default
- Must work offline: cache the day's route on login, queue verification
  records locally if offline, auto-sync when connectivity returns
- Screens needed: Login (phone + PIN), Today's Route (ordered stop list),
  Stop Detail/Verification flow, Missed Stop reason selector, Day Summary
  (stops completed, weight by stream), Earnings (verified-stop-based ledger)
- Data model: Worker, Route, Stop, VerificationRecord (stream, photo_url,
  weight_kg, segregation_quality_tag, timestamp), Earnings
- Backend: expose a simple REST API (FastAPI or Node/Express) backed by
  PostgreSQL; object storage for verification photos
- Explicitly do NOT build: payment processing, route optimization algorithms,
  multi-language beyond Hindi/English, any ML/predictive features

Start with the Stop Detail/Verification screen and its offline-queue behavior,
since this is the core mechanic the entire business model depends on.
```

---

*This PRD accompanies the Swachta Business Plan, Pitch Deck, Financial Model, and Grant Application draft. It should be treated as a living document — update Section 12's open questions with real answers as the Days 1–30 ward audit (Business Plan Appendix C) produces them, before locking scope for build.*
