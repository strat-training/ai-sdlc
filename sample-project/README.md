# Sample Projects

This folder contains two projects used throughout the AI-Augmented SDLC training program.

| Project | Purpose | Stack |
|---------|---------|-------|
| `taskflow/` | **Primary training vehicle** — complete reference implementation used in all 7 modules | Node.js + Express + React + SQLite |
| `starter-code/` | Coding exercise boilerplate for the LMS (Leave Management System) | Next.js 15 + Supabase |

---

## TaskFlow — Reference Implementation

TaskFlow is a lightweight internal task management app built end-to-end using the AI-Augmented SDLC framework. Every artifact (BRD → PRD → Architecture → Dev Tasks → Code) was generated and validated using the framework. It is the project trainers and trainees use across all 7 modules.

### Quick Start

```bash
# Backend
cd taskflow/backend
npm install
cp .env.example .env
mkdir -p data
node src/db/database.js     # Run migrations + seed admin user
npm run dev                 # API on http://localhost:3001

# Frontend (new terminal)
cd taskflow/frontend
npm install
cp .env.example .env
npm run dev                 # App on http://localhost:5173
```

Log in with: `admin@taskflow.dev` / `Admin1234!`

### Framework Artifacts

Completed, approved artifacts are in `taskflow/docs/artifacts/`:

| Artifact | File | Status |
|----------|------|--------|
| Business Requirements Document | `docs/artifacts/BRD.md` | Approved |
| Product Requirements Document | `docs/artifacts/PRD.md` | Approved |
| Architecture Document | `docs/artifacts/ArchitectureDocument.md` | Approved |
| Dev Tasks Document | `docs/artifacts/DevTasks.md` | Approved |
| Architecture Decision Records | `docs/adrs/ADRs.md` | Accepted |

### How TaskFlow is Used Per Module

| Module | How TaskFlow is used |
|--------|---------------------|
| Module 1 | Load repo as context. Run `claude mcp add` for project tools. |
| Module 2 | Write prompts for PRD, task breakdown, and code generation exercises. |
| Module 3 | Implement real Dev Tasks from `docs/artifacts/DevTasks.md`. Debug `docs/training-props/buggy-functions.md`. |
| Module 4 | Trace BRD → PRD → Dev Tasks → code traceability chain. |
| Module 5 | Analyze `docs/training-props/poisoned-context-transcript.md`. |
| Module 6 | Add and test `.claude/CLAUDE.md` rules. See `docs/training-props/sample-prompts-and-rules.md`. |
| Module 7 | Contribute refined prompts and rules to `docs/training-props/sample-prompts-and-rules.md`. |

### Training Props (Trainer Use)

| File | Module | Purpose |
|------|--------|---------|
| `docs/training-props/buggy-functions.md` | Module 3, Ex 3.2 | 4 intentional bugs for AI debugging practice |
| `docs/training-props/poisoned-context-transcript.md` | Module 5, Ex 5.2 | Annotated degraded AI session for analysis |
| `docs/training-props/sample-prompts-and-rules.md` | Module 6 | Reference prompts and CLAUDE.md rules |
| `docs/training-props/trainer-guide-module4.md` | Module 3–4 | Trainer notes: which bugs are planted where in the live codebase |

### Knowledge — Prompts by Role

Ready-to-use prompt templates in `taskflow/knowledge/prompts/`:

| Role | Prompt | Purpose |
|------|--------|---------|
| PM | `pm/generate-user-stories.md` | Convert feature descriptions into user stories with acceptance criteria |
| PM | `pm/validate-prd-against-brd.md` | Validate PRD traceability against the BRD |
| SA | `sa/generate-dev-tasks.md` | Break architecture into implementable dev tasks |
| Dev | `dev/implement-from-task.md` | Plan-first implementation from a dev task spec |
| Dev | `dev/code-review.md` | AI-assisted code review against project standards |

### Architecture

- **Backend:** Node.js/Express REST API, JWT auth (8-hour expiry), stateless
- **Frontend:** React 18 + Vite SPA, Tailwind CSS
- **Database:** SQLite (better-sqlite3) — zero setup, file-based
- **Roles:** `admin`, `team_lead`, `user` with scoped permissions

---

## Leave Management System — Coding Exercise

The LMS is the project trainees build from scratch during the coding modules (Days 6–9). It is a self-service leave management portal for Meridian Corp (fictional client, 800 employees).

### The Problem

Meridian Corp processes ~200 leave requests/month via email and spreadsheets.
- Average processing time: 3 days
- Error rate: ~15% (missed requests, wrong dates, no audit trail)
- Legal compliance risk: no audit log for leave records

