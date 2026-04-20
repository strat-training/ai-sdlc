# TaskFlow — Sprint 0 Handoff Plan

Documents the handoff chain between roles during Sprint 0, what is delivered at each step, and what the receiver needs to proceed.

---

## Handoff 1: Client → PM
**Deliverable:** BRD (Business Requirements Document)
**Delivered by:** Client stakeholder (Maria Santos)
**Received by:** PM

| What's delivered | What the receiver needs | Gate to pass |
|-----------------|------------------------|--------------|
| Business objectives, scope, stakeholder list, constraints | Signed-off BRD with no open TBD items in scope | Requirements Sign-Off |

**Risk:** Client provides vague or conflicting requirements — use AI to surface gaps before sign-off.

---

## Handoff 2: PM → SA
**Deliverable:** Approved PRD with acceptance criteria
**Delivered by:** PM
**Received by:** SA

| What's delivered | What the receiver needs | Gate to pass |
|-----------------|------------------------|--------------|
| PRD with user stories (US-01–US-11), acceptance criteria per story, priority | Traceability confirmed — every PRD story links to a BRD objective | Requirements Sign-Off |

**Risk:** Acceptance criteria too vague to generate Dev Tasks — SA must push back before Architecture phase.

---

## Handoff 3: SA → Dev Team
**Deliverable:** Architecture Document + ADRs + Dev Tasks Document
**Delivered by:** SA
**Received by:** Tech Lead + Developers

| What's delivered | What the receiver needs | Gate to pass |
|-----------------|------------------------|--------------|
| `docs/artifacts/ArchitectureDocument.md`, `docs/adrs/ADRs.md`, `docs/artifacts/DevTasks.md` | Every PRD feature has Dev Tasks; tasks are 1–4h each; stack decisions documented in ADRs | Architecture Review |

**Risk:** Dev Tasks are too large or too vague — TL must review sizing before sprint planning.

---

## Handoff 4: Dev → QA
**Deliverable:** Working software in staging + test coverage
**Delivered by:** Developers
**Received by:** QA

| What's delivered | What the receiver needs | Gate to pass |
|-----------------|------------------------|--------------|
| Feature branches merged to main, CI passing, test file(s) covering all endpoints | All acceptance criteria testable in staging; no critical defects already known | CI Quality Gate |

**Risk:** Code submitted without tests — enforce the quality gate: no merge without at least one test per endpoint.

---

## Handoff 5: QA → DevOps
**Deliverable:** QA sign-off + test report
**Delivered by:** QA
**Received by:** DevOps

| What's delivered | What the receiver needs | Gate to pass |
|-----------------|------------------------|--------------|
| Test report mapping results to acceptance criteria; defect list with severities | All critical/high defects resolved; no open blockers | Test Quality Gate |

**Risk:** QA sign-off given with open medium defects that later block production — document all open items explicitly.

---

## Handoff 6: DevOps → Production
**Deliverable:** Production deployment + runbook
**Delivered by:** DevOps
**Received by:** TL + Client

| What's delivered | What the receiver needs | Gate to pass |
|-----------------|------------------------|--------------|
| Production environment live, runbook committed, monitoring configured | Smoke tests pass in production; client UAT can begin | Deployment Testing |

**Risk:** Environment variable misconfiguration — use `.env.example` as checklist during deployment.

---

## Sprint 0 Handoff Status

| Handoff | Status | Notes |
|---------|--------|-------|
| Client → PM (BRD) | ✅ Complete | `docs/artifacts/BRD.md` approved |
| PM → SA (PRD) | ✅ Complete | `docs/artifacts/PRD.md` approved |
| SA → Dev (DevTasks) | ✅ Complete | `docs/artifacts/DevTasks.md` ready |
| Dev → QA | ⚠️ In progress | Several tasks unimplemented (T-024, T-041, T-076) |
| QA → DevOps | ❌ Not started | — |
| DevOps → Production | ❌ Not started | — |
