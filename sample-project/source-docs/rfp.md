# Request for Proposal (RFP)
**Issued by:** Meridian Corp — HR Department
**Project:** Leave Management System (LMS)
**RFP Reference:** MC-HR-2026-001
**Issued:** 2026-03-25 | **Proposal Deadline:** 2026-04-15

---

## 1. Company Background

Meridian Corp is a professional services firm with 800 employees across three offices
(Makati HQ, Cebu, Davao). All staff use company-issued email accounts (@meridian.com).
There is no existing HRIS — all HR operations are manual.

**Volume:** ~200 leave requests per month. Current avg processing time: 3 working days.
Estimated error rate: ~15% (missed requests, conflicting dates, no audit trail).

**Compliance trigger:** Legal flagged in Q1 2026 that labor law requires leave records to be
audit-ready. Current process (email + Excel) cannot satisfy this requirement.

---

## 2. User Roles

The system must support four distinct roles with different access levels:

**Employee (800 users)**
- The primary user of the system
- Submits leave requests, checks balances, views own history
- Has no visibility into other employees' requests

**Line Manager (~120 users)**
- Receives and acts on requests from direct reports only
- Approves or rejects; cannot see requests for employees who don't report to them
- Needs a view of team availability (who is on leave and when)

**HR Administrator (5 users)**
- Manages leave types, annual entitlements per employee
- Full read access to all requests across the organization
- Generates reports, exports data, manages the audit log

**System Administrator (2 users, IT team)**
- Manages user accounts, role assignments
- Does not have access to leave request content

---

## 3. Functional Requirements

### 3.1 Leave Request Submission (Employee)

Employees must be able to submit a leave request through a form with the following fields:
- **Leave Type** (required): dropdown — Annual Leave, Sick Leave, Emergency Leave, Unpaid Leave
- **Start Date** (required): date picker — cannot be in the past
- **End Date** (required): date picker — must be on or after start date
- **Reason** (required): free text, minimum 10 characters
- **Supporting Document** (optional): file upload for sick leave (PDF or image, max 5MB)

Business rules:
- System must calculate and display the number of working days requested
- System must warn the employee if the requested dates overlap an existing approved leave
- System must show the employee's remaining balance for the selected leave type before submission
- Employee cannot submit if remaining balance is zero (except Emergency and Unpaid Leave)

On successful submission:
- Request status is set to PENDING
- Employee sees confirmation with request ID and summary
- Line manager receives email notification (see Section 3.6)

### 3.2 Leave Request History (Employee)

Employees must be able to view their own leave request history:
- List view with columns: Leave Type, Start Date, End Date, Days, Status, Submitted Date
- Filterable by: Status (All / Pending / Approved / Rejected / Cancelled), Year
- Clicking a request shows full detail including manager's note (if any)
- Employee can cancel a PENDING request from this view

### 3.3 Leave Balance (Employee)

Employees must be able to view their current leave balances:
- Display per leave type: Total Entitlement / Used / Remaining
- Show balance for current calendar year
- Update in real time after an approval

### 3.4 Manager Approval Workflow (Manager)

Managers must have a dedicated view of pending requests from their direct reports:
- List view: Employee Name, Leave Type, Dates, Days Requested, Submitted Date
- Sorted by submission date (oldest first)
- Clicking a request shows full detail

On each request, manager can:
- **Approve** — optional note (e.g., "Approved. Have a good rest.")
- **Reject** — mandatory reason (minimum 20 characters)

On action:
- Request status updates immediately
- Employee receives email notification
- Manager cannot edit their decision after submission

### 3.5 Team Calendar (Manager)

Managers must be able to see a monthly calendar view showing:
- Which direct reports are on approved leave on each day
- Color-coded by leave type
- Navigate forward/backward by month

### 3.6 HR Administration

**Leave Type Management:**
- HR Admin can add, edit, and deactivate leave types
- Each leave type has: name, default annual entitlement (days), carryover policy (yes/no)

**Entitlement Management:**
- HR Admin sets annual leave entitlement per employee per leave type
- Must support bulk update via CSV upload (for annual reset)
- Changes are logged in the audit trail

