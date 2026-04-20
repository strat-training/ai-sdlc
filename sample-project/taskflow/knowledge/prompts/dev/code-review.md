# Code Review

**Purpose:** AI-assisted first-pass code review focused on security and correctness.
**Role:** Dev | TL
**Tool:** Claude Code | Cursor

## Template

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

## Example Input

```
Code to review:
<<<
[paste of tasks.js GET /:id/comments route]
>>>
```

## Example Output

```
1. Severity: Critical
   Line: 232
   Issue: No authorization check — any authenticated user can read comments for any task ID,
   including tasks they have no access to.
   Fix: Add access check matching GET /api/tasks/:id before returning comments.
```

## Notes

- More effective when you also load CLAUDE.md so the reviewer knows project standards
- Run before every PR — catches issues human reviewers often miss on first pass
- AI review is a first pass only — human review is still required before merge
