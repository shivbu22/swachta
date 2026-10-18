# Swachta — Design System & UX Brief
### For app UI, consistent with the existing pitch deck / business plan brand identity

---

## 1. Design Principles for This Product

- **The Worker App is not a "lite" version of the Requestor App.** It is designed first for low-literacy users on low-end Android devices in field conditions (sun glare, one-handed use, gloved hands). Large touch targets, icon-forward, minimal text.
- **The Requestor App builds trust through visibility**, not decoration. Every design decision should answer "does this make the household believe their waste is actually being handled properly" — photo confirmations, plain-language impact numbers, transparent fee display.
- **The Ops Dashboard is a cockpit, not a report.** The five headline metrics (Business Plan Sec. 8) are always visible, not buried in a menu.

## 2. Color Tokens

Consistent with the existing Swachta brand (pitch deck, business plan):

| Token | Hex | Usage |
|---|---|---|
| `forest-dark` | `#163C2C` | Primary brand color — headers, primary buttons, Ops Dashboard nav |
| `forest-mid` | `#2E6E4E` | Secondary actions, icons, section headers |
| `sage` | `#7FAF8E` | Supporting accents, secondary UI elements |
| `sage-tint` | `#EAF2EC` | Card backgrounds, subtle section fills |
| `gold` | `#C9922B` | "Sahi Daam" accent — used sparingly for key CTAs, earnings figures, highlights (never as a base color) |
| `gold-tint` | `#FBF1DE` | Warm callout backgrounds |
| `white` | `#FFFFFF` | Base background |
| `ink` | `#1F2A24` | Primary text |
| `muted` | `#5C6B62` | Secondary text, captions |
| `status-success` | `#2E7D32` | Verified/completed states |
| `status-warning` | `#C9922B` | Partial segregation, pending states (reuses gold — status color, not decoration) |
| `status-error` | `#B3261E` | Missed stops, overdue payments — use only for genuine problem states, not as a design accent |

## 3. Typography

- **Display/headings:** Cambria (or a similar serif with character) — used in the business plan and deck; carries the same civic-institutional weight into the app's onboarding/impact screens
- **UI/body:** A clean system sans-serif (e.g., system default — Roboto on Android, San Francisco on iOS) for actual interface text — legibility on low-end screens matters more than brand consistency here. **Do not use a decorative or display font for the Worker App's core verification flow** — every extra millisecond of font-rendering complexity is friction multiplied by hundreds of daily stops.
- **Devanagari (Hindi) support is mandatory**, not an afterthought — verify the chosen font stack renders Hindi cleanly at small sizes on low-end devices before locking the type system.

## 4. Component Notes by Surface

### Requestor App
- Fee display: always show the exact rupee amount, never "starting from" language — Section 9.3 of the Business Plan makes fee transparency a brand promise, not just a UX nicety
- Impact numbers: large, simple, plain-language ("14.2 kg diverted this month" — not a chart for its own sake)
- Verification photo thumbnails: shown small, tappable to enlarge — builds trust without demanding attention

### Worker App
- Primary action buttons: minimum 56dp touch target, high contrast, icon + label (never icon-only for primary actions)
- Photo capture: full-screen camera view, single tap to capture, immediate thumbnail confirmation
- Segregation-quality tag: three large, color-coded buttons (Clean = `status-success`, Partial = `status-warning`, None = `status-error`) — never a dropdown or small radio buttons
- Offline indicator: a persistent, unmissable banner when offline — the worker should always know their data is queued, not silently wonder

### Ops Dashboard
- Five headline metrics as fixed cards at the top of every view, not just the home screen
- Tables (household/worker directories) use `sage-tint` row striping, consistent with the business plan/deck document style
- Issue queue uses status badges (`status-success`/`status-warning`/`status-error`) for at-a-glance triage

## 5. Voice and Copy Guidelines

Following plain, active-voice UX writing:

- Name things by what people control: "Schedule pickup," not "Configure collection request"
- Buttons say exactly what happens: "Confirm pickup" → resulting screen says "Pickup confirmed," not a generic "Success"
- Errors are specific, never apologetic filler: "Photo didn't upload — check your connection and try again," not "Something went wrong"
- Empty states are an invitation to act: an empty route screen for a worker with no stops today says "No stops assigned for today," not a blank screen
- Hindi copy should be written natively for the register, not machine-translated from English — informal, respectful "aap" register, matching how a community worker would actually speak to a household

## 6. Signature Element

The **verification confirmation moment** (Worker App: photo + weight + tag → stop marked complete) is the one interaction in this entire product worth making feel satisfying — a brief, restrained success animation (checkmark, not confetti) reinforces that this specific action is the one that matters most. Keep every other interaction quiet and functional by comparison; spend the app's "personality budget" here, not everywhere.

## 7. What NOT to Do

- Do not use a generic cream/terracotta "AI-generated" default palette — the forest/gold system above is the brand, already established across the business plan and pitch deck; stay consistent
- Do not add decorative animation to the Worker App's core flow — every animation is friction on a low-end device
- Do not default to English-first copy with Hindi as an afterthought toggle — Hindi is the default language for Ghaziabad wards (PRD Section 9)
- Do not over-design the Ops Dashboard with charts for their own sake — the five headline numbers in plain, large text outperform a chart nobody has time to read during a busy ward-ops day
