# TaskFlow — Known Issues

Use this as your issue tracker for Module 5 Exercise 5.6 (Debug a Real Issue).
Pick any issue below, reproduce it, diagnose it with AI, then fix it and write a test that would have caught it.

---

## ISSUE-001: Password reset silently fails — old password still works after reset
**Severity:** Critical
**Component:** `backend/src/routes/auth.js` — `POST /api/auth/reset-password`
**Symptom:** API returns `{ success: true }` and HTTP 200. But the old password still works for login. New password never works.
**Steps to reproduce:**
1. Call `POST /api/auth/forgot-password` with a valid email
2. Get the reset token from the DB (or console log)
3. Call `POST /api/auth/reset-password` with the token and a new password
4. Try logging in with the new password → fails
5. Try logging in with the old password → still works
**Hint:** No error is thrown. The update runs. The problem is in what gets stored.
**PRD reference:** US-02

---

## ISSUE-002: Any logged-in user can delete any task — 403 never returned
**Severity:** Critical
**Component:** `backend/src/routes/tasks.js` — `DELETE /api/tasks/:id`
**Symptom:** A regular user who did not create the task can delete it. No 403 is returned. The task is soft-deleted.
**Steps to reproduce:**
1. Log in as User A, create a task
2. Log in as User B (different user, not admin)
3. Call `DELETE /api/tasks/{taskId}` as User B → expect 403, get 200
**Hint:** The authorization condition uses a logical operator incorrectly.
**PRD reference:** US-05

---

## ISSUE-003: Overdue tasks show wrong — some overdue tasks not highlighted, some not-overdue tasks highlighted
**Severity:** High
**Component:** `backend/src/utils/taskHelpers.js` — `isTaskOverdue()`
**Symptom:** On the dashboard, a task due yesterday shows as not overdue. A task due today shows as overdue even though it is still the same day.
**Steps to reproduce:**
1. Create a task with `due_date` = yesterday's date
2. Create a task with `due_date` = today's date
3. Check dashboard — yesterday's task should be overdue, today's should not be (yet)
4. Results are inconsistent depending on time of day and timezone
**Hint:** The bug is timezone-related. Compare date strings instead of Date objects.
**PRD reference:** US-08

---

## ISSUE-004: Task status update on dashboard doesn't reflect in UI until page refresh
**Severity:** Medium
**Component:** `frontend/src/pages/DashboardPage.jsx` — `handleStatusUpdate()`
**Symptom:** After updating a task's status from the detail page and navigating back to the dashboard, the old status is still shown. Refreshing the page shows the correct status. React DevTools shows the state has the correct value.
**Steps to reproduce:**
1. Go to dashboard, note a task's status
2. Open the task, update the status
3. Navigate back to dashboard
4. Task still shows old status — but React DevTools shows correct value in state
**Hint:** React is not re-rendering. Think about what triggers a re-render.
**PRD reference:** US-06, US-08

---

## ISSUE-005: GET /api/tasks/:id/comments returns comments for tasks the user cannot access
**Severity:** High
**Component:** `backend/src/routes/tasks.js` — `GET /api/tasks/:id/comments`
**Symptom:** A regular user who is not the assignee or creator of a task can still fetch all its comments by calling the comments endpoint directly.
**Steps to reproduce:**
1. Log in as User A, create a task assigned to User B
2. Log in as User C (unrelated user)
3. Call `GET /api/tasks/{taskId}/comments` as User C → should get 403, gets 200 with comments
**Hint:** The GET comments route does not check access before returning data.
**PRD reference:** US-10

---

## ISSUE-006: PATCH /api/tasks/:id returns 404 — editing a task always fails
**Severity:** High
**Component:** `backend/src/routes/tasks.js`
**Symptom:** The edit task form submits successfully from the frontend but always gets a 404 response. The task is never updated.
**Steps to reproduce:**
1. Open an existing task
2. Click Edit, change any field, click Save
3. Network tab shows `PATCH /api/tasks/{id}` → 404
**Hint:** Check whether the route exists in the backend.
**PRD reference:** US-04
