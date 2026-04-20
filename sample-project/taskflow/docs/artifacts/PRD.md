# Product Requirements Document (PRD)
## TaskFlow — Internal Task Management Web Application

**Version:** 1.0  
**Date:** March 2026  
**Prepared by:** Product Manager  
**Reviewed by:** Solutions Architect  
**Status:** Approved

---

## 1. Overview

TaskFlow is a lightweight web application that enables teams to create, assign, track, and manage tasks. It replaces email-based task tracking with a centralized, real-time system.

**Target users:** ~50 internal staff (regular users) + team leads  
**Platform:** Web (Chrome, Edge) — desktop only for v1  
**Deployment:** AWS (ap-southeast-1, Philippines region)

---

## 2. User Personas

### 2.1 Regular User (Staff)
- Creates tasks for themselves or assigns to teammates
- Views and updates their own assigned tasks
- Marks tasks complete

### 2.2 Team Lead
- All regular user capabilities
- Views all tasks within their team
- Monitors overdue tasks

### 2.3 Admin
- All team lead capabilities across all teams
- Manages users (create, deactivate)
- Can delete any task

---

## 3. Features & User Stories

### Feature 1: Authentication

**US-01: User Login**
> As a user, I want to log in with my email and password so that I can access my tasks securely.

Acceptance Criteria:
- [ ] User can enter email and password on the login page
- [ ] Valid credentials redirect to dashboard
- [ ] Invalid credentials show an error message (do not reveal which field is wrong)
- [ ] Session persists for 8 hours (JWT)
- [ ] User can log out from any page

**US-02: Password Reset**
> As a user, I want to reset my password via email so that I can regain access if I forget it.

Acceptance Criteria:
- [ ] "Forgot password" link on login page
- [ ] User receives a reset email within 2 minutes
- [ ] Reset link expires after 1 hour
- [ ] New password must be at least 8 characters

---

### Feature 2: Task Management

**US-03: Create Task**
> As a user, I want to create a task so that I can track work that needs to be done.

Acceptance Criteria:
- [ ] Task form has: title (required), description (optional), assignee (required), due date (required), priority (Low/Medium/High)
- [ ] Title max length: 200 characters
- [ ] Task is saved and visible immediately after creation
- [ ] Creator is recorded automatically

**US-04: Edit Task**
> As a user, I want to edit a task I created so that I can update its details as work evolves.

Acceptance Criteria:
- [ ] Task creator can edit all fields
- [ ] Assignee can edit status and description only
- [ ] All edits are logged in the activity log with timestamp and user
- [ ] Unsaved changes prompt a confirmation before navigating away

**US-05: Delete Task**
> As a task creator or admin, I want to delete a task so that I can remove tasks that are no longer relevant.

Acceptance Criteria:
- [ ] Only creator or admin can delete
- [ ] Deletion requires confirmation dialog
- [ ] Deleted tasks are soft-deleted (retained in DB, not shown in UI)

**US-06: Update Task Status**
> As an assignee, I want to update the status of my task so that my team knows where things stand.

Acceptance Criteria:
- [ ] Status options: To Do, In Progress, Done
- [ ] Status change is logged in activity log
- [ ] Done tasks cannot be re-opened in v1
- [ ] Status badge is color-coded (To Do: grey, In Progress: blue, Done: green)

**US-07: View Task Detail**
> As a user, I want to view a task's full details so that I can understand what needs to be done.

Acceptance Criteria:
- [ ] Detail view shows: title, description, assignee, creator, due date, priority, status, created date, activity log
- [ ] Activity log shows all changes in chronological order

---

### Feature 3: Dashboard

**US-08: My Tasks Dashboard**
> As a user, I want to see all my assigned tasks on a dashboard so that I can prioritize my work.

Acceptance Criteria:
- [ ] Dashboard shows all tasks assigned to logged-in user
- [ ] Overdue tasks (past due date, not Done) are highlighted in red
- [ ] Tasks sorted by due date (ascending) by default
- [ ] Filter by status: All / To Do / In Progress / Done
- [ ] Task count summary: total, overdue, due today, completed

**US-09: Team Dashboard (Team Lead)**
> As a team lead, I want to see all my team's tasks so that I can monitor progress without manual check-ins.

Acceptance Criteria:
- [ ] Accessible only to team leads and admins
- [ ] Shows all tasks created by or assigned to team members
- [ ] Filter by assignee, status, priority
- [ ] Export to CSV (basic — title, assignee, due date, status)

---

### Feature 4: Comments & Activity

**US-10: Add Comment**
> As a user, I want to add a comment to a task so that I can communicate progress without email.

Acceptance Criteria:
- [ ] Comment box on task detail page
- [ ] Comments show author name and timestamp
- [ ] Comments cannot be edited or deleted in v1
- [ ] Max comment length: 1000 characters

---

### Feature 5: User Management (Admin)

**US-11: Manage Users**
> As an admin, I want to create and deactivate user accounts so that I can control system access.

Acceptance Criteria:
- [ ] Admin can create users with: name, email, role (user/team lead/admin), team
- [ ] Admin can deactivate users (deactivated users cannot log in)
- [ ] Deactivated users' tasks remain visible
- [ ] Admin cannot delete themselves

---

## 4. Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| Performance | Page load < 2 seconds on standard office network |
| Availability | 99% uptime during business hours (8am–8pm PHT) |
| Security | Passwords hashed (bcrypt), JWT authentication, HTTPS only |
| Data | All data in ap-southeast-1 (Philippines) AWS region |
| Browser | Chrome 120+, Edge 120+ |
| Accessibility | WCAG 2.1 AA for core flows |

---

## 5. Out of Scope (v1)

- Mobile app
- SSO/SAML
- File attachments
- Recurring tasks
- Advanced analytics
- Slack/JIRA integration
- Time tracking

---

## 6. Dependencies

- AWS environment provisioned by client IT
- User list provided by client for initial setup
- SMTP credentials provided by client for email (password reset, notifications)
