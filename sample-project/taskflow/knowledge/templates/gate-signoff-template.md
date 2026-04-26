# Gate Sign-Off Template

> One file per phase gate. Fill in during the Friday gate review session.
> Commit signed-off forms to `docs/reviews/` in your cohort's sample-project repo.

---

## Gate Identifier

- **Cohort / project:** _________________________
- **Gate:** [ ] Requirements Sign-Off (W1) · [ ] Architecture + Dev Handoff (W2) · [ ] Sprint 1 Readiness (W3)
- **Date:** _________________________
- **Facilitator:** _________________________

## Artifacts Reviewed

List every artifact this gate covers. Reference path in repo.

| Artifact | Owner (role + name) | Path in repo |
|---|---|---|
| | | |
| | | |
| | | |

## Quality Bar Checklist

Run through the relevant module's quality bar for each artifact. Check each item.

### Artifact 1: __________________

- [ ] Quality bar item 1 ...
- [ ] Quality bar item 2 ...
- [ ] (List the bar items the module specified for this artifact)

**Verdict:** [ ] Pass · [ ] Pass with notes · [ ] Needs rework

**Notes / required changes:**

```
(write here)
```

### Artifact 2: __________________

(repeat above structure for each artifact)

## Cross-Artifact Traceability Check

- [ ] Every downstream artifact references the upstream artifact it traces from.
- [ ] No orphan items (no Dev Task without a user story; no user story without a BRD requirement; etc.).
- [ ] Numbering and IDs are consistent across artifacts.

**Notes:**

```
(write here)
```

## Reviewers

Each reviewer signs off after walking through the checklist for the artifacts they were assigned.

| Role | Reviewer name | Verdict | Notes |
|---|---|---|---|
| Solutions Designer | | [ ] Pass [ ] Needs rework | |
| Product Mgr / Designer | | [ ] Pass [ ] Needs rework | |
| Project Manager | | [ ] Pass [ ] Needs rework | |
| Solutions Architect | | [ ] Pass [ ] Needs rework | |
| Tech Lead | | [ ] Pass [ ] Needs rework | |
| Developer (peer) | | [ ] Pass [ ] Needs rework | |
| QA reviewer | | [ ] Pass [ ] Needs rework | |
| DevOps reviewer | | [ ] Pass [ ] Needs rework | |
| Facilitator | | [ ] Pass [ ] Needs rework | |

## Final Verdict

- [ ] **APPROVED** — gate passes. Next phase begins as scheduled.
- [ ] **APPROVED WITH FOLLOW-UPS** — gate passes; non-blocking items tracked below.
- [ ] **NEEDS REWORK** — gate fails. Rework before next phase begins.
- [ ] **BLOCKED** — issue requires escalation; gate cannot be decided in this session.

## Follow-Up Actions

For approved-with-follow-ups or needs-rework verdicts:

| Action | Owner | Due |
|---|---|---|
| | | |
| | | |

## Lessons / Retro Notes

What worked? What broke? What should the next cohort know about this gate?

```
(write here)
```

---

*Once signed, this form is the formal handoff record. Downstream work proceeds based on the artifacts approved here.*
