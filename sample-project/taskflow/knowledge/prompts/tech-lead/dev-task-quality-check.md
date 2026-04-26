# Dev Task Quality Check

**Purpose:** Verify that a set of generated Dev Tasks meets sizing, atomicity, and traceability standards before handing off to developers.
**Role:** Tech Lead
**Tool:** Claude Code | Cursor

## Template

```
Role: You are a tech lead reviewing developer tasks before sprint assignment.

Context: TaskFlow uses Node.js/Express backend, React + Vite frontend, SQLite database.
Dev tasks must be independently completable by one developer in 1–4 hours. Tasks must
trace to a PRD user story (US-XX). Acceptance criteria must be specific enough that a
developer can start without asking questions.

Task: Review the following dev tasks and flag any that fail these quality gates:

Quality gates (flag with severity):
- [BLOCKER] No PRD reference — task cannot be traced to a user story
- [BLOCKER] Scope too large — task will realistically take >4 hours
- [BLOCKER] Ambiguous acceptance criteria — a developer would need to ask before starting
- [WARNING] Missing test task — a feature task has no corresponding test task
- [WARNING] Layer mismatch — task description mixes BE and FE work that should be split
- [WARNING] Implicit dependency — task assumes another task is done but doesn't say so

For each flagged task, provide:
1. The task ID and the gate it fails
2. One sentence explaining the specific problem
3. A suggested fix (rewrite or split the task)

At the end, provide a summary: total tasks reviewed, blockers found, warnings found,
and a go/no-go recommendation for sprint assignment.

Dev tasks to review:
<<<
[PASTE DEV TASKS HERE — include ID, description, layer, estimated hours, and PRD reference]
>>>
```

## Example Input

Load `docs/artifacts/DevTasks.md` and `docs/artifacts/PRD.md` as context, then:

```
Dev tasks to review:
<<<
T-030 | Build the full comment feature including API, database, and UI | Both | 8h | US-10
T-031 | Create Comment model and DB migration | BE | 1h | US-10
T-032 | Implement POST /api/tasks/:id/comments | BE | 1h | US-10
T-033 | Add comment display to task detail page | FE | 3h | US-10
T-034 | Make the comment section look good | FE | 2h | (none)
>>>
```

## Example Output

```
**Review: 5 tasks**

---

**[BLOCKER] T-030** — Scope too large
Task mixes DB, API, and UI work estimated at 8h. A developer cannot complete this
atomically without overlapping with T-031–T-033.
→ Fix: Remove T-030 entirely. T-031–T-033 already cover this scope at the right
  granularity.

**[BLOCKER] T-034** — No PRD reference + Ambiguous acceptance criteria
"Look good" is not testable. No user story is referenced.
→ Fix: Either tie this to a specific acceptance criterion in US-10 (e.g., "Comments
  display author name and relative timestamp") or fold the requirement into T-033's
  acceptance criteria.

**[WARNING] T-031–T-033** — Missing test task
Three feature tasks with no corresponding test task.
→ Fix: Add T-035: "Write integration tests for comment API endpoints" (BE, 1h, US-10).

---

**Summary:** 5 tasks reviewed | 2 blockers | 1 warning
**Recommendation: NO-GO.** Resolve T-030 and T-034 before sprint assignment.
Add missing test task.
```

## Notes

- Always load `docs/artifacts/PRD.md` as context so the AI can verify US-XX references exist
- Run this before every sprint planning session — catching blockers here saves mid-sprint scope churn
- The "scope too large" check is the most commonly missed: tasks written as "implement X feature" almost always need splitting
- For ADR compliance checks, see `architecture-deviation-flag.md` (contribute that next)
