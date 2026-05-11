# Request for Proposal (RFP)
**Issued by:** Vertex Group — Operations Department
**Project:** Internal Task Management System (TaskFlow)
**RFP Reference:** VG-OPS-2026-007
**Issued:** 2026-02-15 | **Proposal Deadline:** 2026-03-05

---

## 1. Company Background

Vertex Group is a mid-sized professional services firm with approximately 50 staff across
two offices (Makati HQ, BGC satellite). All staff use company-issued email accounts
(@vertexgroup.ph). There is no existing task management system — all work tracking is
done via email threads and shared spreadsheets.

**Volume:** ~300 tasks created per month across teams. Current avg time to discover a
missed deadline: 2–3 days after the fact. Estimated rework rate due to miscommunication:
~20% of tasks require a second pass because the original brief was unclear or lost.

**Productivity trigger:** Leadership identified in Q4 2025 that team leads spend 30–45
minutes per week manually compiling status reports. This overhead scales poorly as the
firm grows and is the primary driver of this initiative.

---

## 2. User Roles

The system must support three distinct roles with different access levels:

**Regular User (~45 users)**
- The primary user of the system
- Creates tasks, assigns tasks to teammates, views and updates their own assigned tasks
- Can only see tasks they created or are assigned to

**Team Lead (~4 users)**
- All regular user capabilities
- Can view all tasks within their team regardless of assignee
- Monitors overdue tasks and team workload

**Admin (1–2 users, IT team)**
- All team lead capabilities across all teams
- Manages user accounts (create, deactivate users)
- Can delete any task in the system

---

## 3. Functional Requirements

### 3.1 Authentication

Users must be able to log in with their company email and password:
- Standard email/password login — no SSO required for v1
- Sessions must persist for at least 8 hours without requiring re-login
- Users must be able to log out from any page
- A "Forgot Password" flow must allow users to reset via email

Password reset rules:
- Reset email must arrive within 2 minutes of request
- Reset link must expire after 1 hour
- New password must be at least 8 characters

### 3.2 Task Creation

Users must be able to create a task through a form with the following fields:
- **Title** (required): text field, max 200 characters
- **Description** (optional): free text
- **Assignee** (required): dropdown of active users
- **Due Date** (required): date picker
- **Priority** (required): Low / Medium / High

Business rules:
- Task creator is recorded automatically
- Task is visible immediately after creation
- Every task must have exactly one assignee
- Every task must have a due date

### 3.3 Task Management

Users must be able to edit tasks they created:
- Any field from the creation form can be updated
- Only the task creator or an admin can delete a task
- Tasks deleted by admin are soft-deleted (record preserved)
- Tasks cannot be re-opened once marked as Done (v1 constraint)

### 3.4 Task Status Tracking

Tasks must move through a defined status lifecycle:
- **To Do** → **In Progress** → **Done**
- Assignee can update status at any time
- Tasks past their due date and not Done must be visually flagged as overdue

### 3.5 Dashboard

Each user must see a personal dashboard upon login showing:
- Count of tasks by status (To Do, In Progress, Done, Overdue)
- List of their assigned tasks, sorted by due date (soonest first)
- Overdue tasks highlighted with a distinct visual indicator

Team leads must additionally see:
- A team task list showing all tasks for their direct reports
- Same overdue highlighting

### 3.6 Comments and Activity

Each task must support a comment thread:
- Any user with task visibility can add a comment
- Comments display: author name, timestamp, comment text
- Activity log on each task records status changes with actor and timestamp

### 3.7 Notifications (Email)

| Trigger | Recipient | Subject line |
|---------|-----------|-------------|
| Task assigned to user | Assignee | You have been assigned a new task: [Task Title] |
| Task status updated | Creator | Task update: [Task Title] is now [Status] |
| Task due in 1 day | Assignee | Reminder: [Task Title] is due tomorrow |
| Task becomes overdue | Assignee + Creator | Overdue: [Task Title] was due [Date] |

### 3.8 User Management (Admin)

Admin users must be able to:
- Create new user accounts (name, email, role, team)
- Deactivate a user account (user cannot log in; their tasks remain)
- View a list of all users with their role and status

---

## 4. User Experience Requirements

The system must be simple enough for non-technical users.

**Regular User — Key Screens:**
1. **Dashboard** — status summary cards + assigned task list, clear overdue indicators
2. **Create / Edit Task** — clean form, inline validation, immediate save feedback
3. **Task Detail** — full task info, status update button, comment thread, activity log

**Team Lead — Key Screens:**
1. **Dashboard** — personal view + team task section below
2. **Team Tasks** — filterable list of all team tasks by status and assignee

**Admin — Key Screens:**
1. **User Management** — user list with create and deactivate actions

**Design direction:** Clean, minimal, functional. No unnecessary complexity.
Status badges: To Do = grey, In Progress = blue, Done = green, Overdue = red.
Desktop browser only for v1 (Chrome and Edge).

---

## 5. Technical Requirements

- **Authentication:** Email/password with secure session management (JWT)
- **Hosting:** Client's existing AWS environment (ap-southeast-1, Philippines region)
- **Data residency:** All data must remain within the Philippines
- **Availability:** Accessible during business hours (8am–7pm PHT, Mon–Fri)
- **Performance:** Pages and API responses must load within 2 seconds
- **Browser support:** Chrome and Edge (latest versions) — desktop only
- **Data retention:** Task records must be retained for minimum 2 years

---

## 6. Out of Scope (v1)

- Native mobile application (iOS/Android)
- SSO / SAML integration
- Advanced reporting and analytics
- File attachments on tasks
- Recurring tasks
- Third-party integrations (Slack, JIRA, etc.)
- Time tracking
- Multi-team hierarchy / sub-team support

---

## 7. Deliverables Expected

From the selected vendor:
- Technical proposal and solution architecture
- Project plan with sprint breakdown
- Team composition
- Fixed-price quotation
- Deployed MVP within 6 weeks of project start

---

## 8. Timeline

| Milestone | Date |
|-----------|------|
| RFP issued | 2026-02-15 |
| Proposal deadline | 2026-03-05 |
| Award and contract | 2026-03-12 |
| Sprint 0 kickoff | 2026-03-16 |
| Target go-live | 2026-04-27 |

---

## 9. Contact

**Maria Santos** — Product Owner, Vertex Group
**Ben Cruz** — IT Administrator, Vertex Group
