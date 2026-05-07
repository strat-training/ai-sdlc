# Training Props: Buggy Functions
## Module 5 — Debugging Exercise (Exercise 5.2)

**Instructions for trainer:** Present these functions one at a time. Ask trainees to use AI-assisted
debugging to find and fix each bug. Each function has ONE intentional bug. Solutions are in the
`## Solution` section below each function — do not share until trainees have attempted the exercise.

---

## Bug 1: Off-by-one in overdue detection

```javascript
// taskflow/backend/src/utils/taskHelpers.js
// BUG: This function is supposed to return true if a task is overdue.
// It's being used to highlight tasks on the dashboard, but some tasks
// that are clearly overdue aren't being flagged.

function isTaskOverdue(task) {
  const today = new Date();
  const dueDate = new Date(task.due_date);
  return dueDate < today && task.status !== 'Done';
}
```

**Symptom:** Tasks due TODAY are showing as overdue, but tasks due YESTERDAY are not. Users are
complaining that a task due "2026-03-25" shows as overdue on 2026-03-25 (same day) but a task
due "2026-03-24" does NOT show as overdue on 2026-03-25.

**Hint for trainees:** Run this in your console and observe the output:
```javascript
const today = new Date(); // includes time: 2026-03-25T14:30:00
const dueDate = new Date('2026-03-24'); // midnight: 2026-03-24T00:00:00
console.log(dueDate < today); // What does this return?
```

**Root cause:** `new Date('2026-03-24')` creates a date at midnight UTC, which when compared to
`new Date()` (current local time, likely afternoon) correctly shows as less than today. BUT
`new Date('2026-03-25')` at midnight UTC may be GREATER than today's time if the user is in a
timezone ahead of UTC (e.g., PHT is UTC+8 — at 9am PHT, UTC is 1am the same day, so midnight
UTC of 2026-03-25 was already passed).

## Solution 1
```javascript
function isTaskOverdue(task) {
  // Compare date strings directly — avoids timezone/time-of-day issues
  const today = new Date().toISOString().split('T')[0]; // '2026-03-25'
  return task.due_date < today && task.status !== 'Done';
}
```

---

## Bug 2: Missing await causes silent failure

```javascript
// taskflow/backend/src/routes/auth.js
// BUG: Password reset appears to succeed (returns 200) but the password
// never actually changes. Users report the old password still works after reset.

router.post('/reset-password', async (req, res) => {
  const { token, password } = req.body;

  const user = db.prepare(
    "SELECT id FROM users WHERE reset_token = ? AND reset_expires > datetime('now')"
  ).get(token);

  if (!user) {
    return res.status(400).json({ success: false, error: { message: 'Invalid or expired token' } });
  }

  // Hash the new password and update
  const hash = bcrypt.hash(password, 12); // <-- line 18

  db.prepare('UPDATE users SET password_hash = ?, reset_token = NULL WHERE id = ?')
    .run(hash, user.id);

  res.json({ success: true, data: { message: 'Password reset successfully' } });
});
```

**Symptom:** API returns `{ success: true }` but password doesn't change. Old password still works.
No error in logs.

**Root cause:** `bcrypt.hash()` is async and returns a Promise. Without `await`, `hash` is a
Promise object (not a string). SQLite stores the stringified Promise `"[object Promise]"` as the
password_hash. Login then compares the real password against `"[object Promise]"` which always fails —
so the user can't log in at all with the new password, but the old hash was overwritten.

## Solution 2
```javascript
const hash = await bcrypt.hash(password, 12); // add await
```

---

## Bug 3: Authorization logic flaw — anyone can delete any task

```javascript
// taskflow/backend/src/routes/tasks.js
// BUG: Task deletion is supposed to be restricted to creators and admins only.
// But QA found that any logged-in user can delete any task.

router.delete('/:id', (req, res, next) => {
  try {
    const task = db.prepare('SELECT * FROM tasks WHERE id = ? AND is_deleted = 0').get(req.params.id);
    if (!task) return res.status(404).json({ success: false, error: { message: 'Task not found' } });

    // Authorization check
    if (task.creator_id !== req.user.id || req.user.role !== 'admin') { // <-- line 8
      return res.status(403).json({ success: false, error: { message: 'Only the creator or admin can delete' } });
    }

    db.prepare("UPDATE tasks SET is_deleted = 1 WHERE id = ?").run(task.id);
    res.json({ success: true, data: { message: 'Task deleted' } });
  } catch (err) {
    next(err);
  }
});
```

**Symptom:** QA logs in as a regular user, deletes another user's task. No 403 returned.

**Root cause:** `||` should be `&&`. The condition `task.creator_id !== req.user.id || req.user.role !== 'admin'`
returns `true` for admins (because their role IS 'admin', so `role !== 'admin'` is false, but
`creator_id !== user.id` might be true). For regular users who ARE the creator,
`creator_id !== req.user.id` is false, so the condition checks `|| role !== 'admin'` which is true
(they're not admin) — meaning it BLOCKS the creator. For a random user who isn't the creator AND
isn't admin: `creator_id !== user.id` is true, short-circuits, and the whole `||` is true — BLOCKS.

Wait — actually the bug is the opposite: `||` means the condition passes (blocks) if EITHER is true.
The user who isn't creator (true) triggers the block regardless of role. But the condition should
block UNLESS creator OR admin. The correct logic is: block if NOT (creator OR admin), i.e.,
`task.creator_id !== req.user.id && req.user.role !== 'admin'`.

## Solution 3
```javascript
if (task.creator_id !== req.user.id && req.user.role !== 'admin') {
  return res.status(403).json({ ... });
}
```

---

## Bug 4: React state mutation causes missed re-render

```javascript
// taskflow/frontend/src/pages/DashboardPage.jsx
// BUG: When a task is marked as Done from the task detail page and the user
// navigates back to the dashboard, the task still shows its old status.
// Refreshing the page shows the correct status.

function DashboardPage() {
  const [tasks, setTasks] = useState([]);

  const handleStatusUpdate = (taskId, newStatus) => {
    const taskIndex = tasks.findIndex(t => t.id === taskId);
    if (taskIndex === -1) return;

    // Update the task in the list
    tasks[taskIndex].status = newStatus; // <-- line 10
    setTasks(tasks);
  };

  // ... rest of component
}
```

**Symptom:** Status updates appear to not save, but a page refresh shows the correct status.
React DevTools shows the state has the right value but the component doesn't re-render.

**Root cause:** `tasks[taskIndex].status = newStatus` mutates the existing array directly. React
uses referential equality to detect state changes — since `tasks` is the same array reference,
`setTasks(tasks)` passes the same reference React already has. React sees no change and skips
the re-render.

## Solution 4
```javascript
const handleStatusUpdate = (taskId, newStatus) => {
  setTasks(prev => prev.map(t =>
    t.id === taskId ? { ...t, status: newStatus } : t
  ));
};
```
