# Sample Project: Leave Management System (LMS)
**Client:** Meridian Corp (fictional) | **Stack:** Next.js + Supabase

This is the project you will work on throughout the entire Sprint 0 workshop.
Every module exercise is applied here. By Day 10, you will have produced real deliverables
from this project and be ready for Sprint 1.

---

## The Problem

Meridian Corp (800 employees) processes ~200 leave requests/month via email and spreadsheets.
- Average processing time: 3 days
- Error rate: ~15% (missed requests, wrong dates, no audit trail)
- Legal compliance risk: no audit log for leave records

**The sponsor wants a self-service leave management portal.**

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router, TypeScript) |
| Database + Auth | Supabase (PostgreSQL + Row Level Security) |
| Styling | Tailwind CSS |
| Deployment | Vercel (frontend) + Supabase (backend) |

---

## What's in This Folder

```
sample-project/
├── source-docs/                        ← Day 3: inputs for the BRD Agent
│   ├── rfp.md                          ← Client's RFP (from Meridian Corp)
│   ├── estimation-sheet.md             ← Pre-sales scope estimate (Stratpoint)
│   └── solutions-document-example.md   ← Example SA solutions doc (SA writes this on Day 3)
├── starter-code/             ← Day 6: boilerplate Dev starts from
│   ├── app/
│   │   ├── api/
│   │   │   ├── leaves/       ← TODO: implement (LM-004, LM-005, LM-006)
│   │   │   └── balances/     ← TODO: implement (LM-003)
│   │   ├── (dashboard)/      ← TODO: UI pages
│   │   └── (auth)/login/     ← TODO: Supabase auth flow
│   ├── lib/
│   │   ├── supabase/         ← Client + server Supabase helpers (done)
│   │   └── types.ts          ← Shared TypeScript types (done)
│   ├── middleware.ts          ← Auth guard (done)
│   ├── supabase/migrations/  ← DB schema (done — run this first)
│   └── .env.local.example    ← Copy to .env.local and fill in values
└── taskflow/                 ← Complete reference implementation (Node.js + React)
    ├── docs/
    │   ├── artifacts/        ← BRD, PRD, Architecture Doc, Dev Tasks (completed examples)
    │   ├── adrs/             ← Architecture Decision Records
    │   └── training-props/   ← Trainer materials: buggy code, poisoned context, sample prompts
    ├── backend/              ← Node.js + Express REST API (reference implementation)
    ├── frontend/             ← React + Vite SPA (reference implementation)
    ├── knowledge/            ← Prompts, agents, rules, and patterns used in training
    └── .claude/CLAUDE.md     ← Project rules loaded into Claude Code
```

---

## Day-by-Day Guide

### Day 1–2: Module 1 + 2 (All Roles)

**Your task:** Set up your AI tools and load this project as context.

1. Clone this repo (or open the folder in your IDE)
2. Open Claude Code in this directory
3. Load the source docs as context:
   ```
   read source-docs/client-brief.md
   read source-docs/solutions-document.md
   ```
4. Ask Claude: *"What questions should a Solutions Architect ask before starting
   architecture on this project?"*
5. Then practice your prompting (Module 2):
   - Write a prompt using Role + Context + Task + Format + Constraints
   - Target: generate one section of the BRD from the client brief
   - Compare your output with the person next to you

**Agents to use:**
- `ultimate-ai-agents/agents/claude/sales/pre-sales-engineer.md` — review the client brief
- `ultimate-ai-agents/agents/claude/engineering/architecture/solution-architect.md` — architecture questions

---

### Day 2 PM: Module 3 (All Roles)

**Your task:** Trace the LMS through the full framework.

1. Read the solutions document
2. Map Meridian Corp's problem to the 6 SDLC phases — who owns each phase on this project?
3. Pick one feature (e.g., "employee submits leave request") and trace it:
   - What does the BRD say? → What PRD user story does it become? →
     What architecture decision does it require? → What Dev Task? → What code?
4. Identify: where is the quality gate? What must pass before Dev can start?

---

### Day 3: BRD Creation (PM + SA)

**Your task:** Generate the BRD for this project using the BRD Agent.

**Inputs (in `source-docs/`):**
- `rfp.md` — the client's RFP (what Meridian Corp sent)
- `estimation-sheet.md` — scoped features and estimates from pre-sales
- SA writes the Solutions Document first (use `solutions-document-example.md` as reference),
  then feeds Solutions Document + Estimation Sheet into the BRD agent

**Steps:**
1. Open Claude Code in this project directory
2. Load the BRD agent from Module 3.5 into CLAUDE.md
3. Place the source docs where the agent expects them
4. Run the agent — do NOT interrupt mid-generation
5. Read the validation summary FIRST before reviewing the BRD body
6. Run all 7 human review checks (Module 3.5 trainee guide)
7. PM + SA both sign off — this is the quality gate before Day 4

**Agent to use:**
- `ultimate-ai-agents/agents/claude/project-management/business-analyst.md`

---

### Day 4: PRD Generation (PM generates, SA reviews)

**Your task:** Convert the signed-off BRD into user stories with acceptance criteria.

1. Load the signed BRD as context
2. For each business requirement, generate a user story: *"As a [role], I want [action]
   so that [benefit]"*
3. Write testable acceptance criteria for each story (no vague terms — must be verifiable)
4. Add traceability refs: each user story references its BRD requirement
5. SA reviews for technical feasibility — gate: both PM + SA sign off before Day 5

