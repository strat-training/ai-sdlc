# Tech Lead Prompts

> **Role focus:** Dev Tasks generation and review. Code review. Technical
> oversight. Sizing and risk assessment. CLAUDE.md / AGENTS.md compliance
> enforcement.

## What lives here

Reusable prompt templates that Tech Leads use for task breakdown, code review,
risk surfacing, and technical oversight work.

## Suggested prompts to contribute

This folder is intentionally empty as a starting point. As participants work
through the training, they should contribute prompts like:

- `prd-tech-review.md` — review a PRD section for technical risks, unclear
  acceptance criteria, sizing concerns.
- `dev-task-quality-check.md` — verify that generated Dev Tasks are 1–4 hours
  each, atomic, and traceable to PRD user stories.
- `code-review-with-rules.md` — review code against AGENTS.md and CLAUDE.md
  rules, flag violations with severity and fix suggestions.
- `architecture-deviation-flag.md` — check that an implementation matches the
  approved Architecture Document and ADRs.
- `pr-summary-for-stakeholders.md` — turn a PR diff into a stakeholder-facing
  summary of what shipped.

## How to contribute

1. Create a new `.md` file in this folder with a clear purpose verb.
2. Use the structure: **Role + Context + Task + Format + Constraints**.
3. Reference TaskFlow's `AGENTS.md` rules where relevant — your prompt should
   embed organizational standards.
4. Submit as a PR. After peer review, it's team property.

See `knowledge/prompts/dev/code-review.md` for a structured code-review prompt.
The Tech Lead version should add ADR compliance and architectural-fit checks.

## Related

- `knowledge/agents/code-reviewer.md` — agent definition for invoking code
  review repeatedly. Tech Leads can build their own variant agents that
  enforce specific subsets (e.g., security-only review, ADR-compliance review).
