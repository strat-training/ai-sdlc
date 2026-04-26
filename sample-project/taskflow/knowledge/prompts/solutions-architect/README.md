# Solutions Architect Prompts

> **Role focus:** Architecture Document authoring. ADR generation. System
> design. Technical feasibility review of BRD/PRD. Long-context architecture
> work (commonly run in Gemini due to its large context window).

## What lives here

| File | Purpose |
|---|---|
| `generate-dev-tasks.md` | Break down a PRD user story into 1–4 hour Dev Tasks. |

## Suggested prompts to contribute

As participants work through the training, additional prompts to contribute:

- `generate-architecture-document.md` — produce an Architecture Document from
  approved PRD + tech constraints.
- `generate-adr.md` — produce an Architecture Decision Record for a specific
  decision (with options table and rationale).
- `tech-feasibility-review.md` — review a PRD section for technical
  feasibility and flag risks.
- `system-diagram-description.md` — generate a textual description of a
  system diagram suitable for handoff to a diagramming tool.
- `brd-to-tech-constraints.md` — extract technical constraints from a BRD
  for use during architecture design.

## How to contribute

1. Create a new `.md` file in this folder with a clear purpose verb.
2. Use the structure: **Role + Context + Task + Format + Constraints**.
3. Wrap variable input in `<<<` and `>>>` delimiters.
4. Test against TaskFlow's existing approved Architecture Document as the
   quality bar.
5. Submit as a PR. After peer review, it's team property.

## Note on tooling

Architecture work often benefits from Gemini's long context window (load BRD
+ PRD + reference architectures + ADR drafts in one session). The prompts in
this folder are tool-neutral — they work in Claude Code, Antigravity, and
Gemini.
