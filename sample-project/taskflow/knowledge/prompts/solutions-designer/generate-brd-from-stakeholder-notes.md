# Generate BRD from Stakeholder Notes

**Purpose:** Convert raw stakeholder discovery notes into a structured Business Requirements Document draft.
**Role:** Solutions Designer
**Tool:** Claude Code | Cursor | Gemini

## Template

```
Role: You are a solutions designer authoring a Business Requirements Document (BRD).

Context: TaskFlow is an internal task management web app used by ~50 professional services
staff. Business requirements must trace to business objectives. Each requirement gets a
unique ID (BR-XX) and a clear rationale explaining why it matters to the business.

Task: Given the following stakeholder discovery notes, produce a BRD draft with these sections:
1. **Business Objectives** — 3–5 goals the solution must support (numbered BO-01, BO-02, …)
2. **Stakeholder Summary** — who has input, who is affected, who signs off
3. **Business Requirements** — each requirement as:
   - ID: BR-XX
   - Requirement: one sentence, testable, outcome-focused
   - Rationale: one sentence linking it to a Business Objective (BO-XX)
4. **Constraints** — non-negotiable limits (budget, timeline, compliance, technology)
5. **Out of Scope** — what was explicitly excluded to prevent scope creep

Format:
- Markdown
- Requirements must be testable: avoid "easy to use", "fast", "simple"
- Do not include implementation details (no tech stack, no API design)

Constraints:
- Minimum 5 business requirements
- Every requirement must reference at least one Business Objective
- Flag any conflicting requirements with a ⚠️ symbol

Stakeholder notes:
<<<
[PASTE RAW DISCOVERY NOTES, INTERVIEW TRANSCRIPTS, OR MEETING SUMMARIES]
>>>
```

## Example Input

```
Stakeholder notes:
<<<
Meeting with Maria Santos (Head of Delivery) and Leo Reyes (Team Lead):
- Maria: "We waste 30 minutes per week asking who owns what task."
- Maria: "Managers need to see overdue tasks without asking each person."
- Leo: "Team leads should be able to reassign tasks — right now only admins can."
- Leo: "We need to know when a task was last updated, not just when it was created."
- Legal: "All task data must stay on our internal servers — no cloud storage."
- Timeline: Must go live before Q3 (end of September).
- Budget: No new vendors. Must use existing infrastructure.
>>>
```

## Example Output

```
## Business Objectives
- BO-01: Reduce time spent on task status tracking by team leads and managers.
- BO-02: Improve visibility into overdue work without manual check-ins.
- BO-03: Distribute task management responsibilities beyond admin-only users.

## Stakeholder Summary
- Input: Maria Santos (Head of Delivery), Leo Reyes (Team Lead)
- Affected: All ~50 staff users
- Sign-off: Maria Santos

## Business Requirements
| ID | Requirement | Rationale |
|----|-------------|-----------|
| BR-01 | The system must display the current assignee for every task. | Supports BO-01 by eliminating "who owns this?" check-ins. |
| BR-02 | Managers must be able to view all overdue tasks in one screen without navigating per-user. | Supports BO-02. |
| BR-03 | Team leads must be able to reassign tasks to any team member without admin access. | Supports BO-03. |
| BR-04 | Each task must display the date and time of the most recent update. | Supports BO-01 by providing status context without asking. |
| BR-05 | All task data must be stored on internal servers with no external cloud dependencies. | Legal and compliance constraint (BO-01 does not override this). |

## Constraints
- No external cloud storage (legal requirement)
- Live before end of Q3 (September 30)
- No new vendor budget

## Out of Scope
- Email or Slack notification integrations (post-v1)
- Mobile application
- Time tracking
```

## Notes

- Always validate the output against `knowledge/prompts/product/validate-prd-against-brd.md` — BRD requirements that cannot be traced into PRD user stories indicate scope gaps
- If the notes mention "it should be easy/fast/simple", probe for the measurable version before writing the requirement
- Run this prompt with a 3-day cooling period: write the draft, review with stakeholders, then refine
