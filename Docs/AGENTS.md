# AGENTS.md — Instructions for AI Coding Agents Working on Swachta

This file is read automatically by AI coding agents (Claude Code, Cursor, and compatible tools) at the start of every session. It is the source of truth for how to work in this repo. If you are an agent reading this: follow it even when a prompt in a session doesn't repeat these rules — they don't expire between sessions.

If your tool specifically looks for `CLAUDE.md`, copy or symlink this file to `CLAUDE.md` — keep one source of truth, don't maintain two diverging copies.

---

## 1. What Swachta Is (30-second version)

A verified source-segregation waste collection system for a pilot in Ghaziabad, India. Three surfaces: a **Requestor App** (households schedule pickup), a **Worker App** (collection workers verify segregation quality with photo + weight + a quality tag at every stop), and an **Ops Dashboard** (web, pilot metrics). The entire business depends on one mechanic: **verification data logged at the point of collection.** Every architectural and product decision protects that mechanic. When in doubt, protect it.

## 2. Source-of-Truth Documents — Read Before You Build

Do not guess at product, API, schema, or design decisions — they're already made. Read the relevant doc first.

| Question you're facing | Read this first |
|---|---|
| What screens/flows does a feature need? | `Swachta_App_PRD.md` |
| How do the pieces talk to each other? Offline sync? | `Swachta_Technical_Architecture.md` |
| What's the exact endpoint/request/response shape? | `Swachta_API_Specification.md` |
| What's the table/column/constraint for this data? | `Swachta_Database_Schema.md` |
| What color/font/component pattern do I use? | `Swachta_Design_System.md` |
| How do I know this feature is actually done? | `Swachta_User_Stories.md` |
| How do I run this locally / what's the repo layout? | `Swachta_Dev_Setup_Deployment.md` |

If a task requires a decision not covered in these docs, that's a real gap — flag it back to the user rather than inventing a convention that contradicts one of these files later.

## 3. Non-Negotiable Product Rules

These override any instinct toward a "cleaner" or "more standard" implementation:

- **Verification records are append-only.** No edit or delete endpoint, ever, even for admin/ops roles. This is a credibility requirement, not a technical preference — it protects the compliance-rate number that goes into every financier and grant document this venture produces.
- **The Worker App must work offline.** Route caching on login, local queue for verification records, background sync on reconnect. Do not ship a Worker App feature that silently requires connectivity to function in the field.
- **Hindi is the default language**, not an English-first app with a Hindi toggle bolted on. Write Hindi copy natively; do not machine-translate placeholder English at build time and call it done.
- **The Worker App targets low-end Android (2GB RAM, Android 8+).** Test on that device class, not just an emulator or a flagship test phone, before considering any Worker App change complete.
- **No payment gateway in MVP.** Manual UPI-QR display and cash logging only. Do not add a payment SDK because it seems like an obvious next step — it isn't, yet.
- **Routes are static/ward-based, not optimized.** Do not introduce a route-optimization algorithm or dependency unless explicitly asked.

## 4. Explicitly Out of Scope — Do Not Build Unless Asked

Pulled from the PRD, Architecture, and Schema docs so it's in one place. Building any of these unprompted is scope creep, not initiative:

- Payment gateway integration
- Route optimization / re-assignment algorithms
- Loyalty points, referral programs, recyclables buy-back ledgers
- ULB-facing compliance dashboard or API (no ULB relationship exists yet)
- Multi-city / multi-tenant architecture
- Biogas/energy-infrastructure features or schema (years-away roadmap item, see Business Plan Sec. 6.7)
- In-app chat/live support (structured issue forms only)
- Any ML/predictive/route-scoring feature
- Maps SDK or geocoding (manual ward/address entry is sufficient at pilot scale)

## 5. Tech Stack — Locked, Don't Relitigate

- **Mobile (both apps):** React Native
- **Backend:** FastAPI (Python) or Node/Express — whichever the repo already has; don't introduce a second backend language
- **Database:** PostgreSQL
- **Object storage:** S3-compatible, for verification photos only
- **Ops Dashboard:** React (web)
- **Offline queue (Worker App):** local SQLite + background sync

Do not propose a stack change (e.g., "this would be simpler in Flutter/Firebase/Supabase") — this was decided for founder familiarity and pilot-scale simplicity, not because alternatives don't exist.

## 6. Repo Structure

```
swachta/
├── apps/
│   ├── requestor-app/      # React Native
│   ├── worker-app/         # React Native
│   └── ops-dashboard/      # React (web)
├── backend/
│   ├── api/
│   └── migrations/
├── docs/                    # the 7 source-of-truth documents live here
└── infra/
```

## 7. Coding Conventions

- Match existing patterns in the file you're editing before introducing a new pattern
- New DB tables/columns: follow `Swachta_Database_Schema.md` naming (snake_case, UUID PKs, `created_at`/`updated_at`)
- New API endpoints: follow the shape and error format in `Swachta_API_Specification.md` — don't invent a new response envelope
- Commit messages: short, imperative, scoped — e.g. `worker-app: add offline queue for verification records`
- Don't add a new third-party dependency for something achievable with what's already in the stack — check `package.json`/`requirements.txt` first

## 8. Definition of Done

A feature is not done when it compiles and renders. It's done when:

1. It matches the acceptance criteria for its story in `Swachta_User_Stories.md`
2. Worker App changes are verified on a real low-end Android device, not just an emulator
3. Hindi and English copy both exist, reviewed, not machine-translated placeholders
4. It doesn't touch anything in Section 4 of this file without being explicitly asked to
5. If it touches verification records, payments, or hub intake — the immutability and two-sided-check rules (Architecture doc, Section 5) still hold

## 9. When Something Is Ambiguous

1. Check the relevant source-of-truth doc (Section 2 table)
2. If it's genuinely not covered, ask the user — don't silently pick a convention that might contradict a doc you haven't read
3. Never resolve ambiguity by adding scope (a new field, a new screen, a new dependency) as the default answer — the smaller, more reversible choice is usually correct at this stage

## 10. Design Quick Reference

(Full detail in `Swachta_Design_System.md` — this is just enough to avoid re-reading it for a one-line color fix.)

`forest-dark #163C2C` · `forest-mid #2E6E4E` · `sage #7FAF8E` · `sage-tint #EAF2EC` · `gold #C9922B` (accent only, never a base color) · `ink #1F2A24` · `muted #5C6B62`

Worker App core flow: no decorative animation, large touch targets (56dp min), icon + label on primary actions, never icon-only.

---

*Keep this file updated as decisions change. If a source-of-truth doc is revised, check whether Sections 3, 4, or 5 here need to change with it — a stale AGENTS.md that contradicts the actual docs is worse than no AGENTS.md at all.*
