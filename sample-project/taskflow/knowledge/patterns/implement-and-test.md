# Pattern: Implement and Test a Dev Task

A 4-step prompt chain for implementing a TaskFlow backend endpoint end-to-end.

---

## Step 1 — Load context and plan

```
Load: docs/artifacts/ArchitectureDocument.md, docs/artifacts/DevTasks.md, .claude/CLAUDE.md

Prompt:
"I am implementing [TASK ID]: [TASK DESCRIPTION]. Before writing any code,
give me an implementation plan covering: (1) endpoint signature and validation rules,
(2) DB queries needed, (3) authorization logic, (4) error cases to handle,
(5) what to log in activity_log if applicable."
```

Wait for plan. Review it. Correct any misunderstandings before proceeding.

---

## Step 2 — Implement the endpoint

```
"Implement the plan. Follow CLAUDE.md standards exactly:
- express-validator for all inputs
- Standard error format: { success: false, error: { code, message } }
- Parameterized queries only
- No sensitive fields in responses"
```

Review the diff. Check auth logic line by line.

---

## Step 3 — Generate tests

```
"Now generate Jest + Supertest tests for this endpoint covering:
1. Happy path (valid request, correct response)
2. Missing/invalid input (400 responses)
3. Auth: unauthenticated (401), wrong role (403)
4. Edge cases from the acceptance criteria"
```

Run the tests. Fix failures before moving on.

---

## Step 4 — Self-review

```
"Act as the code-reviewer agent. Review the implementation and tests you just wrote.
Check for: auth bypass, missing validationResult(), exposed sensitive fields,
direct state mutation (if frontend), alert() instead of error state (if frontend).
Cite line numbers for every issue."
```

Fix any Critical or High issues before committing.

---

## Commit

```
git add [specific files]
git commit -m "T-0XX: [Task description]"
```
