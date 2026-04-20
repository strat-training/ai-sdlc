const express = require('express');
const { body, validationResult } = require('express-validator');
const { db } = require('../db/database');
const { authenticate, requireRole } = require('../middleware/auth');

const router = express.Router();
router.use(authenticate);

// GET /api/tasks — list tasks scoped by role
router.get('/', (req, res, next) => {
  try {
    const { user } = req;
    let tasks;

    if (user.role === 'admin') {
      tasks = db.prepare(`
        SELECT t.*, u1.name as assignee_name, u2.name as creator_name
        FROM tasks t
        JOIN users u1 ON t.assignee_id = u1.id
        JOIN users u2 ON t.creator_id = u2.id
        WHERE t.is_deleted = 0
        ORDER BY t.due_date ASC
      `).all();
    } else if (user.role === 'team_lead') {
      tasks = db.prepare(`
        SELECT t.*, u1.name as assignee_name, u2.name as creator_name
        FROM tasks t
        JOIN users u1 ON t.assignee_id = u1.id
        JOIN users u2 ON t.creator_id = u2.id
        WHERE t.is_deleted = 0
          AND (u1.team = ? OR u2.team = ?)
        ORDER BY t.due_date ASC
      `).all(user.team, user.team);
    } else {
      tasks = db.prepare(`
        SELECT t.*, u1.name as assignee_name, u2.name as creator_name
        FROM tasks t
        JOIN users u1 ON t.assignee_id = u1.id
        JOIN users u2 ON t.creator_id = u2.id
        WHERE t.is_deleted = 0
          AND (t.assignee_id = ? OR t.creator_id = ?)
        ORDER BY t.due_date ASC
      `).all(user.id, user.id);
    }

    res.json({ success: true, data: tasks });
  } catch (err) {
    next(err);
  }
});

