\# Dev Tasks Document
## TaskFlow — Sprint Breakdown

**Version:** 1.0
**Generated from:** PRD v1.0
**Prepared by:** Solutions Architect / Tech Lead
**Status:** Reviewed & Approved

---

## Project Setup Tasks

| ID | Task | Assignee | Est. | Status | PRD Ref |
|----|------|----------|------|--------|---------|
| T-001 | Initialize Node.js/Express backend project with folder structure | Dev | 1h | To Do | — |
| T-002 | Initialize React + Vite frontend project | Dev | 1h | To Do | — |
| T-003 | Set up SQLite database with better-sqlite3 | Dev | 1h | To Do | — |
| T-004 | Configure ESLint, Prettier, and .env handling | Dev | 1h | To Do | — |
| T-005 | Write database migration scripts (users, tasks, comments, activity_log tables) | Dev | 2h | To Do | — |
| T-006 | Set up Jest for backend testing | Dev | 1h | To Do | — |
| T-007 | Set up React Testing Library for frontend | Dev | 1h | To Do | — |
| T-008 | Configure CORS, Helmet, and rate limiting middleware | Dev | 1h | To Do | — |

---

## Feature 1: Authentication

| ID | Task | Assignee | Est. | Status | PRD Ref |
|----|------|----------|------|--------|---------|
| T-010 | Create User model and migration (id, name, email, password_hash, role, team, is_active, created_at) | Dev | 1h | To Do | US-01 |
| T-011 | Implement POST /api/auth/login endpoint (validate credentials, return JWT) | Dev | 2h | To Do | US-01 |
| T-012 | Implement JWT middleware for protected routes | Dev | 1h | To Do | US-01 |
| T-013 | Implement POST /api/auth/logout endpoint (client-side token invalidation) | Dev | 30m | To Do | US-01 |
| T-014 | Implement POST /api/auth/forgot-password (generate reset token, send email) | Dev | 2h | To Do | US-02 |
| T-015 | Implement POST /api/auth/reset-password (validate token, update password) | Dev | 1h | To Do | US-02 |
| T-016 | Build Login page component (form, validation, error states) | Dev | 3h | To Do | US-01 |
| T-017 | Build Forgot Password page component | Dev | 2h | To Do | US-02 |
| T-018 | Write unit tests for auth endpoints | Dev | 2h | To Do | US-01, US-02 |

---

## Feature 2: Task Management

| ID | Task | Assignee | Est. | Status | PRD Ref |
|----|------|----------|------|--------|---------|
| T-020 | Create Task model and migration (id, title, description, assignee_id, creator_id, due_date, priority, status, is_deleted, created_at, updated_at) | Dev | 1h | To Do | US-03 |
| T-021 | Implement POST /api/tasks (create task) | Dev | 2h | To Do | US-03 |
| T-022 | Implement GET /api/tasks (list tasks — scoped by role) | Dev | 2h | To Do | US-08 |
| T-023 | Implement GET /api/tasks/:id (task detail) | Dev | 1h | To Do | US-07 |
| T-024 | Implement PATCH /api/tasks/:id (edit task — role-based field restrictions) | Dev | 3h | To Do | US-04 |
| T-025 | Implement DELETE /api/tasks/:id (soft delete — creator/admin only) | Dev | 1h | To Do | US-05 |
| T-026 | Implement PATCH /api/tasks/:id/status (update status — assignee/admin) | Dev | 1h | To Do | US-06 |
| T-027 | Implement activity log writes on task create/edit/status change | Dev | 2h | To Do | US-04, US-06 |
| T-028 | Build TaskForm component (create/edit, validation, unsaved changes prompt) | Dev | 4h | To Do | US-03, US-04 |
| T-029 | Build TaskDetail component (full view, activity log, status badge) | Dev | 3h | To Do | US-07 |
| T-030 | Build TaskCard component (summary view for dashboard lists) | Dev | 2h | To Do | US-08 |
| T-031 | Implement overdue task detection (due_date < today AND status != Done) | Dev | 1h | To Do | US-08 |
| T-032 | Write unit tests for task CRUD endpoints | Dev | 3h | To Do | US-03–US-07 |
| T-033 | Write unit tests for role-based access rules on task endpoints | Dev | 2h | To Do | US-04, US-05 |

---

## Feature 3: Dashboard

| ID | Task | Assignee | Est. | Status | PRD Ref |
|----|------|----------|------|--------|---------|
| T-040 | Build MyTasks dashboard page (sorted list, filters, overdue highlight, summary counts) | Dev | 4h | To Do | US-08 |
| T-041 | Build TeamDashboard page (all team tasks, assignee/status/priority filters) | Dev | 3h | To Do | US-09 |
| T-042 | Implement CSV export for team dashboard | Dev | 2h | To Do | US-09 |
| T-043 | Implement dashboard summary count queries (total, overdue, due today, done) | Dev | 1h | To Do | US-08 |

---

## Feature 4: Comments & Activity

| ID | Task | Assignee | Est. | Status | PRD Ref |
|----|------|----------|------|--------|---------|
| T-050 | Create Comment model and migration (id, task_id, user_id, content, created_at) | Dev | 30m | To Do | US-10 |
| T-051 | Implement POST /api/tasks/:id/comments (add comment) | Dev | 1h | To Do | US-10 |
| T-052 | Implement GET /api/tasks/:id/comments (list comments) | Dev | 30m | To Do | US-10 |
| T-053 | Build CommentSection component (comment list + add comment form) | Dev | 3h | To Do | US-10 |

---

## Feature 5: User Management (Admin)

| ID | Task | Assignee | Est. | Status | PRD Ref |
|----|------|----------|------|--------|---------|
| T-060 | Implement GET /api/users (list users — admin only) | Dev | 1h | To Do | US-11 |
| T-061 | Implement POST /api/users (create user — admin only) | Dev | 2h | To Do | US-11 |
| T-062 | Implement PATCH /api/users/:id (activate/deactivate — admin only, not self) | Dev | 1h | To Do | US-11 |
| T-063 | Build UserManagement page (admin only) | Dev | 3h | To Do | US-11 |

---

## Cross-Cutting Tasks

| ID | Task | Assignee | Est. | Status | Notes |
|----|------|----------|------|--------|-------|
| T-070 | Implement global error handler middleware (consistent API error format) | Dev | 1h | To Do | — |
| T-071 | Implement input validation middleware (express-validator) | Dev | 2h | To Do | — |
| T-072 | Implement request logging (Morgan) | Dev | 30m | To Do | — |
| T-073 | Build shared UI components: Button, Input, Modal, Badge, Spinner | Dev | 3h | To Do | — |
| T-074 | Build navigation/sidebar component with role-based menu items | Dev | 2h | To Do | — |
| T-075 | Set up React Router with protected routes (auth guard) | Dev | 1h | To Do | — |
| T-076 | Build NotFound (404) and Unauthorized (403) pages | Dev | 1h | To Do | — |
| T-077 | Write integration tests for full task lifecycle | Dev | 3h | To Do | — |
| T-078 | Write README with setup, running, and testing instructions | Dev | 1h | To Do | — |

---

## Total Estimates

| Category | Hours |
|----------|-------|
| Project Setup | 9h |
| Authentication | 14.5h |
| Task Management | 27h |
| Dashboard | 10h |
| Comments & Activity | 5h |
| User Management | 7h |
| Cross-Cutting | 14.5h |
| **Total** | **87h** |
