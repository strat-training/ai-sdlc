const Database = require('better-sqlite3');
const path = require('path');

const DB_PATH = process.env.DB_PATH || path.join(__dirname, '../../data/taskflow.db');

const db = new Database(DB_PATH);

// Enable WAL mode for better concurrent read performance
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// Run migrations
function migrate() {
  db.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id            INTEGER PRIMARY KEY AUTOINCREMENT,
      name          TEXT NOT NULL,
      email         TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      role          TEXT NOT NULL DEFAULT 'user',
      team          TEXT,
      is_active     INTEGER NOT NULL DEFAULT 1,
      reset_token   TEXT,
      reset_expires DATETIME,
      created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS tasks (
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      title       TEXT NOT NULL,
      description TEXT,
      assignee_id INTEGER NOT NULL REFERENCES users(id),
      creator_id  INTEGER NOT NULL REFERENCES users(id),
      due_date    DATE NOT NULL,
      priority    TEXT NOT NULL DEFAULT 'Medium',
      status      TEXT NOT NULL DEFAULT 'To Do',
      is_deleted  INTEGER NOT NULL DEFAULT 0,
      created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS comments (
      id         INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id    INTEGER NOT NULL REFERENCES tasks(id),
      user_id    INTEGER NOT NULL REFERENCES users(id),
      content    TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS activity_log (
      id         INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id    INTEGER NOT NULL REFERENCES tasks(id),
      user_id    INTEGER NOT NULL REFERENCES users(id),
      action     TEXT NOT NULL,
      detail     TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
  `);

  // Seed admin user for development
  const adminExists = db.prepare("SELECT id FROM users WHERE email = 'admin@taskflow.dev'").get();
  if (!adminExists) {
    const bcrypt = require('bcrypt');
    const hash = bcrypt.hashSync('Admin1234!', 12);
    db.prepare(`
      INSERT INTO users (name, email, password_hash, role)
      VALUES ('Admin User', 'admin@taskflow.dev', ?, 'admin')
    `).run(hash);
    console.log('Seeded admin user: admin@taskflow.dev / Admin1234!');
  }

  console.log('Database migrated successfully');
}

module.exports = { db, migrate };
