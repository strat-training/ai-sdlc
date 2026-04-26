# Solutions Designer Agents

> **Role focus:** BRD authoring. Stakeholder analysis. Business requirements
> elicitation.

## What lives here

Agent definitions Solutions Designers build during training to automate
recurring BRD work. Examples participants might contribute:

- `brd-author.md` — agent that drafts a BRD from raw stakeholder input.
- `stakeholder-interviewer.md` — agent that generates targeted interview
  questions based on a project brief.
- `brd-traceability-checker.md` — agent that validates every BRD requirement
  traces to a stated business objective.

## How to add an agent

1. Create a markdown file: `{agent-name}.md` (kebab-case).
2. Add YAML frontmatter:
   ```yaml
   ---
   name: agent-name
   description: One sentence about when to invoke this agent.
   tools: Read, Glob, Grep    # optional, scopes tool access
   ---
   ```
3. Write the system prompt body below the frontmatter.
4. See `knowledge/agents/dev/code-reviewer.md` as a reference pattern.

## Related

- Reusable prompt templates: `knowledge/prompts/solutions-designer/`
- Cross-tool wiring guidance: `knowledge/agents/README.md`