// POST /api/tasks — create task
router.post('/',
  body('title').trim().notEmpty().isLength({ max: 200 }),
  body('assignee_id').isInt(),
  body('due_date').isDate(),
  body('priority').optional().isIn(['Low', 'Medium', 'High']),
  (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: { code: 'VALIDATION_ERROR', message: errors.array()[0].msg }
        });
      }

      const { title, description, assignee_id, due_date, priority = 'Medium' } = req.body;

      // Verify assignee exists
      const assignee = db.prepare('SELECT id FROM users WHERE id = ? AND is_active = 1').get(assignee_id);
      if (!assignee) {
        return res.status(400).json({
          success: false,
          error: { code: 'INVALID_ASSIGNEE', message: 'Assignee not found or inactive' }
        });
      }

      const result = db.prepare(`
        INSERT INTO tasks (title, description, assignee_id, creator_id, due_date, priority)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(title, description || null, assignee_id, req.user.id, due_date, priority);

      // Log activity
      db.prepare(`
        INSERT INTO activity_log (task_id, user_id, action, detail)
        VALUES (?, ?, 'created', ?)
      `).run(result.lastInsertRowid, req.user.id, JSON.stringify({ title }));

      const task = db.prepare('SELECT * FROM tasks WHERE id = ?').get(result.lastInsertRowid);
      res.status(201).json({ success: true, data: task });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/tasks/:id — task detail
router.get('/:id', (req, res, next) => {
  try {
    const task = db.prepare(`
      SELECT t.*, u1.name as assignee_name, u2.name as creator_name
      FROM tasks t
      JOIN users u1 ON t.assignee_id = u1.id
      JOIN users u2 ON t.creator_id = u2.id
      WHERE t.id = ? AND t.is_deleted = 0
    `).get(req.params.id);

    if (!task) {
      return res.status(404).json({
        success: false,
        error: { code: 'NOT_FOUND', message: 'Task not found' }
      });
    }

    // Check access
    const { user } = req;
    const canView = user.role === 'admin'
      || task.assignee_id === user.id
      || task.creator_id === user.id
      || (user.role === 'team_lead');

    if (!canView) {
      return res.status(403).json({
        success: false,
        error: { code: 'FORBIDDEN', message: 'Access denied' }
      });
    }

    const activity = db.prepare(`
      SELECT al.*, u.name as user_name
      FROM activity_log al
      JOIN users u ON al.user_id = u.id
      WHERE al.task_id = ?
      ORDER BY al.created_at ASC
    `).all(req.params.id);

    res.json({ success: true, data: { ...task, activity } });
  } catch (err) {
    next(err);
  }
});

// PATCH /api/tasks/:id/status — update status
router.patch('/:id/status',
  body('status').isIn(['To Do', 'In Progress', 'Done']),
  (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: { code: 'VALIDATION_ERROR', message: 'Invalid status value' }
        });
      }

      const task = db.prepare('SELECT * FROM tasks WHERE id = ? AND is_deleted = 0').get(req.params.id);
      if (!task) return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Task not found' } });

      // Only assignee or admin can update status
      if (task.assignee_id !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ success: false, error: { code: 'FORBIDDEN', message: 'Only the assignee can update status' } });
      }

      // Tasks cannot be re-opened once Done (v1 rule)
      if (task.status === 'Done') {
        return res.status(400).json({ success: false, error: { code: 'INVALID_OPERATION', message: 'Done tasks cannot be re-opened' } });
      }

      const { status } = req.body;
      db.prepare("UPDATE tasks SET status = ?, updated_at = datetime('now') WHERE id = ?").run(status, task.id);

      db.prepare("INSERT INTO activity_log (task_id, user_id, action, detail) VALUES (?, ?, 'status_changed', ?)")
        .run(task.id, req.user.id, JSON.stringify({ from: task.status, to: status }));

      res.json({ success: true, data: { ...task, status } });
    } catch (err) {
      next(err);
    }
  }
);

// DELETE /api/tasks/:id — soft delete
router.delete('/:id', (req, res, next) => {
  try {
    const task = db.prepare('SELECT * FROM tasks WHERE id = ? AND is_deleted = 0').get(req.params.id);
    if (!task) return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Task not found' } });

    if (task.creator_id !== req.user.id || req.user.role !== 'admin') {
      return res.status(403).json({ success: false, error: { code: 'FORBIDDEN', message: 'Only the creator or admin can delete a task' } });
    }

    db.prepare("UPDATE tasks SET is_deleted = 1, updated_at = datetime('now') WHERE id = ?").run(task.id);
    db.prepare("INSERT INTO activity_log (task_id, user_id, action) VALUES (?, ?, 'deleted')").run(task.id, req.user.id);

    res.json({ success: true, data: { message: 'Task deleted' } });
  } catch (err) {
    next(err);
  }
});

// POST /api/tasks/:id/comments
router.post('/:id/comments',
  body('content').trim().notEmpty().isLength({ max: 1000 }),
  (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: errors.array()[0].msg } });
      }

      const task = db.prepare('SELECT id FROM tasks WHERE id = ? AND is_deleted = 0').get(req.params.id);
      if (!task) return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Task not found' } });

      const result = db.prepare('INSERT INTO comments (task_id, user_id, content) VALUES (?, ?, ?)')
        .run(task.id, req.user.id, req.body.content);

      const comment = db.prepare(`
        SELECT c.*, u.name as user_name FROM comments c
        JOIN users u ON c.user_id = u.id WHERE c.id = ?
      `).get(result.lastInsertRowid);

      res.status(201).json({ success: true, data: comment });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/tasks/:id/comments
router.get('/:id/comments', (req, res, next) => {
  try {
    const comments = db.prepare(`
      SELECT c.*, u.name as user_name FROM comments c
      JOIN users u ON c.user_id = u.id
      WHERE c.task_id = ?
      ORDER BY c.created_at ASC
    `).all(req.params.id);
    res.json({ success: true, data: comments });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
