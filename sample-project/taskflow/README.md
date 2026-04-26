# TaskFlow
### AI Foundational Training — Sample Project
**Stratpoint Technologies | Ronald Dela Cruz**

TaskFlow is a lightweight internal task management web app used as the sample project for
the AI Foundational Training program. It demonstrates the complete AI-Augmented SDLC framework
from BRD through deployment.

---

## What's in this repo

```
taskflow/
├── AGENTS.md                # Cross-tool project rules (Claude Code, Antigravity, Cursor)
├── .claude/
│   └── CLAUDE.md            # Claude-Code-specific rules (overrides AGENTS.md when needed)
├── docs/
│   ├── artifacts/           # Framework artifacts (BRD, PRD, Dev Tasks, Architecture Doc)
│   ├── adrs/                # Architecture Decision Records
│   └── training-props/      # Trainer materials (buggy code, context transcript, prompts)
├── knowledge/
│   ├── prompts/             # Reusable prompts by role
│   │   ├── solutions-designer/
│   │   ├── product/
│   │   ├── project-manager/
│   │   ├── solutions-architect/
│   │   ├── tech-lead/
│   │   └── dev/
│   ├── agents/              # Agent definitions (markdown + frontmatter)
│   ├── skills/              # Skills (SKILL.md, dynamic load)
│   ├── rules/               # Rule sets and rationale
│   ├── patterns/            # Multi-step prompt chains
│   └── retros/              # Retrospective notes and action items
├── core-ai-team/            # Facilitator playbooks (internal, not cohort-facing)
├── backend/                 # Node.js + Express REST API
└── frontend/                # React + Vite SPA
```

---

## Quick Start

### Prerequisites
- Node.js 20 LTS or higher
- npm 9+
- Git

### 1. Clone the repo
```bash
git clone <repo-url>
cd taskflow
```

### 2. Set up the backend
```bash
cd backend
npm install
cp .env.example .env        # Edit .env if needed (defaults work for local dev)
mkdir -p data
node src/db/database.js     # Run migrations + seed admin user
npm run dev                 # Starts API on http://localhost:3001
```

### 3. Set up the frontend
```bash
cd frontend
npm install
cp .env.example .env        # Edit VITE_API_URL if your API is on a different port
npm run dev                 # Starts app on http://localhost:5173
```

### 4. Log in
Open http://localhost:5173 and log in with:
- **Email:** admin@taskflow.dev
- **Password:** Admin1234!

---

## Running Tests

### Backend
```bash
cd backend
npm test                    # Run all tests
npm run test:coverage       # Run with coverage report
```

### Frontend
```bash
cd frontend
npm test                    # Run all tests
```

---

## API Reference

Base URL: `http://localhost:3001/api`

All protected routes require: `Authorization: Bearer <token>`

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | /auth/login | Login | No |
| POST | /auth/logout | Logout | Yes |
| POST | /auth/forgot-password | Request password reset | No |
| POST | /auth/reset-password | Reset password with token | No |
| GET | /tasks | List tasks (role-scoped) | Yes |
| POST | /tasks | Create task | Yes |
| GET | /tasks/:id | Task detail | Yes |
| PATCH | /tasks/:id | Edit task | Yes |
| DELETE | /tasks/:id | Delete task (soft) | Yes |
| PATCH | /tasks/:id/status | Update task status | Yes |
| POST | /tasks/:id/comments | Add comment | Yes |
| GET | /tasks/:id/comments | List comments | Yes |
| GET | /users | List users | Admin |
| POST | /users | Create user | Admin |
| PATCH | /users/:id | Activate/deactivate user | Admin |

---

## Training Usage

This project is used across all 7 training modules under the locked numbering
scheme (M2 = SDLC framework, M3 = Prompt Engineering, M4 = Context Engineering,
M5 = AI-Assisted Development):

| Module | How TaskFlow is used |
|--------|---------------------|
| Module 1 (Tools Setup) | Load repo as project context. Run `claude mcp add` and configure other tools against TaskFlow. |
| Module 2 (End-to-End SDLC) | Trace BRD → PRD → Architecture → Dev Tasks → code chain. Convert the messy stakeholder email in `docs/training-props/` into clean BRD + PRD. Reference quality bar: `docs/artifacts/`. |
| Module 3 (Prompt Engineering) | Write prompts using TaskFlow's PRD, Dev Tasks, and seed prompts in `knowledge/prompts/`. Convert refined prompts into agent files in `knowledge/agents/{role}/`. |
| Module 4 (Context Engineering) | Analyze `docs/training-props/poisoned-context-transcript.md`. Practice session management and compacting on TaskFlow's long-context artifacts. |
| Module 5 (AI-Assisted Dev) | Implement real Dev Tasks from `docs/artifacts/DevTasks.md`. Debug `docs/training-props/buggy-functions.md`. Fix issues from `docs/known-issues.md`. Refactor `routes/tasks.js`. See `docs/training-props/trainer-guide-module5.md`. |
| Module 6 (Tool Customization) | Use TaskFlow's `AGENTS.md` and `.claude/CLAUDE.md` as the rules baseline. Build your own agents and skills under `knowledge/agents/{role}/` and `knowledge/skills/`. |
| Module 7 (Knowledge Sharing) | Contribute refined prompts, rules, agents, and skills back to `knowledge/`. Run retros and document them in `knowledge/retros/`. |

---

## Architecture

- **Backend:** Node.js/Express REST API with JWT auth
- **Frontend:** React 18 + Vite SPA with Tailwind CSS
- **Database:** SQLite (better-sqlite3) — zero setup, file-based
- **Auth:** JWT (8-hour expiry) — stateless, no sessions
- **Deployment target:** AWS EC2 (ap-southeast-1)

See `docs/artifacts/ArchitectureDocument.md` for full details.

---

## Framework Artifacts

| Artifact | File | Status |
|----------|------|--------|
| Business Requirements Document | `docs/artifacts/BRD.md` | Approved |
| Product Requirements Document | `docs/artifacts/PRD.md` | Approved |
| Dev Tasks Document | `docs/artifacts/DevTasks.md` | Approved |
| Architecture Document | `docs/artifacts/ArchitectureDocument.md` | Approved |
| Architecture Decision Records | `docs/adrs/ADRs.md` | Accepted |

---

## Training Props (Trainer Use Only)

| File | Used in | Purpose |
|------|---------|---------|
| `docs/training-props/buggy-functions.md` | Module 5, Exercise 5.2 | 4 intentional bugs for debugging practice |
| `docs/training-props/poisoned-context-transcript.md` | Module 4, Exercise 4.2 | Annotated poisoned AI session for analysis |
| `docs/training-props/sample-prompts-and-rules.md` | Module 3 + Module 6 | Reference prompts and AGENTS.md/CLAUDE.md rules |
| `docs/training-props/trainer-guide-module5.md` | Module 5 | Trainer notes for dev exercises 5.2, 5.3, 5.6, 5.7 |

---

## License
Internal training use only. Not for distribution outside Stratpoint Technologies.
