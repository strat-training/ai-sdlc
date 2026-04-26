# Sprint Status Summary

**Purpose:** Turn raw task status data into a concise stakeholder-facing sprint update.
**Role:** Project Manager
**Tool:** Claude Code | Cursor | Gemini

## Template

```
Role: You are a project manager preparing a sprint status update for stakeholders.

Context: TaskFlow is an internal task management web app (Node.js/Express backend,
React frontend). The team runs 1-week sprints. Stakeholders are non-technical
professional services managers who care about delivery, blockers, and risk — not
implementation details.

Task: Given the following task status data, write a sprint status summary that:
1. Opens with a one-sentence overall health indicator (On Track / At Risk / Blocked)
2. Lists what was completed this sprint (bullet points, plain language)
3. Lists what is in progress and its expected completion
4. Lists any blockers with owner and estimated resolution
5. States the plan for next sprint in 2–3 bullets

Format:
- Plain Markdown, suitable for copy-paste into Slack or email
- No technical jargon (no "REST endpoint", "migration", "PR" — use "feature", "update", "change request")
- Keep it under 300 words

Task status data:
<<<
[PASTE TASK LIST WITH STATUS: DONE / IN PROGRESS / BLOCKED]
>>>
```

## Example Input

```
Task status data:
<<<
T-021: Task detail page — DONE
T-022: Edit task API endpoint — DONE
T-023: Role-based field restrictions — IN PROGRESS (75%, dev says done by EOD)
T-024: Activity log — BLOCKED (waiting on schema change approval from SA)
T-025: Comment section — NOT STARTED
Next sprint: T-026 (file attachments), T-027 (notifications)
>>>
```

## Example Output

```
**Sprint 3 Status: At Risk**

**Completed this sprint:**
- Task detail view is live and working
- Task editing is functional for all users

**In progress:**
- Role-based edit restrictions — expected done today (developer confirms 75% complete)

**Blockers:**
- Activity log (owner: Dev team) is waiting on a schema decision from Solutions Architect.
  Target resolution: tomorrow EOD. If unresolved, this slips to Sprint 4.

**Next sprint plan:**
- Complete activity log (carry over from Sprint 3)
- File attachments feature
- Notifications feature

Risk: If the schema decision slips past tomorrow, Sprint 4 scope needs to be trimmed.
Recommend SA and PM sync today at 3pm.
```

## Notes

- Feed it the DevTasks.md status column directly — no need to reformat first
- If blockers have no owner, flag that in the summary; unowned blockers are higher risk
- Use the output as a first draft — always review before sending to stakeholders
