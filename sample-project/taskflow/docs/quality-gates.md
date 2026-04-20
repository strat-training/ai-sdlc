# TaskFlow — Quality Gates

Each phase has a gate that must pass before the next phase begins.

---

## Phase 1: Requirements → Architecture
**Gate: Requirements Sign-Off**

| Check | Owner | Evidence Required |
|-------|-------|-------------------|
| All BRD objectives covered by at least one PRD user story | PM + SA | Traceability matrix (BRD ref column in PRD) |
| All user stories have acceptance criteria | PM | PRD review |
| No conflicting requirements | SA | PRD review notes |
| Customer has approved PRD | Product Owner | Sign-off email or comment |

**Blocker:** Any BRD objective with no PRD coverage. Any user story missing acceptance criteria.

---

## Phase 2: Architecture → Design
**Gate: Architecture Review**

| Check | Owner | Evidence Required |
|-------|-------|-------------------|
| Architecture Document covers all PRD features | SA | Architecture doc review |
| ADRs document all major decisions | SA | ADR file(s) committed |
| Tech stack aligns with project constraints | TL + SA | ADR sign-off |
| No PRD user story is technically unimplementable | TL | Architecture review notes |

**Blocker:** Unresolved ADR. Architecture gaps for any PRD feature.

---

## Phase 3: Design → Development
**Gate: Design-Tech Alignment + Design Review**

| Check | Owner | Evidence Required |
|-------|-------|-------------------|
| UI components match architecture data model | TL + Designer | Design review session |
| All user flows have a corresponding Dev Task | SA | DevTasks.md completeness check |
| Dev Tasks are sized 1–4 hours each | TL | DevTasks review |

**Blocker:** Dev Tasks missing for any user story. Design-tech misalignment unresolved.

---

## Phase 4: Development → Testing
**Gate: CI Quality Gate (per sprint)**

| Check | Owner | Evidence Required |
|-------|-------|-------------------|
| All endpoints have at least one test | Dev + TL | Test file coverage |
| No failing tests | Dev | CI build green |
| No hardcoded credentials or API keys in source | TL | Code review + grep check |
| All completed Dev Tasks committed with task ID reference | Dev | Git log |
| CLAUDE.md rules not violated | TL | AI code review pass |

**Blocker:** Failing tests. Missing test for any endpoint. Hardcoded secrets.

---

## Phase 5: Testing → DevOps
**Gate: Test Quality Gate**

| Check | Owner | Evidence Required |
|-------|-------|-------------------|
| All critical acceptance criteria tested | QA | Test report mapped to AC |
| No critical or high severity defects open | QA + Dev | Issue tracker |
| Performance within acceptable range | QA | Load test results |
| Security review passed | TL | Security review checklist |

**Blocker:** Open critical defects. Any untested critical acceptance criterion.

---

## Phase 6: DevOps → Production
**Gate: Deployment Testing + Production Readiness Review**

| Check | Owner | Evidence Required |
|-------|-------|-------------------|
| Staging deployment successful | DevOps | Deployment log |
| Smoke tests pass in staging | QA | Smoke test report |
| Environment variables configured | DevOps | `.env.example` complete |
| Runbook documented | DevOps | Runbook file committed |
| Rollback plan defined | TL + DevOps | Runbook rollback section |

**Blocker:** Failing smoke tests. Missing runbook. Staging deployment failure.

---

## TaskFlow Current Gate Status (Sprint 0)

| Gate | Status | Blocker |
|------|--------|---------|
| Requirements Sign-Off | ✅ Passed | — |
| Architecture Review | ✅ Passed | — |
| Design-Tech Alignment | ⚠️ Partial | No design prototype (Figma) created |
| CI Quality Gate | ❌ Not passing | Missing tests for US-04, US-09, US-10, US-11; `PATCH /api/tasks/:id` not implemented |
| Test Quality Gate | ❌ Not started | — |
| Deployment Testing | ❌ Not started | — |
