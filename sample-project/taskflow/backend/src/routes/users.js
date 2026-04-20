const express = require('express');
const bcrypt = require('bcrypt');
const { body, validationResult } = require('express-validator');
const { db } = require('../db/database');
const { authenticate, requireRole } = require('../middleware/auth');

const router = express.Router();
router.use(authenticate);
router.use(requireRole('admin'));

// GET /api/users — list all users (admin only)
router.get('/', (req, res, next) => {
  try {
    const users = db.prepare(
      'SELECT id, name, email, role, team, is_active, created_at FROM users ORDER BY name ASC'
    ).all();
    res.json({ success: true, data: users });
  } catch (err) {
    next(err);
  }
});

// POST /api/users — create user (admin only)
router.post('/',
  body('name').trim().notEmpty(),
  body('email').isEmail().normalizeEmail(),
  body('role').isIn(['user', 'team_lead', 'admin']),
  body('team').optional().trim(),
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: { code: 'VALIDATION_ERROR', message: errors.array()[0].msg }
        });
      }

      const { name, email, role, team } = req.body;
      // Temporary password — user must reset
      const tempPassword = Math.random().toString(36).slice(-10);
      const hash = await bcrypt.hash(tempPassword, 12);

      const result = db.prepare(
        'INSERT INTO users (name, email, password_hash, role, team) VALUES (?, ?, ?, ?, ?)'
      ).run(name, email, hash, role, team || null);

      // TODO: Send welcome email with temp password
      console.log(`[DEV] Temp password for ${email}: ${tempPassword}`);

      const user = db.prepare('SELECT id, name, email, role, team, is_active FROM users WHERE id = ?').get(result.lastInsertRowid);
      res.status(201).json({ success: true, data: user });
    } catch (err) {
      next(err);
    }
  }
);

// PATCH /api/users/:id — activate/deactivate (admin only, not self)
router.patch('/:id',
  body('is_active').isBoolean(),
  (req, res, next) => {
    try {
      if (parseInt(req.params.id) === req.user.id) {
        return res.status(400).json({
          success: false,
          error: { code: 'INVALID_OPERATION', message: 'You cannot deactivate your own account' }
        });
      }

      const user = db.prepare('SELECT id FROM users WHERE id = ?').get(req.params.id);
      if (!user) return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'User not found' } });

      db.prepare('UPDATE users SET is_active = ? WHERE id = ?').run(req.body.is_active ? 1 : 0, req.params.id);
      const updated = db.prepare('SELECT id, name, email, role, team, is_active FROM users WHERE id = ?').get(req.params.id);

      res.json({ success: true, data: updated });
    } catch (err) {
      next(err);
    }
  }
);

module.exports = router;
