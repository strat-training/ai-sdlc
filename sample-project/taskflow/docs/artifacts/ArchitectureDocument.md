# Architecture Document
## TaskFlow — System Architecture

**Version:** 1.0  
**Date:** March 2026  
**Prepared by:** Solutions Architect  
**Status:** Approved

---

## 1. Architecture Overview

TaskFlow follows a standard **3-tier web architecture**: a React SPA frontend, a Node.js/Express REST API backend, and a SQLite database. For v1 with ~50 users, this stack is appropriately simple — no message queues, no caching layer, no microservices.

```
[Browser: Chrome/Edge]
        |
        | HTTPS
        |
[React + Vite SPA]          ← Static files served from S3/CloudFront (or Express static)
        |
        | REST API (JSON)
        |
[Node.js / Express API]     ← EC2 t3.small, ap-southeast-1
        |
        | better-sqlite3
        |
[SQLite database]           ← Local file on EC2, backed up to S3 nightly
```

---

## 2. Technology Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Frontend | React 18 + Vite | Fast build, familiar to team |
| Routing | React Router v6 | Standard SPA routing |
| State | React Context + useState | Simple enough for v1; no Redux needed |
| Styling | Tailwind CSS | Utility-first, fast to iterate |
| Backend | Node.js 20 LTS + Express 4 | Team expertise, fast to build |
| Database | SQLite (better-sqlite3) | Zero setup, sufficient for 50 users |
| Auth | JWT (jsonwebtoken) | Stateless, simple |
| Password | bcrypt | Industry standard hashing |
| Validation | express-validator | Request validation middleware |
| Testing (BE) | Jest + Supertest | Standard Node testing |
| Testing (FE) | Vitest + React Testing Library | Vite-native test runner |
| Email | Nodemailer + SMTP | Password reset emails |

---

## 3. Database Schema

### users
```sql
CREATE TABLE users (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  email       TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  role        TEXT NOT NULL DEFAULT 'user', -- user | team_lead | admin
  team        TEXT,
  is_active   INTEGER NOT NULL DEFAULT 1,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### tasks
```sql
CREATE TABLE tasks (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  title       TEXT NOT NULL,
  description TEXT,
  assignee_id INTEGER NOT NULL REFERENCES users(id),
  creator_id  INTEGER NOT NULL REFERENCES users(id),
  due_date    DATE NOT NULL,
  priority    TEXT NOT NULL DEFAULT 'Medium', -- Low | Medium | High
  status      TEXT NOT NULL DEFAULT 'To Do', -- To Do | In Progress | Done
  is_deleted  INTEGER NOT NULL DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### comments
```sql
CREATE TABLE comments (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id     INTEGER NOT NULL REFERENCES tasks(id),
  user_id     INTEGER NOT NULL REFERENCES users(id),
  content     TEXT NOT NULL,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### activity_log
```sql
CREATE TABLE activity_log (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id     INTEGER NOT NULL REFERENCES tasks(id),
  user_id     INTEGER NOT NULL REFERENCES users(id),
  action      TEXT NOT NULL, -- created | updated | status_changed | deleted
  detail      TEXT,          -- JSON: {field, old_value, new_value}
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

---

## 4. API Design

### Base URL
`/api/v1`

### Authentication
All endpoints except `/auth/login` and `/auth/forgot-password` require:
```
Authorization: Bearer <JWT>
```

### Endpoints

| Method | Endpoint | Description | Auth | Role |
|--------|----------|-------------|------|------|
| POST | /auth/login | Login | No | — |
| POST | /auth/logout | Logout | Yes | Any |
| POST | /auth/forgot-password | Request reset | No | — |
| POST | /auth/reset-password | Reset password | No | — |
| GET | /tasks | List tasks (scoped) | Yes | Any |
| POST | /tasks | Create task | Yes | Any |
| GET | /tasks/:id | Task detail | Yes | Scoped |
| PATCH | /tasks/:id | Edit task | Yes | Creator/Admin |
| DELETE | /tasks/:id | Delete task | Yes | Creator/Admin |
| PATCH | /tasks/:id/status | Update status | Yes | Assignee/Admin |
| POST | /tasks/:id/comments | Add comment | Yes | Scoped |
| GET | /tasks/:id/comments | List comments | Yes | Scoped |
| GET | /users | List users | Yes | Admin |
| POST | /users | Create user | Yes | Admin |
| PATCH | /users/:id | Update user | Yes | Admin |

### Standard Response Format
```json
// Success
{ "success": true, "data": { ... } }

// Error
{ "success": false, "error": { "code": "VALIDATION_ERROR", "message": "..." } }
```

---

## 5. Authorization Rules

| Action | Regular User | Team Lead | Admin |
|--------|-------------|-----------|-------|
| View own tasks | ✓ | ✓ | ✓ |
| View team tasks | ✗ | ✓ | ✓ |
| Create task | ✓ | ✓ | ✓ |
| Edit own task (all fields) | ✓ | ✓ | ✓ |
| Edit assigned task (status, desc) | ✓ | ✓ | ✓ |
| Delete task | Creator only | Creator only | ✓ |
| Manage users | ✗ | ✗ | ✓ |

---

## 6. Security Considerations

- **Passwords:** bcrypt with cost factor 12
- **JWT:** HS256, 8-hour expiry, secret in environment variable
- **HTTPS:** Enforced via load balancer; HTTP redirects to HTTPS
- **CORS:** Restricted to known frontend origin
- **Helmet:** Sets security headers (XSS, CSRF, clickjacking protection)
- **Rate limiting:** 100 requests/15 min per IP on auth endpoints
- **Input validation:** express-validator on all POST/PATCH routes
- **SQL injection:** SQLite parameterized queries via better-sqlite3

---

## 7. Deployment Architecture

```
Internet → AWS ALB (HTTPS/443)
              ↓
         EC2 t3.small (ap-southeast-1)
         ├── Node.js API (PM2, port 3001)
         └── SQLite DB (/data/taskflow.db)
              ↓
         S3 (nightly DB backup via cron)
```

- EC2 in private subnet, ALB in public subnet
- Security group: ALB → EC2 port 3001 only
- Frontend static files served from same Express app (or S3 + CloudFront)
- Environment variables via EC2 Parameter Store or .env file (not committed)

---

## 8. Constraints & Decisions

See ADR files for detailed rationale on:
- ADR-001: SQLite over PostgreSQL for v1
- ADR-002: JWT stateless auth over session-based
- ADR-003: Monorepo structure
- ADR-004: Soft delete over hard delete
