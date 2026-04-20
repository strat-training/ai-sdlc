# Validate PRD Against BRD

**Purpose:** Check a PRD section for traceability gaps and conflicts against the BRD.
**Role:** PM | SA
**Tool:** Claude Code | Gemini (preferred for long docs)

## Template

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

## Example Input

Load `docs/artifacts/BRD.md` and `docs/artifacts/PRD.md` as context, then ask:

```
Review PRD Feature 3 (Dashboard) against the BRD objectives. Identify coverage gaps and conflicts.
```

## Example Output

```
1. PRD requirements with no BRD objective:
   - None found.

2. BRD objectives not addressed:
   - BRD Objective 1 mentions "notifications when tasks approach due dates" — no PRD user story covers notifications in v1.

3. Conflicts:
   - BRD states "real-time status updates" but PRD specifies no WebSocket requirement — may not meet real-time expectation.
```

## Notes

- Gemini handles large document pairs better than Claude Code for this
- Run after every PRD section is drafted, not just at the end
