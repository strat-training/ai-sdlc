# Trainer Guide — Module 5 Exercises (AI-Assisted Development)

Supplements the trainee module. Points trainers to specific TaskFlow files for hands-on exercises.

---

## Exercise 5.2 — Debug a Broken Function

**What to give trainees:** The buggy code snippets from `buggy-functions.md` — one at a time.
**Do NOT give them the solutions section until they have attempted the exercise.**

The same bugs are planted in the live codebase so trainees can also find them there:

| Bug | Live location |
|-----|--------------|
| Bug 1 — off-by-one in overdue detection | `backend/src/utils/taskHelpers.js` — `isTaskOverdue()` |
| Bug 2 — missing await on bcrypt.hash | `backend/src/routes/auth.js` — `POST /api/auth/reset-password` (~line 123) |
| Bug 3 — || vs && in delete auth | `backend/src/routes/tasks.js` — `DELETE /api/tasks/:id` (~line 189) |
| Bug 4 — direct state mutation | `frontend/src/pages/DashboardPage.jsx` — `handleStatusUpdate()` |

**Approach options:**
- **Option A (standalone):** Give trainees the snippet from `buggy-functions.md`. They debug in isolation.
- **Option B (in-context):** Point trainees to the live file. They find and fix the bug in the real codebase.
- **Option B is harder** — there is surrounding code that can distract. Use Option A for beginners.

---

## Exercise 5.3 — Refactor for Testability

**Target file:** `backend/src/routes/tasks.js`

**Why this file:** Every route handler mixes four concerns inline:
1. Input validation
2. Authorization logic
3. Database queries
4. Response formatting

This makes unit testing impossible without a running database. A proper refactor would extract a service layer.

**What to tell trainees:**
> "Open `backend/src/routes/tasks.js`. Pick one route handler — `POST /api/tasks` is a good starting point. The function currently cannot be unit tested without a live SQLite database. Use AI to refactor it for testability while preserving exact behavior. Write tests first to lock in current behavior, then refactor."

**What good looks like:**
- Business logic extracted into a service function (e.g., `createTask(userId, data)`)
- Route handler only handles HTTP concerns (parse req, call service, send res)
- Service function is independently testable with mocked DB

---

## Exercise 5.6 — Debug a Real Issue

**Issue tracker:** `docs/known-issues.md`

Point trainees to this file instead of a real Jira/YouTrack. It contains 6 real bugs with:
- Severity and component
- Reproduction steps
- A hint (but not the fix)
- PRD reference

**Recommended for this exercise:** ISSUE-001 (reset password), ISSUE-002 (delete auth), or ISSUE-004 (state mutation) — these have clear symptoms and clear root causes that AI debugging handles well.

**Avoid for this exercise:** ISSUE-006 (missing route) — it's a missing implementation, not a bug to debug.

---

## Exercise 5.7 — Refactor a Real Component

**Primary target:** `frontend/src/pages/TaskFormPage.jsx`

**Known tech debt in this file:**
1. Error display uses `alert()` instead of in-component error state (line 43, 78) — violates CLAUDE.md
2. Edit mode calls `PATCH /api/tasks/:id` which doesn't exist on the backend
3. `assignee_id` is sent as a string from the `<select>`, but the API validates it as `isInt()`
4. `useEffect` dependency array is missing `isEditing`

**Secondary target:** `backend/src/routes/users.js`

**Known tech debt:**
1. `PATCH /api/users/:id` declares validation but never calls `validationResult(req)` (~line 74)
2. `POST /api/users` uses `Math.random()` for temp password generation (not cryptographically secure)

**What to tell trainees:**
> "Open `frontend/src/pages/TaskFormPage.jsx`. This component has several issues that violate CLAUDE.md rules. Write tests first to lock in the current behavior, then use AI to refactor it to comply with the rules. Verify your tests still pass after the refactor."
