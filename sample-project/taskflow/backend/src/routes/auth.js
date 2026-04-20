const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const { db } = require('../db/database');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// POST /api/auth/login
router.post('/login',
  body('email').isEmail().normalizeEmail(),
  body('password').notEmpty(),
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: { code: 'VALIDATION_ERROR', message: 'Invalid email or password format' }
        });
      }

      const { email, password } = req.body;
      const user = db.prepare('SELECT * FROM users WHERE email = ? AND is_active = 1').get(email);

      // Use constant-time comparison to prevent timing attacks
      const passwordToCheck = user ? user.password_hash : '$2b$12$invalidhashforcomparison';
      const isValid = await bcrypt.compare(password, passwordToCheck);

      if (!user || !isValid) {
        return res.status(401).json({
          success: false,
          error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' }
        });
      }

      const token = jwt.sign(
        { userId: user.id },
        process.env.JWT_SECRET || 'dev-secret-change-in-prod',
        { expiresIn: '8h' }
      );

      res.json({
        success: true,
        data: {
          token,
          user: { id: user.id, name: user.name, email: user.email, role: user.role, team: user.team }
        }
      });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/auth/logout
router.post('/logout', authenticate, (req, res) => {
  // JWT is stateless — client discards the token
  res.json({ success: true, data: { message: 'Logged out successfully' } });
});

// POST /api/auth/forgot-password
router.post('/forgot-password',
  body('email').isEmail().normalizeEmail(),
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        // Always return 200 to prevent email enumeration
        return res.json({ success: true, data: { message: 'If that email exists, a reset link has been sent.' } });
      }

      const { email } = req.body;
      const user = db.prepare('SELECT id FROM users WHERE email = ? AND is_active = 1').get(email);

      if (user) {
        const crypto = require('crypto');
        const token = crypto.randomBytes(32).toString('hex');
        const expires = new Date(Date.now() + 60 * 60 * 1000).toISOString(); // 1 hour

        db.prepare('UPDATE users SET reset_token = ?, reset_expires = ? WHERE id = ?')
          .run(token, expires, user.id);

        // TODO: Send email via nodemailer
        // In training: just log the token
        console.log(`[DEV] Password reset token for ${email}: ${token}`);
      }

      res.json({ success: true, data: { message: 'If that email exists, a reset link has been sent.' } });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/auth/reset-password
router.post('/reset-password',
  body('token').notEmpty(),
  body('password').isLength({ min: 8 }),
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: { code: 'VALIDATION_ERROR', message: 'Password must be at least 8 characters' }
        });
      }

      const { token, password } = req.body;
      const user = db.prepare(
        "SELECT id FROM users WHERE reset_token = ? AND reset_expires > datetime('now')"
      ).get(token);

      if (!user) {
        return res.status(400).json({
          success: false,
          error: { code: 'INVALID_TOKEN', message: 'Reset token is invalid or expired' }
        });
      }

      const hash = bcrypt.hash(password, 12);
      db.prepare('UPDATE users SET password_hash = ?, reset_token = NULL, reset_expires = NULL WHERE id = ?')
        .run(hash, user.id);

      res.json({ success: true, data: { message: 'Password reset successfully' } });
    } catch (err) {
      next(err);
    }
  }
);

module.exports = router;
