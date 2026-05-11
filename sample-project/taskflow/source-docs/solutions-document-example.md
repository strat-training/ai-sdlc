# Solutions Document
**Project:** Internal Task Management System (TaskFlow)
**Client:** Vertex Group
**Prepared by:** Solutions Architect — [SA writes this on Day 3, before running BRD agent]
**Version:** 1.0 | Date: [Sprint 0 Day 3]

> **Note for trainees:** This is a reference example. The SA generates this document on Day 3
> using the RFP and estimation sheet as inputs, with the solution-architect agent.
> Your solutions document feeds directly into the BRD agent along with the estimation sheet.

---

## 1. Engagement Summary

Vertex Group needs a lightweight internal task management web application to replace
email + spreadsheet task tracking. Phase 1 scope: user auth, task CRUD, status workflow,
dashboard, comments, email notifications, and admin user management.
Full scope and context: see RFP VG-OPS-2026-007 and Estimation Sheet v1.0.

---

## 2. Proposed Tech Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Backend | Node.js + Express (REST API, JavaScript) | Lightweight; fast to set up; no ORM overhead for this data model |
| Database | SQLite (better-sqlite3) | Zero setup; file-based; no managed DB cost; fits the scale (50 users) |
| Frontend | React 18 + Vite (SPA) | Fast dev iteration; component model suits dashboard + task views |
| Styling | Tailwind CSS | Utility-first; consistent design without custom CSS overhead |
| Auth | JWT (8-hour expiry, stateless) | No session store needed; matches client's simple auth requirement |
| Email | Nodemailer + SMTP relay | Sufficient for low-volume transactional email; no third-party dependency |
| Deployment | AWS EC2 (ap-southeast-1) | Client's existing infrastructure; Philippines data residency satisfied |

---

## 3. Data Model

### Core Tables

**users**
- id, name, email, password_hash, role (user/team_lead/admin)
- team, is_active, created_at, updated_at

**tasks**
- id, title, description, assignee_id (FK → users), creator_id (FK → users)
- status (todo/in_progress/done), priority (low/medium/high)
- due_date, created_at, updated_at, deleted_at (soft delete)

**comments**
- id, task_id (FK → tasks), author_id (FK → users), body
- created_at

**activity_log**
- id, task_id (FK → tasks), actor_id (FK → users)
- action (CREATED / STATUS_CHANGED / ASSIGNED / COMMENTED / DELETED)
- old_value, new_value, created_at

**password_reset_tokens**
- id, user_id (FK → users), token_hash, expires_at, used_at

### Access Rules (Application Layer)

- Regular users: read/write own created tasks + assigned tasks only
- Team leads: read all tasks where assignee.team = their team
- Admin: read/write all tasks; manage users

---

## 4. API Design (Express Route Handlers)

| Method | Route | Who | Description |
|--------|-------|-----|-------------|
| POST | /api/auth/login | Public | Email/password login → JWT |
| POST | /api/auth/logout | Any | Invalidate client-side token |
| POST | /api/auth/forgot-password | Public | Send password reset email |
| POST | /api/auth/reset-password | Public | Reset password with token |
| GET | /api/tasks | Any | List tasks (scoped by role) |
| POST | /api/tasks | Any | Create task |
| GET | /api/tasks/:id | Any | Task detail (if visible) |
| PATCH | /api/tasks/:id | Creator/Admin | Edit task fields |
| DELETE | /api/tasks/:id | Creator/Admin | Soft delete task |
| PATCH | /api/tasks/:id/status | Assignee/Admin | Update task status |
| GET | /api/tasks/:id/comments | Any | List task comments |
| POST | /api/tasks/:id/comments | Any | Add comment |
| GET | /api/users | Admin | List all users |
| POST | /api/users | Admin | Create user account |
| PATCH | /api/users/:id | Admin | Activate/deactivate user |

---

## 5. Key Design Decisions

**SQLite over managed PostgreSQL**
At 50 users with ~300 tasks/month, a managed database adds cost and operational
overhead with no benefit at this scale. SQLite with better-sqlite3 is synchronous,
fast, and requires zero setup on the client's existing EC2 instance. Migration path
to PostgreSQL is straightforward if the firm scales.

**Soft delete on all task records**
Tasks use a `deleted_at` timestamp. No hard deletes. All queries filter
`WHERE deleted_at IS NULL`. Reason: 2-year data retention requirement and need
to support audit of "who deleted what."

**Stateless JWT auth (no session store)**
Client has no existing session management infrastructure and does not want to
operate a Redis cluster. JWT with 8-hour expiry is sufficient for the use case.
Password reset tokens are hashed in the database and expire after 1 hour.

**Application-layer RBAC (not DB-level)**
Unlike Supabase RLS, SQLite has no row-level security. Access control is enforced
in Express middleware by checking the authenticated user's role and team against
the resource being accessed. Middleware validates on every request.

**Email via SMTP relay (no third-party SaaS)**
Notification volume is low (~50 users, ~4 trigger types). Nodemailer against
the client's existing SMTP relay avoids a third-party dependency and keeps
data within the client's environment.

---

## 6. UI/UX Approach

Three distinct layouts driven by role. Key screens:

**Regular User:**
1. Dashboard — status summary cards (To Do / In Progress / Done / Overdue) + task list
2. Task Form — create/edit with inline validation; due date picker
3. Task Detail — full info + status toggle + comment thread + activity log

**Team Lead:**
1. Dashboard — personal section + team tasks section (same page, below)

**Admin:**
1. User Management — user table with Create User button and Activate/Deactivate toggle

Status badge color system: To Do = grey, In Progress = blue, Done = green, Overdue = red.
Priority badge: Low = grey, Medium = yellow, High = red.

---

## 7. Non-Functional Requirements

- API response time: < 500ms at p95 under expected load
- Page load: < 2 seconds (client requirement from RFP)
- Data residency: AWS ap-southeast-1 (Philippines) — no data leaves the region
- Browser support: Chrome, Edge (latest) — desktop only
- Data retention: minimum 2 years (soft delete pattern)
- Uptime: accessible during business hours (8am–7pm PHT, Mon–Fri)

---

## 8. Delivery Plan

| Sprint | Scope |
|--------|-------|
| Sprint 0 | Setup, BRD, PRD, Architecture, Dev Tasks, environment validation |
| Sprint 1 | Auth (login, logout, password reset) + Task CRUD + Status workflow |
| Sprint 2 | Dashboard + Comments + Activity Log + Notifications |
| Sprint 3 | Admin (User Management) + UAT fixes + deployment + go-live |

---

## 9. Open Items (Resolve Before Sprint 1)

- [ ] Confirm client's SMTP relay credentials and allowed sender domain
- [ ] Confirm client will provide initial user list (name, email, role, team) for seed data
- [ ] Validate EC2 instance specs (RAM, storage) before deploying SQLite at expected data volume
- [ ] Confirm: are there sub-teams within each team, or is one level of team hierarchy sufficient for v1?
