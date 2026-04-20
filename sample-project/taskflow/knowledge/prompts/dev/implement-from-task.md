# Implement from Dev Task

**Purpose:** Generate architecture-aware code for a specific dev task with plan-first approach.
**Role:** Dev
**Tool:** Claude Code (load files as context)

## Template

```
Role: You are a senior Node.js developer implementing a REST API endpoint.

Context: [LOAD ARCHITECTURE DOCUMENT AND DEV TASKS AS FILES]

Task: Implement the following dev task. Before writing code:
1. State your implementation plan (components, data flow, error cases)
2. Wait for my approval of the plan
3. Then write the code

Requirements:
- Follow the existing project patterns in the loaded files
- Include input validation using express-validator
- Return errors in the standard format: { success: false, error: { code, message } }
- Write comments for non-obvious logic only

Dev task:
<<<
[PASTE TASK DESCRIPTION + ACCEPTANCE CRITERIA]
>>>
```

## Example Input

Load `docs/artifacts/ArchitectureDocument.md`, `docs/artifacts/DevTasks.md`, and `CLAUDE.md`, then:

```
Dev task:
<<<
T-024: Implement PATCH /api/tasks/:id (edit task — role-based field restrictions)

Acceptance criteria:
- Task creator can edit all fields (title, description, assignee, due date, priority)
- Assignee can only edit description and status
- All edits are logged in the activity_log with timestamp and user
- Returns 403 if user is neither creator nor assignee nor admin
>>>
```

## Notes

- Always load CLAUDE.md — it contains coding standards the AI must follow
- Insist on the plan step — skipping it produces code that misses edge cases
- Review the diff carefully before accepting; check auth logic especially