**Agent to use:**
- `ultimate-ai-agents/agents/claude/project-management/project-manager.md`

---

### Day 5: Architecture Document (SA generates, TL reviews)

**Your task:** Generate the Architecture Document from the signed PRD.

1. Load the signed PRD + solutions document as context
2. Generate the Architecture Document — include:
   - Tech stack with rationale
   - Database schema decisions
   - API design (endpoints + auth)
   - ADRs for key decisions
3. Your Architecture Document should capture the key decisions as ADRs — for example:
   - Why soft delete instead of hard delete? (hint: check the solutions document)
   - Why async notifications instead of inline?
   - How does Supabase RLS replace traditional auth middleware?
4. TL reviews for technical accuracy — gate: Architecture Review sign-off before Day 6

**Agent to use:**
- `ultimate-ai-agents/agents/claude/engineering/architecture/software-architect.md`

---

### Day 6 AM: Dev Tasks (SA or TL generates, the other reviews)

**Your task:** Break the Architecture into implementable Dev Tasks.

1. Load the signed PRD + Architecture Document as context
2. Generate a Dev Task for each endpoint/component:
   - Each task: ID, title, endpoint spec, business logic steps, error codes, tests required
   - Reference: PRD user story + Architecture section in each task
3. Review: generator and reviewer must be different people
4. Gate: Dev Team signs off Dev Tasks before coding begins

**Starter task IDs to generate:**
- LM-001: Database schema + migrations
- LM-002: Auth middleware + RBAC
- LM-003: GET /api/balances
- LM-004: POST /api/leaves (submit request)
- LM-005: PATCH /api/leaves/:id (approve/reject/cancel)
- LM-006: GET /api/leaves (list with filters)

**Agent to use:**
- `ultimate-ai-agents/agents/claude/engineering/architecture/solution-designer.md`

---

### Day 6 PM: Module 4 (Dev + TL)

**Your task:** Implement your first Dev Task using AI-assisted coding.

1. Copy `.env.local.example` → `.env.local` and fill in your Supabase credentials
2. Run the migration: go to Supabase dashboard → SQL Editor → paste `001_initial_schema.sql`
3. Install dependencies: `npm install`
4. Open Claude Code — load your Dev Task (e.g., LM-004) as context
5. Ask Claude to **plan the implementation** before writing any code
6. Review the plan against the task spec — does it match?
7. Implement — one step at a time
8. Read the diff before every commit
9. Commit with message referencing the task: `feat: LM-004 leave submission endpoint`

**Files to implement:**
- `app/api/leaves/route.ts` — POST handler (LM-004)
- `app/api/leaves/[id]/route.ts` — PATCH handler (LM-005)
- `app/api/balances/route.ts` — GET handler (LM-003)

**Agent to use:**
- `ultimate-ai-agents/agents/claude/engineering/javascript/backend-api.md`

---

### Day 7–8: Coding + Module 5

**Your task:** Continue building. On Day 8 AM — Module 5 context engineering exercise.

**Context Engineering exercise (Day 8 AM):**

You've been coding for 2 days. Your AI session is long. Run this diagnostic:
1. Ask Claude to summarize the decisions made so far
2. Ask: *"What is ADR-001 and why does it matter for this project?"*
3. If Claude's answer is wrong or vague — you have a degraded context
4. Compact: `/compact` in Claude Code, then restart with:
   ```
   Load: Dev Task LM-005, Architecture ADR-001, current app/api/leaves/[id]/route.ts
   ```
5. Continue from clean context

---

### Day 9: Module 6 (Dev + TL) — Agents & Governance

**Your task:** Write CLAUDE.md rules for this project.

Create a `CLAUDE.md` in `starter-code/` with at least these rules:

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

Add your own rules based on patterns you've seen during coding this week.

**Agent to use:**
- `ultimate-ai-agents/agents/claude/engineering/javascript/backend-api.md`

---

### Day 10: Module 7 — Knowledge Sharing + Retro

**Your task:** Document your best prompt and run the retro.

1. Pick the most useful prompt you wrote this week
2. Write it up in a shareable format:
   - Title, role context, the full prompt, example output, notes on when to use it
3. Add it to `ultimate-ai-agents/agents/` (propose it as a new agent or pattern)
4. Sprint 0 Retro — answer as a team:
   - What AI workflows saved the most time?
   - Where did AI slow you down?
   - What rules should we add to CLAUDE.md?
   - What agents should we build for Sprint 1?

---

## Quick Start (Dev)

```bash
cd starter-code
npm install
cp .env.local.example .env.local
# Fill in your Supabase URL and keys

# Run the migration in Supabase dashboard → SQL Editor
# Paste: supabase/migrations/001_initial_schema.sql

npm run dev
# → http://localhost:3000
```

---

## Key Constraints (Confirmed from Your Architecture Document)

These are suggested starting points from the solutions document.
Your Architecture Document (Day 5) is the authoritative source — update these as your ADRs evolve.

| Constraint | Why |
|-----------|-----|
| `deleted_at IS NULL` on every query | Soft delete — audit compliance requirement from client brief |
| `auth.uid()` not client-supplied ID | Security: never trust the client |
| Dev Task ID in every commit | Traceability: BRD → PRD → Arch → Task → Code |
| Generator ≠ Reviewer | Framework principle: accountability |
| Read the diff before committing | The developer owns every commit |
