# Tech Lead Agents

> **Role focus:** Dev Tasks generation and review. Code review. Technical
> oversight. AGENTS.md / CLAUDE.md compliance enforcement.

## What lives here

Agent definitions Tech Leads build during training to automate recurring
oversight and review work. Examples participants might contribute:

- `dev-tasks-generator.md` — agent that breaks down approved PRD user stories
  into 1–4 hour Dev Tasks with PRD references.
- `dev-tasks-quality-checker.md` — agent that verifies generated Dev Tasks are
  atomic, traceable, and properly sized.
- `agents-md-compliance-reviewer.md` — agent that reviews code specifically
  against AGENTS.md rules and flags violations.
- `architecture-deviation-flagger.md` — agent that checks PR diffs for
  deviations from the approved Architecture Document.
- `pr-summary-author.md` — agent that turns a PR diff into a stakeholder
  summary linked to user stories.

## How to add an agent

1. Create a markdown file: `{agent-name}.md` (kebab-case).
2. Add YAML frontmatter (`name`, `description`, optional `tools`).
3. Write the system prompt body below the frontmatter.
4. See `knowledge/agents/dev/code-reviewer.md` as a reference pattern.

## Related

- Reusable prompt templates: `knowledge/prompts/tech-lead/`
- Cross-tool wiring guidance: `knowledge/agents/README.md`
- Reusable skill for compliance: `knowledge/skills/taskflow-quality-gate-check/`
