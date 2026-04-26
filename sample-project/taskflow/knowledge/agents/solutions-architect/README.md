# Solutions Architect Agents

> **Role focus:** Architecture Document authoring. ADR generation. System
> design. Technical feasibility review. Long-context architecture work.

## What lives here

Agent definitions Solutions Architects build during training to automate
recurring architecture work. Examples participants might contribute:

- `architecture-document-author.md` — agent that drafts an Architecture
  Document from approved PRD + tech constraints.
- `adr-author.md` — agent that produces an Architecture Decision Record with
  options table and rationale.
- `tech-feasibility-reviewer.md` — agent that reviews a PRD section for
  technical feasibility and flags risks.
- `architecture-compliance-checker.md` — agent that verifies an implementation
  matches the approved Architecture Document and ADRs.

## How to add an agent

1. Create a markdown file: `{agent-name}.md` (kebab-case).
2. Add YAML frontmatter (`name`, `description`, optional `tools`).
3. Write the system prompt body below the frontmatter.
4. See `knowledge/agents/dev/code-reviewer.md` as a reference pattern.

## Note on tooling

Architecture work often benefits from Gemini's long context window. When wiring
an agent into Gemini, paste the system prompt body into a new Gem and attach
the BRD, PRD, and ADR drafts as knowledge files.

## Related

- Reusable prompt templates: `knowledge/prompts/solutions-architect/`
- Cross-tool wiring guidance: `knowledge/agents/README.md`
