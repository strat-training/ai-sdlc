# Training Props: Sample Prompts & Rules
## Module 6 — Tool Customization, Agents & Governance

---

## Sample Prompt Library (Module 6, Exercise 6.4 reference)

These are example prompts from the TaskFlow project. Use them as reference when building your team's prompt library.

---

### PM Prompts

**Prompt: Generate User Stories from Feature Description**
```
Role: You are a product manager writing user stories for a web application.

Context: TaskFlow is an internal task management web app used by ~50 staff. Users are non-technical
professional services employees. The app uses a role system: regular user, team lead, and admin.

Task: Given the following feature description, write 3–5 user stories in the format:
"As a [persona], I want to [action] so that [benefit]."

Format:
- Use Markdown
- Each user story on its own line
- Follow each user story with 3–5 acceptance criteria as a checklist
- Keep language simple and non-technical

Constraints:
- Do not write user stories for admin features unless specifically requested
- Do not include technical implementation details
- Focus on the user's goal, not the system's behavior

Feature description:
<<<
[PASTE FEATURE DESCRIPTION HERE]
>>>
```

**Prompt: Validate PRD Against BRD**
```
Role: You are a business analyst reviewing product requirements against business requirements.

Context: [PASTE BRD SUMMARY HERE]

Task: Review the following PRD section and identify:
1. Requirements in the PRD that have no corresponding BRD objective (scope risk)
2. BRD objectives not addressed by any PRD requirement (coverage gaps)
3. PRD requirements that conflict with BRD constraints

Format: Return as three numbered lists. If a list is empty, write "None found."

Constraints:
- Do not suggest new requirements
- Do not evaluate technical feasibility
- Focus only on traceability and alignment

PRD section:
<<<
[PASTE PRD SECTION HERE]
>>>
```

---

### SA Prompts

**Prompt: Generate Dev Tasks from PRD User Story**
```
Role: You are a solutions architect breaking down product requirements into developer tasks.

Context: TaskFlow uses Node.js/Express backend, React + Vite frontend, SQLite database.
API follows REST conventions with JWT auth. See architecture document for full context.

Task: Break down the following user story into developer tasks. Each task should be:
- Independently completable by one developer
- Completable in 1–4 hours
- Specific enough that a developer can start without asking questions

Format for each task:
| ID | Task description | Layer (BE/FE/Both) | Estimated hours |

Constraints:
- Do not include tasks for writing the PRD or design
- Separate backend, frontend, and test tasks
- Include at least one test task per feature
- Reference the PRD user story ID in your output

User story:
<<<
[PASTE USER STORY + ACCEPTANCE CRITERIA HERE]
>>>
```

**Prompt: Generate ADR**
```
Role: You are a solutions architect documenting an architectural decision.

Context: [PASTE PROJECT CONTEXT]

Task: Write an Architecture Decision Record (ADR) for the following decision.

Format:
# ADR-[NUMBER]: [Decision Title]
**Date:** [DATE]
**Status:** Proposed | Accepted | Deprecated
**Deciders:** [NAMES/ROLES]

## Context
[What is the situation that requires this decision?]

## Decision
[What was decided?]

## Rationale
[Table comparing options considered]

## Consequences
- Positive: ...
- Negative: ...
- Migration trigger: ...

Decision details:
<<<
[DESCRIBE THE DECISION, OPTIONS CONSIDERED, AND REASONING]
>>>
```

---

### Dev Prompts

**Prompt: Implement from Dev Task**
```
Role: You are a senior Node.js developer implementing a REST API endpoint.

Context: [LOAD ARCHITECTURE DOCUMENT AND DEV TASKS AS FILES]

Task: Implement the following dev task. Before writing code:
1. State your implementation plan (components, data flow, error cases)
2. Wait for my approval of the plan
3. Then write the code

Requirements:
- Follow the existing project patterns in the loaded files
- Include input validation using express-validator
- Return errors in the standard format: { success: false, error: { code, message } }
- Write comments for non-obvious logic only

Dev task:
<<<
[PASTE TASK DESCRIPTION + ACCEPTANCE CRITERIA]
>>>
```