**The sponsor wants a self-service leave management portal.**

### Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router, TypeScript) |
| Database + Auth | Supabase (PostgreSQL + Row Level Security) |
| Styling | Tailwind CSS |
| Deployment | Vercel + Supabase |

### Quick Start

```bash
cd starter-code
npm install
cp .env.local.example .env.local
# Fill in your Supabase URL and anon key

# Run the migration in Supabase dashboard → SQL Editor
# Paste: supabase/migrations/001_initial_schema.sql

npm run dev
# → http://localhost:3000
```

### What's Pre-built vs. TODO

```
starter-code/
├── app/
│   ├── api/
│   │   ├── leaves/       ← TODO: implement (LM-004, LM-005, LM-006)
│   │   └── balances/     ← TODO: implement (LM-003)
│   ├── (dashboard)/      ← TODO: UI pages
│   └── (auth)/login/     ← TODO: Supabase auth flow
├── lib/
│   ├── supabase/         ← Done: client + server Supabase helpers
│   └── types.ts          ← Done: shared TypeScript types
├── middleware.ts          ← Done: auth guard
├── supabase/migrations/  ← Done: run this first
└── .env.local.example    ← Copy to .env.local and fill in values
```

### Dev Task IDs

| ID | Task |
|----|------|
| LM-001 | Database schema + migrations |
| LM-002 | Auth middleware + RBAC |
| LM-003 | GET /api/balances |
| LM-004 | POST /api/leaves (submit request) |
| LM-005 | PATCH /api/leaves/:id (approve/reject/cancel) |
| LM-006 | GET /api/leaves (list with filters) |

### Key Constraints

| Constraint | Why |
|-----------|-----|
| `deleted_at IS NULL` on every query | Soft delete — audit compliance (from BRD) |
| `auth.uid()` not client-supplied ID | Never trust the client |
| Dev Task ID in every commit (`feat: LM-004 ...`) | Traceability: BRD → PRD → Arch → Task → Code |
| Generator ≠ Reviewer on all artifacts | Framework principle: accountability |
| Read the diff before committing | The developer owns every commit |

---

## Day-by-Day Guide

### Day 1–2: Module 1 + 2 (All Roles)

**Your task:** Set up your AI tools and load the project as context.

1. Open Claude Code in the `taskflow/` directory
2. Load the CLAUDE.md rules: they are already in `taskflow/.claude/CLAUDE.md`
3. Ask Claude: *"What questions should a Solutions Architect ask before starting architecture on this project?"*
4. Prompt engineering practice (Module 2):
   - Write a prompt using Role + Context + Task + Format + Constraints
   - Target: generate one user story from the BRD
   - Compare your output against `taskflow/docs/artifacts/PRD.md`

**Agents:**
- `ultimate-ai-agents/agents/claude/sales/pre-sales-engineer.md`
- `ultimate-ai-agents/agents/claude/engineering/architecture/solution-architect.md`

---

### Day 2 PM: Module 3 (All Roles)

**Your task:** Trace a feature through the full framework using TaskFlow artifacts.

1. Pick one feature (e.g., "user submits a task")
2. Trace it: BRD requirement → PRD user story → Architecture decision → Dev Task → code
3. Identify: where is the quality gate? What must pass before Dev can start?

---

### Day 3: BRD Creation (PM + SA)

**Your task:** Generate the BRD for the LMS project using the BRD Agent.

**Inputs (in `source-docs/`):**
- `rfp.md` — the client's RFP (what Meridian Corp sent)
- `estimation-sheet.csv` — scoped features and estimates from pre-sales
- SA writes the Solutions Document first (use `solutions-document-example.md` as reference),
  then feeds Solutions Document + Estimation Sheet into the BRD agent

**Reference:** Compare your output against `taskflow/docs/artifacts/BRD.md` (a completed example)

**Steps:**
1. Open Claude Code in the `sample-project/` directory
2. Load the BRD agent into CLAUDE.md
3. Run the agent — do NOT interrupt mid-generation
4. Read the validation summary FIRST before reviewing the BRD body
5. Run all 7 human review checks (Module 3.5 trainee guide)
6. PM + SA both sign off — quality gate before Day 4

**Agent:** `ultimate-ai-agents/agents/claude/project-management/business-analyst.md`

---

### Day 4: PRD Generation (PM generates, SA reviews)

**Your task:** Convert the signed BRD into user stories with acceptance criteria.

