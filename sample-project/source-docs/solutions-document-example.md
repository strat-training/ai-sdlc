# Solutions Document
**Project:** Leave Management System (LMS)
**Client:** Meridian Corp
**Prepared by:** Solutions Architect — [SA writes this on Day 3, before running BRD agent]
**Version:** 1.0 | Date: [Sprint 0 Day 3]

> **Note for trainees:** This is a reference example. The SA generates this document on Day 3
> using the RFP and estimation sheet as inputs, with the solution-architect agent.
> Your solutions document feeds directly into the BRD agent along with the estimation sheet.

---

## 1. Engagement Summary

Meridian Corp needs a self-service Leave Management System to replace email + Excel.
Phase 1 scope: leave submission, manager approval, HR admin, notifications, audit log.
Full scope and context: see RFP MC-HR-2026-001 and Estimation Sheet v1.0.

---

## 2. Proposed Tech Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Framework | Next.js 15 (App Router, TypeScript) | Full-stack; SSR + API routes in one codebase |
| Database + Auth | Supabase (PostgreSQL + RLS + Auth) | Managed Postgres; built-in auth; RLS replaces custom RBAC middleware |
| Styling | Tailwind CSS | Rapid UI development; consistent design system |
| File Storage | Supabase Storage | Sick leave document uploads |
| Email | Resend API | Reliable transactional email; simple API |
| Deployment | Vercel (frontend) + Supabase cloud | Zero-ops; client has no infra team |
| Auth Provider | Supabase Auth (email + magic link) | Managed auth; RLS ties directly to auth.uid() |
| UI Prototype | Figma Make | AI-generated prototype from RFP screen descriptions |

---

## 3. Data Model

### Core Tables

**profiles** (extends Supabase auth.users)
- id, email, full_name, role (employee/manager/hr_admin/sys_admin)
- manager_id (self-referential FK → manager's profile)
- department, created_at, updated_at

**leaves**
- id, employee_id (FK → profiles), leave_type, start_date, end_date
- reason, supporting_doc_url, status (PENDING/APPROVED/REJECTED/CANCELLED)
- manager_note, created_at, updated_at, deleted_at (soft delete)

**leave_balances**
- id, employee_id, leave_type, year, total_days, used_days
- UNIQUE (employee_id, leave_type, year)

**leave_types**
- id, name, default_days, allow_carryover, is_active

**audit_log**
- id, table_name, record_id, action, actor_id
- old_data (JSONB), new_data (JSONB), created_at

### Row Level Security (RLS) Rules

- Employees: SELECT own leaves only; INSERT own leaves only
- Managers: SELECT leaves of direct reports (WHERE employee_id IN direct_reports)
- HR Admin: SELECT/UPDATE all leaves
- Sys Admin: profiles table management only

---

## 4. API Design (Next.js Route Handlers)

| Method | Route | Who | Description |
|--------|-------|-----|-------------|
| POST | /api/leaves | Employee | Submit leave request |
| GET | /api/leaves | Employee/Manager/HR | List leaves (scoped by RLS) |
| PATCH | /api/leaves/[id] | Manager/Employee/HR | Approve, reject, cancel, override |
| GET | /api/balances | Employee | Own leave balances |
| GET | /api/team/calendar | Manager | Team availability calendar |
| GET | /api/admin/leaves | HR Admin | All leaves with filters |
| POST | /api/admin/entitlements | HR Admin | Set/update entitlements |
| POST | /api/admin/entitlements/import | HR Admin | CSV bulk import |
| GET | /api/admin/reports | HR Admin | Leave utilization + department summary |
| GET | /api/admin/audit | HR Admin | Audit log with filters |

---

## 5. Key Design Decisions

**Soft delete on all business records**
All leave records use a `deleted_at` timestamp. Never hard delete.
Reason: labor law requires 5-year data retention; audit log requires complete history.
All queries must filter `WHERE deleted_at IS NULL`.

**Supabase RLS replaces RBAC middleware**
Instead of a custom RBAC middleware layer, Supabase Row Level Security policies
enforce data access at the database level. This reduces code complexity and eliminates
an entire class of authorization bugs.

**Async email via Resend API**
Email notifications are sent asynchronously after the database write succeeds.
API response does not wait for email delivery. Failures are logged but do not
roll back the leave state change.

**Supabase Auth (email + magic link)**
Employees log in with their company email address. Supabase Auth handles session management
and issues JWTs. On first login, a database trigger creates the profile record linked to
auth.users. No external identity provider dependency — simplifies setup and operations.

---

## 6. UI/UX Approach

Prototype to be generated in Sprint 0 using Figma Make from the RFP screen descriptions.
Key screens to prototype before Sprint 1 coding begins:

**Employee flows:**
1. Dashboard — balance cards + recent requests + "New Request" CTA
2. Submit Leave Request — form with live balance display and conflict warning
3. My Requests — list with status badges + request detail slide-over

**Manager flows:**
1. Pending Approvals — list with oldest-first sort + approve/reject modal
2. Team Calendar — monthly view, color-coded leave types

**HR Admin flows:**
1. All Requests — table with filters + CSV export
2. Entitlement Management — employee grid with inline edit + CSV import
3. Reports — report type selector + date range + preview + export

---

## 7. Non-Functional Requirements

- API response time: < 500ms at p95
- Page load: < 2 seconds (client requirement from RFP)
- Availability: 99.5% during business hours (8am–8pm PHT)
- Concurrent users: up to 1,000
- Data retention: minimum 5 years (labor law)
- Browser support: Chrome, Edge, Safari, Firefox (latest)

---

## 8. Delivery Plan

| Sprint | Scope |
|--------|-------|
| Sprint 0 | Setup, BRD, PRD, Figma prototype, Architecture, Dev Tasks |
| Sprint 1 | Auth + Leave Submission + Manager Approval |
| Sprint 2 | Balance + HR Admin + Team Calendar |
| Sprint 3 | Reporting + Notifications + Audit Log |
| Sprint 4 | UAT, hardening, deployment, go-live |

---

## 9. Open Items (Resolve Before Sprint 1)

- [ ] Confirm company email domain (@meridian.com) for Supabase Auth allow-list
- [ ] Resend domain verification for Meridian Corp email domain
- [ ] HR to provide initial entitlements CSV (employee list + days per leave type)
- [ ] Confirm: are Philippine public holidays to be excluded from working day calculation in Phase 1?
