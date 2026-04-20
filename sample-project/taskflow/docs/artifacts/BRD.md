# Business Requirements Document (BRD)
## TaskFlow — Internal Task Management Web Application

**Version:** 1.0  
**Date:** March 2026  
**Prepared by:** [Client Stakeholder]  
**Status:** Approved

---

## 1. Executive Summary

Stratpoint has been engaged to build TaskFlow, a lightweight internal task management web application for a mid-sized professional services firm. The client currently tracks tasks via email threads and shared spreadsheets, resulting in missed deadlines, duplicated work, and lack of visibility across teams.

TaskFlow will replace this ad-hoc process with a structured, centralized system accessible via web browser.

---

## 2. Business Context

### 2.1 Current State
- Tasks are assigned via email with no central tracking system.
- Status updates are communicated verbally or via chat, with no audit trail.
- Team leads spend 30–45 minutes per week manually compiling status reports from team members.
- Missed tasks are discovered only at deadline, with no early warning system.

### 2.2 Desired State
- All tasks created, assigned, and tracked in one system.
- Team leads can view task status in real time without manual reporting.
- Users receive notifications when tasks are assigned or approaching due dates.
- Historical task data is retained for performance review purposes.

---

## 3. Business Objectives

| # | Objective | Success Metric |
|---|-----------|---------------|
| 1 | Reduce missed deadlines | 50% reduction in overdue tasks within 60 days of launch |
| 2 | Eliminate manual status reporting | Team leads spend <5 min/week on status |
| 3 | Improve task visibility | 100% of tasks tracked in system within 30 days |
| 4 | Improve accountability | Every task has a named assignee and due date |

---

## 4. Stakeholders

| Role | Name | Responsibility |
|------|------|---------------|
| Product Owner | Maria Santos | Requirements sign-off, UAT |
| Team Lead | James Reyes | Daily user, primary feedback provider |
| IT Admin | Ben Cruz | Infrastructure, user provisioning |
| End Users | All staff (approx. 50) | Task creation and management |

---

## 5. Scope

### 5.1 In Scope
- Web-based task management application (desktop browser only for v1)
- User authentication (email/password, no SSO for v1)
- Task creation, assignment, editing, and deletion
- Task status tracking (To Do, In Progress, Done)
- Due date setting and overdue indicators
- Basic dashboard showing assigned tasks and status summary
- Task comments and activity log

### 5.2 Out of Scope (v1)
- Mobile application
- SSO / SAML integration
- Advanced reporting and analytics
- File attachments on tasks
- Recurring tasks
- Third-party integrations (Slack, JIRA, etc.)
- Time tracking

---

## 6. Business Constraints

| Constraint | Detail |
|-----------|--------|
| Timeline | MVP must be live within 6 weeks of project start |
| Budget | Fixed-price engagement — scope changes require CCR |
| Infrastructure | Must run on client's existing AWS environment |
| Data | All data must remain within the Philippines (data residency) |
| Browser support | Chrome and Edge only (client standard) |

---

## 7. Business Rules

1. Every task must have exactly one assignee.
2. Every task must have a due date.
3. Only the task creator or an admin can delete a task.
4. Tasks cannot be re-opened once marked as Done (v1).
5. A user can only see tasks they created or are assigned to (no global view for regular users).
6. Team leads can view all tasks within their team.

---

## 8. Assumptions

- Client will provide user list for initial provisioning.
- Client's AWS environment is already set up and accessible.
- No data migration from existing spreadsheets is required.
- Client will conduct UAT within 5 business days of staging deployment.

---

## 9. Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Scope creep from user feedback during UAT | High | Medium | Strict CCR process, deferred to v2 |
| Low user adoption | Medium | High | Training sessions, simple UX |
| AWS setup delays | Low | High | Early environment validation in Sprint 0 |

---

## 10. Acceptance Criteria (Business Level)

- [ ] Users can log in and see their assigned tasks.
- [ ] Users can create, assign, and update tasks.
- [ ] Team leads can view their team's tasks.
- [ ] Overdue tasks are visually flagged.
- [ ] System is accessible via Chrome and Edge.
- [ ] All data is stored within the Philippines AWS region.