1. Load the signed BRD as context
2. Generate user stories: *"As a [role], I want [action] so that [benefit]"*
3. Write testable acceptance criteria — no vague terms, must be verifiable
4. Add traceability refs: each story references its BRD requirement
5. SA reviews for technical feasibility — gate: PM + SA sign off before Day 5

**Reference:** `taskflow/docs/artifacts/PRD.md`

**Agent:** `ultimate-ai-agents/agents/claude/project-management/project-manager.md`

---

### Day 5: Architecture Document (SA generates, TL reviews)

**Your task:** Generate the Architecture Document from the signed PRD.

1. Load the signed PRD + solutions document as context
2. Generate the Architecture Document — include tech stack rationale, DB schema decisions, API design, ADRs
3. Key ADRs to capture:
   - Why soft delete instead of hard delete?
   - Why async notifications instead of inline?
   - How does Supabase RLS replace traditional auth middleware?
4. TL reviews for technical accuracy — gate: Architecture Review sign-off before Day 6

**Reference:** `taskflow/docs/artifacts/ArchitectureDocument.md`, `taskflow/docs/adrs/ADRs.md`

**Agent:** `ultimate-ai-agents/agents/claude/engineering/architecture/software-architect.md`

---

### Day 6 AM: Dev Tasks (SA or TL generates, the other reviews)

**Your task:** Break the Architecture into implementable Dev Tasks.

1. Load the signed PRD + Architecture Document as context
2. Generate a Dev Task for each endpoint/component — ID, title, endpoint spec, business logic, error codes, tests required
3. Generator and reviewer must be different people
4. Gate: Dev Team signs off Dev Tasks before coding begins

**Reference:** `taskflow/docs/artifacts/DevTasks.md`

**Prompt template:** `taskflow/knowledge/prompts/sa/generate-dev-tasks.md`

**Agent:** `ultimate-ai-agents/agents/claude/engineering/architecture/solution-designer.md`

---

### Day 6 PM: Module 4 (Dev + TL)

**Your task:** Implement your first Dev Task using AI-assisted coding.

1. Copy `starter-code/.env.local.example` → `.env.local` and fill in your Supabase credentials
2. Run the migration in Supabase dashboard → SQL Editor
3. `npm install` in `starter-code/`
4. Open Claude Code — load your Dev Task (e.g., LM-004) as context
5. Ask Claude to **plan the implementation** before writing any code
6. Review the plan against the task spec
7. Implement one step at a time — read the diff before every commit
8. Commit with task ID: `feat: LM-004 leave submission endpoint`

**Prompt template:** `taskflow/knowledge/prompts/dev/implement-from-task.md`

**Agent:** `ultimate-ai-agents/agents/claude/engineering/javascript/backend-api.md`

---

### Day 7–8: Coding + Module 5

**Context Engineering exercise (Day 8 AM):**

1. Ask Claude to summarize the decisions made so far
2. Ask: *"What is ADR-001 and why does it matter for this project?"*
3. If Claude's answer is wrong or vague — degraded context. Compact: `/compact`
4. Restart with clean context: load Dev Task + Architecture ADR + current file
5. Compare against the poisoned context example: `taskflow/docs/training-props/poisoned-context-transcript.md`

---

### Day 9: Module 6 (Dev + TL) — Agents & Governance

**Your task:** Write CLAUDE.md rules for the LMS project.

Create `starter-code/.claude/CLAUDE.md`. Start from the TaskFlow example at `taskflow/.claude/CLAUDE.md` and adapt for LMS:

```markdown
# LMS Project Rules

## Database
- All queries MUST filter `deleted_at IS NULL` (ADR-001)
- Never use hard delete — set `deleted_at = NOW()` instead

## Authentication
- All API routes must call `supabase.auth.getUser()` and check for errors
- Never trust client-supplied user ID — always use `auth.uid()` from Supabase

## Commits
- Commit messages must reference the Dev Task ID: `feat: LM-004 ...`
- Never commit secrets or `.env.local`

## Code Review
- No AI-generated code ships without developer reading the full diff
- If you can't explain what the code does, don't commit it
```

**Reference:** `taskflow/docs/training-props/sample-prompts-and-rules.md`

---

### Day 10: Module 7 — Knowledge Sharing + Retro

1. Pick the most useful prompt you wrote this week — write it up in shareable format
2. Add it to `taskflow/knowledge/prompts/` or propose it as a new agent in `ultimate-ai-agents/agents/`
3. Sprint 0 Retro as a team:
   - What AI workflows saved the most time?
   - Where did AI slow you down?
   - What rules should we add to CLAUDE.md?
   - What agents should we build for Sprint 1?

---

## License

Internal training use only. Not for distribution outside Stratpoint Technologies.