**Prompt: Code Review**
```
Role: You are a senior developer doing a code review focused on correctness and security.

Context: This is a Node.js/Express REST API with SQLite. JWT auth is used. See loaded project files.

Task: Review the following code and identify issues in these categories:
1. Security vulnerabilities (injection, auth bypass, data exposure)
2. Logic errors (wrong conditions, missing edge cases, off-by-one)
3. Error handling gaps (unhandled exceptions, missing validation)
4. Performance issues (N+1 queries, missing indexes — SQLite context)

Format: For each issue:
- Severity: Critical | High | Medium | Low
- Line number (if applicable)
- Description of the issue
- Suggested fix (code snippet)

Constraints:
- Do not comment on code style or formatting
- Do not suggest refactoring unless it fixes a bug
- Focus on issues, not improvements

Code to review:
<<<
[PASTE CODE HERE]
>>>
```

---

## Sample Rules File (CLAUDE.md)

Save this as `CLAUDE.md` in the project root. Claude Code reads it automatically.

```markdown
# TaskFlow Project Rules

## Stack
- Backend: Node.js 20 LTS, Express 4, better-sqlite3, JWT (jsonwebtoken), bcrypt
- Frontend: React 18, Vite, React Router v6, Tailwind CSS, Axios
- Testing: Jest + Supertest (backend), Vitest + RTL (frontend)
- NO Redis, NO PostgreSQL, NO session-based auth in v1

## Coding Standards

### Backend
- All routes must use express-validator for input validation
- All errors must use standard format: { success: false, error: { code, message } }
- Never expose password_hash, reset_token, or reset_expires in API responses
- All database queries must use parameterized statements (no string concatenation)
- Use soft delete (is_deleted = 1) — never hard delete tasks
- Always check is_active = 1 when querying users for auth purposes

### Frontend
- Never mutate state directly — always use functional updates with setX(prev => ...)
- All API calls go through src/api/client.js — never use fetch() directly
- Token stored in localStorage as 'token', user as 'user' (JSON)
- All forms must show loading state while submitting
- All forms must show error messages returned from API

### Security
- Never log passwords, tokens, or PII to console in production paths
- Never commit .env files — use .env.example as template
- Rate limiting is applied on /api/auth/* routes

### Git
- Commit messages must reference task ID: "T-021: Implement POST /api/tasks"
- One task per commit where possible
- Do not commit node_modules, .env, or data/*.db files

## Role Permissions Reference
- admin: all actions on all resources
- team_lead: view all team tasks, all regular user actions
- user: create/edit own tasks, update status on assigned tasks, view own tasks only

## Quality Gates
- All endpoints must have at least one test before merge
- No PR merges with failing tests
- No hardcoded credentials or API keys in source code
```

---

## Messy Requirement (Module 4, Exercise 4.2)

**Instructions for trainer:** Give trainees this messy requirement and ask them to use AI to
clean it up into a proper BRD section and then a PRD user story.

```
From: Maria Santos <maria.santos@client.com>
Subject: RE: RE: RE: TaskFlow - some thoughts

Hi,

So I was thinking about the reporting thing we talked about. You know how right now
nobody knows who has what tasks? Like James has to literally ask everyone in the morning
standup. It's such a waste of time. So maybe we can have like some kind of view where
the team leads can see everything? But not like everything everything, just their team's
stuff. And it should probably show which ones are late because that's the main thing.
Oh and can they download it to Excel or something? Because sometimes we need to send
it to the client. Not always but sometimes.

Also separate thing but related - when I log in I want to see MY tasks not everyone's.
That part's important. And overdue ones should be obvious, like red or something.

Let me know what you think

Maria
```

**Exercise:** Use AI to transform this email into:
1. A properly formatted BRD requirement section
2. Two PRD user stories with acceptance criteria

**Trainer note:** This is deliberately vague, contradictory in places ("not everything everything"),
and mixes two separate features. It's representative of real stakeholder input. Trainees should
use AI prompt engineering (chain-of-thought, structured output, iterative refinement) to extract
clean requirements from it.
```
