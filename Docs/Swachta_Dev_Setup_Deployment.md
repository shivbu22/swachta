# Swachta — Dev Setup & Deployment Plan (Pilot MVP)

---

## 1. Repository Structure (suggested)

```
swachta/
├── apps/
│   ├── requestor-app/      # React Native
│   ├── worker-app/         # React Native
│   └── ops-dashboard/      # React (web)
├── backend/
│   ├── api/                # FastAPI or Node/Express
│   └── migrations/         # DB schema migrations
├── docs/                   # This document set lives here
└── infra/                  # Deployment config
```

Monorepo is recommended at this scale — one founder, one small team, three tightly-coupled clients sharing one API contract. Splitting into separate repos now adds coordination overhead with no pilot-stage benefit.

## 2. Environment Variables (minimum set)

```
# Backend
DATABASE_URL=postgresql://...
JWT_SECRET=...
JWT_REFRESH_SECRET=...
SMS_GATEWAY_API_KEY=...
OBJECT_STORAGE_BUCKET=...
OBJECT_STORAGE_ACCESS_KEY=...
OBJECT_STORAGE_SECRET_KEY=...
ENVIRONMENT=local|staging|production

# Mobile apps (build-time config)
API_BASE_URL=...
SENTRY_DSN=... (optional, error tracking)
```

**Never commit secrets to the repo.** Use `.env.example` with placeholder values; real values in a secrets manager or CI/CD environment config, not in version control.

## 3. Local Development Setup

```bash
# Backend + DB via Docker Compose
docker compose up -d          # starts postgres + local object storage emulator (e.g., minio)
cd backend/api && pip install -r requirements.txt   # or npm install
alembic upgrade head          # or equivalent migration runner
uvicorn main:app --reload     # or npm run dev

# Mobile apps
cd apps/worker-app && npm install && npm run start   # Expo/React Native dev server

# Ops dashboard
cd apps/ops-dashboard && npm install && npm run dev
```

## 4. Environments and Deployment Flow

| Environment | Trigger | Data |
|---|---|---|
| Local | Manual, per developer | Seeded fake data |
| Staging | Auto-deploy on merge to `main` | Seeded fake ward/household/worker data — used for demos to advisors/financiers |
| Production | Manual promotion from staging, after pilot go/no-go check | Real pilot data (Days 31+) |

**Do not deploy directly to production from a feature branch.** Given the immutability requirement on verification records (Architecture doc, Section 5), a bad migration in production is expensive to unwind — staging must be exercised first, every time.

## 5. Seed Data for Staging/Demo

Staging should be seeded with realistic-but-fake data so the app can be demoed to advisors or financiers without exposing real household information:
- 2 fake wards
- ~50 fake households with varied subscription/payment statuses
- 3–5 fake workers with a mix of completed/missed stops
- A week of fake verification records showing a realistic compliance-rate spread (not all "clean" — a dashboard full of perfect numbers looks fake and undermines the honest-data story this whole venture is built on)

## 6. CI/CD (minimum viable)

- On every pull request: run linter + type-check + unit tests (backend and both mobile apps)
- On merge to `main`: auto-deploy backend + ops-dashboard to staging
- Mobile app builds: manual trigger to build a staging APK for on-device testing (Worker App must be tested on real low-end hardware before every pilot-affecting release, not just emulators)

## 7. Monitoring (minimum viable, pilot scale)

- Basic error tracking (e.g., Sentry) on backend and both mobile apps — low overhead, high value for catching field issues fast
- A simple uptime check on the backend API
- **Do not** build elaborate observability/APM infrastructure for a 2–3 ward pilot — this is over-engineering at this stage; revisit post-pilot if scaling

## 8. Data Backup

- Automated daily PostgreSQL backups from Day 1 of production, retained 30 days minimum
- Verification records and payment records are the two tables where data loss would be most damaging to the venture's credibility — confirm backup coverage explicitly includes them before go-live, don't assume

## 9. Pre-Launch Checklist (before Day 31 pilot go-live)

- [ ] Worker App tested on the actual low-end Android device class workers will use, not just emulators
- [ ] Offline queue/sync tested under real poor-connectivity conditions in the pilot ward, not just airplane-mode simulation
- [ ] Hindi copy reviewed by a native speaker, not machine-translated
- [ ] SMS gateway tested with real Indian phone numbers (OTP delivery, pickup reminders)
- [ ] Backup/restore tested at least once against a staging snapshot
- [ ] Ops Dashboard access scoped correctly (Ward Operations Lead cannot see other wards' data)
- [ ] Fee amount and schedule options match whatever the Days 1–30 ward audit (Business Plan Appendix C) actually determined — not left as MVP placeholder values
