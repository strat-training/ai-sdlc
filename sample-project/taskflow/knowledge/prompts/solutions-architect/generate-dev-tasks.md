# Generate Dev Tasks from PRD User Story

**Purpose:** Break a PRD user story into independently completable developer tasks.
**Role:** SA
**Tool:** Claude Code | Cursor

## Template

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

## Example Input

```
User story:
<<<
US-10: Add Comment
As a user, I want to add a comment to a task so that I can communicate progress without email.

Acceptance criteria:
- [ ] Comment box on task detail page
- [ ] Comments show author name and timestamp
- [ ] Comments cannot be edited or deleted in v1
- [ ] Max comment length: 1000 characters
>>>
```

## Example Output

```
| T-050 | Create Comment model and migration (task_id, user_id, content, created_at) | BE | 0.5h |
| T-051 | Implement POST /api/tasks/:id/comments with validation | BE | 1h |
| T-052 | Implement GET /api/tasks/:id/comments | BE | 0.5h |
| T-053 | Build CommentSection component (list + form, author + timestamp) | FE | 3h |
| T-054 | Write tests for comment endpoints | BE | 1h |
```

## Notes

- Always load `docs/artifacts/ArchitectureDocument.md` as context before running
- Generated task IDs are suggestions — update to match your actual numbering
- Review generated tasks for dependency order before assigning
