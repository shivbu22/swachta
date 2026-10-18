# Swachta — Ward waste-collection pilot MVP

This monorepo contains the code for the **Swachta Pilot MVP** (active in 2–3 wards, targeting 500–2,000 households in Ghaziabad).

The project is structured as an npm workspaces monorepo containing three application surfaces and a shared backend API.

---

## 🏗️ Project Structure

```
swachta/
├── apps/
│   ├── requestor/          # Expo Mobile App (Household facing)
│   ├── worker/             # Expo Mobile App (Collection Worker facing)
│   └── ops-dashboard/      # React + Vite Web Console (Ops Lead & Founder dashboard)
├── backend/                # FastAPI (Python) backend + PostgreSQL models & routers
├── packages/
│   └── shared/             # Common TypeScript interfaces & enums
└── docker-compose.yml      # Local services (PostgreSQL database container)
```

---

## 🛠️ Tech Stack & Requirements

- **Node.js**: v20+ / npm workspaces
- **Python**: v3.11+
- **Docker**: For running the PostgreSQL service locally
- **Expo Go**: For viewing the mobile apps on iOS / Android devices

---

## 🚀 How to Run

### 1. Initialize workspaces and install dependencies
At the root directory:
```bash
npm install
```

### 2. Start PostgreSQL Database
Spin up the local PostgreSQL database using Docker Compose:
```bash
docker compose up -d db
```

### 3. Run FastAPI Backend
Mount configuration environment variables, set up your virtual environment, and run the API:
```bash
cd backend
python -m venv .venv
# On Windows: .venv\Scripts\activate
# On macOS/Linux: source .venv/bin/activate
pip install -e .
uvicorn main:app --reload
```
Interactive API docs are available at: `http://localhost:8000/docs`.

### 4. Run Ops Dashboard
From the root directory:
```bash
npm run dashboard
```
The web command center will boot on `http://localhost:5173`. Use credentials `ops@swachta.co` to sign in.

### 5. Run Requestor App
From the root directory:
```bash
npm run requestor
```
Scan the QR code with your phone via the Expo Go app.

### 6. Run Worker App
From the root directory:
```bash
npm run worker
```
Toggle the **Online/Offline** switch to test the local offline sync queue.

---

## 🔒 Verification & Compliance Mechanics

Our business metrics depend on the **VerificationRecord** model.
1. **Verification Immutability**: All verification logs are stamped with server-side `synced_at` and remain locked in the database.
2. **Idempotence**: A UUID client-side `client_id` is generated for every worker capture, ensuring that background replays of offline records never result in duplicate logs.
3. **Double Verification**: The dashboard compares weights recorded by field workers against hub logs logged by Ward Leads.
