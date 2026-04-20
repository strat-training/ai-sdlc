# Generate User Stories from Feature Description

**Purpose:** Convert a raw feature description into structured user stories with acceptance criteria.
**Role:** PM
**Tool:** Claude Code | Cursor | Gemini

## Template

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

## Example Input

```
Feature description:
<<<
Team leads need to see all tasks for their team in one place. They
want to filter by who the task is assigned to and whether it is overdue.
They also need to export the list to send to clients sometimes.
>>>
```

## Example Output

```
**US-09: Team Dashboard**
As a team lead, I want to see all my team's tasks in one view so that I can monitor progress without asking each person individually.

Acceptance criteria:
- [ ] Dashboard shows all tasks assigned to or created by team members
- [ ] Tasks can be filtered by assignee, status, and priority
- [ ] Overdue tasks are visually highlighted
- [ ] Export to CSV includes title, assignee, due date, and status
- [ ] Only team leads and admins can access this view
```

## Notes

- Works best when the feature description is at least 2–3 sentences
- If the description mixes multiple features, ask AI to separate them first
- Use the Validate PRD Against BRD prompt afterward to check coverage
