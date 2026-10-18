# Swachta — User Stories & Acceptance Criteria (Pilot MVP)

Organized by epic. Each story includes acceptance criteria a build agent (or QA pass) can check directly — use these to know when a feature is actually "done," not just "built."

---

## Epic 1: Household Onboarding

**US-1.1** — As a household, I want to sign up with just my phone number, so that I don't need to remember a password.
- ✅ OTP sent within 10 seconds of request
- ✅ OTP expires after 5 minutes
- ✅ Invalid OTP shows a specific error, not a generic failure

**US-1.2** — As a household, I want to see the exact fee before confirming, so that there are no surprises.
- ✅ Fee amount displayed in Rs, no ranges or "starting from" language
- ✅ Household must actively confirm the fee screen before proceeding

**US-1.3** — As a household, I want to understand how to segregate my waste, so that my pickups go smoothly.
- ✅ Segregation guide shown during onboarding, accessible later from Settings
- ✅ Available in Hindi and English, illustrated (not text-only)

---

## Epic 2: Household Ongoing Service

**US-2.1** — As a household, I want to know when my next pickup is, so that I have my waste ready.
- ✅ Home screen always shows next pickup date/time
- ✅ Reminder sent (push or SMS fallback) the morning of pickup

**US-2.2** — As a household, I want to see that my waste was actually collected properly, so that I trust the service.
- ✅ After a completed stop, household sees a confirmation with photo thumbnail within 5 minutes (allowing for worker sync delay)
- ✅ History screen shows past pickups with photos and logged weights

**US-2.3** — As a household, I want to see my environmental impact, so that segregating feels worthwhile.
- ✅ Monthly kg-diverted figure visible on home screen
- ✅ Breakdown by stream (wet/dry/reject) available on tap

**US-2.4** — As a household, I want to report a missed pickup or ask a question, so that issues get resolved.
- ✅ Issue form accessible within 2 taps from home screen
- ✅ Submitted issue appears in the Ops Dashboard issue queue within 1 minute

---

## Epic 3: Worker Route & Verification (highest priority epic)

**US-3.1** — As a worker, I want to see my route for the day in order, so that I know where to go next.
- ✅ Route loads even if opened offline (cached from last successful sync)
- ✅ Stop list shows address, order, and current status (pending/done/missed)

**US-3.2** — As a worker, I want to log what I collect at each stop quickly, so that verification doesn't slow down my route.
- ✅ Full verification flow (photo + weight + tag, all streams present) completable in under 90 seconds total per stop on a low-end device
- ✅ Works fully offline; queued records show a clear "pending sync" state
- ✅ Once synced, a verification record cannot be edited or deleted through the app (immutability enforced server-side)

**US-3.3** — As a worker, I want to log a missed stop without being forced to fake a completion, so that my data stays honest.
- ✅ "Missed" option available from the stop detail screen at all times
- ✅ Missed reason is required (not free-text-only) to keep Ops Dashboard reporting consistent

**US-3.4** — As a worker, I want to see my earnings update as I complete verified stops, so that I trust the pay is fair.
- ✅ Day summary shows verified stop count and computed earnings, matching the wage formula in the Business Plan (Sec. 10.2)
- ✅ Earnings breakdown is viewable, not just a final number — worker can see how it was calculated

---

## Epic 4: Ops Dashboard & Metrics

**US-4.1** — As a Ward Operations Lead, I want to see the five pilot headline metrics at a glance, so that I know how the pilot is doing without digging.
- ✅ Households active, segregation compliance rate, fee collection rate, cost per household, revenue per tonne — all visible on dashboard load, no clicks required
- ✅ Metrics scoped to the logged-in user's assigned ward(s) only

**US-4.2** — As a Ward Operations Lead, I want to catch discrepancies between what workers log in the field and what the hub receives, so that I can trust the compliance numbers I report to financiers.
- ✅ Field-logged vs. hub-received weight variance visible per ward/date/stream
- ✅ Variance above a configurable threshold (e.g., 15%) is visually flagged

**US-4.3** — As a Founder, I want to export pilot metrics for financier reporting, so that I don't need to build a public dashboard prematurely.
- ✅ CSV/PDF export available for the metrics overview, scoped to a selected date range
- ✅ No public or unauthenticated access to any dashboard view

**US-4.4** — As a Ward Operations Lead, I want a single place to triage household and worker issues, so that nothing falls through the cracks.
- ✅ Issues from both sources appear in one queue, filterable by status and source type
- ✅ Marking an issue resolved requires a resolution note (accountability, not just a checkbox)

---

## Epic 5: Payments (manual, MVP)

**US-5.1** — As a household, I want a simple way to pay my monthly fee, so that I don't need a bank account or credit card.
- ✅ UPI QR code displayed in-app as one payment option
- ✅ Cash-to-worker also supported, logged by worker or Ops staff, not silently untracked

**US-5.2** — As a Ward Operations Lead, I want to see which households haven't paid, so that I can follow up.
- ✅ Payment status (paid/pending/overdue) visible per household in the directory
- ✅ Fee collection rate metric (US-4.1) recalculates automatically as payments are logged

---

## Definition of Done (applies to every story above)

A story is not "done" when the UI renders — it's done when:
1. The acceptance criteria above pass
2. It works on a low-end Android test device (Worker App stories especially)
3. Hindi and English copy both exist and were reviewed, not machine-translated placeholder text
4. It doesn't silently touch anything listed as out-of-scope in the PRD (Section 10) or Architecture doc (Section 7)
