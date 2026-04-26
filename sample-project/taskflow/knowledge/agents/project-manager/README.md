# Project Manager Agents

> **Role focus:** Project setup. Sprint coordination. PRD review for
> completeness. Handoff coordination. Sprint tracking, blockers, status
> communications.

## What lives here

Agent definitions Project Managers build during training to automate recurring
project coordination work. Examples participants might contribute:

- `prd-completeness-reviewer.md` — agent that reviews a PRD for missing
  acceptance criteria, unclear stories, or scope ambiguity.
- `sprint-status-summarizer.md` — agent that turns raw task status into a
  stakeholder-ready summary.
- `handoff-checklist-runner.md` — agent that walks through phase-handoff
  checklists (e.g., before triggering Architecture Review).
- `risk-and-blocker-extractor.md` — agent that pulls risks and blockers out
  of standup notes or chat threads.

## How to add an agent

1. Create a markdown file: `{agent-name}.md` (kebab-case).
2. Add YAML frontmatter (`name`, `description`, optional `tools`).
3. Write the system prompt body below the frontmatter.
4. See `knowledge/agents/dev/code-reviewer.md` as a reference pattern.

## Related

- Reusable prompt templates: `knowledge/prompts/project-manager/`
- Cross-tool wiring guidance: `knowledge/agents/README.md`