**Request Management:**
- HR Admin can view all requests across the organization
- Filters: Employee Name, Department, Leave Type, Status, Date Range
- HR Admin can override a request status (with mandatory reason) — for correction purposes only

**Reporting:**
- Leave Utilization Report: total days taken per employee per leave type for a date range
- Department Summary: average leave days per department
- Export any report to CSV

### 3.7 Notifications (Email)

All emails must include: employee name, leave type, dates, number of days, and a link to the request.

| Trigger | Recipient | Subject line |
|---------|-----------|-------------|
| Request submitted | Line Manager | Action Required: [Employee] has submitted a leave request |
| Request approved | Employee | Your leave request has been approved |
| Request rejected | Employee | Your leave request has been rejected |
| Request cancelled by employee | Line Manager | [Employee] has cancelled their leave request |
| Entitlement updated | Employee | Your leave balance has been updated by HR |

### 3.8 Audit Log

Every state change on every leave record must be logged:
- Timestamp (UTC)
- Actor (who made the change)
- Action (SUBMITTED / APPROVED / REJECTED / CANCELLED / OVERRIDDEN)
- Record snapshot before and after the change

HR Admin must be able to:
- View the full audit log with filters (date range, actor, action type)
- Export audit log to CSV

Records must never be permanently deleted. The system must use a soft-delete pattern
(mark as deleted, preserve in database) for all business records.

---

## 4. User Experience Requirements

The system must be simple enough for non-technical users (managers and employees).

**Employee — Key Screens:**
1. **Dashboard** — shows leave balances at a glance, quick "Submit Leave Request" button,
   and a list of recent/pending requests
2. **Submit Leave Request** — clean form, shows remaining balance for selected leave type,
   warns on conflicts, confirms on submit
3. **My Requests** — full history list with status badges, click to view detail, cancel button
   on pending items

**Manager — Key Screens:**
1. **Pending Approvals** — list of requests needing action, sorted by oldest first,
   badge showing count on nav
2. **Request Detail** — full request info, approve/reject action with note/reason field
3. **Team Calendar** — monthly calendar view, color-coded leave by type

**HR Admin — Key Screens:**
1. **All Requests** — full org view with filters, bulk export
2. **Entitlement Management** — employee list with leave balance grid, edit per row, CSV upload
3. **Reports** — report selector, date range picker, preview table, export to CSV
4. **Audit Log** — filterable log table, export to CSV

**Design direction:** Clean, professional, minimal. No unnecessary complexity.
Use a consistent color system: status badges (Pending = yellow, Approved = green,
Rejected = red, Cancelled = grey). Mobile-responsive.

---

## 5. Technical Requirements

- **Authentication:** Secure email-based login with magic link or password; employees use their company email address (e.g., @meridian.com)
- **Hosting:** Cloud-hosted; no on-premise servers
- **Availability:** 99.5% uptime during business hours (8am–8pm PHT, Mon–Fri)
- **Performance:** Pages and API responses must load within 2 seconds under normal load
- **Capacity:** Support up to 1,000 concurrent users
- **Browser support:** Latest Chrome, Edge, Safari, Firefox
- **Data retention:** Leave records must be retained for minimum 5 years (labor law)

---

## 6. Out of Scope (Phase 1)

- Payroll or salary deduction integration
- Native mobile application (iOS/Android)
- Multi-country or multi-jurisdiction leave policy engine
- In-app push notifications
- Approval delegation (manager designates alternate approver when on leave) — Phase 2
- Social login (Google, Facebook, etc.)

---

## 7. Deliverables Expected

From the selected vendor:
- Technical proposal and solution architecture
- Project plan with sprint breakdown
- Team composition
- Pricing by phase
- UI/UX prototype before development begins

---

## 8. Timeline

| Milestone | Date |
|-----------|------|
| RFP issued | 2026-03-25 |
| Proposal deadline | 2026-04-15 |
| Award and contract | 2026-04-30 |
| Sprint 0 kickoff | 2026-05-05 |
| Target go-live | 2026-08-29 |

---

## 9. Contact

**Maria Santos** — HR Manager, Meridian Corp
**Joel Reyes** — IT Administrator, Meridian Corp
