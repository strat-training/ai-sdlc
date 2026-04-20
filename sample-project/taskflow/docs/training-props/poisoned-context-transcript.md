# Training Props: Poisoned Context Transcript
## Module 5 — Exercise 5.2

**Instructions for trainer:** Share this transcript with trainees. Ask them to:
1. Identify WHERE context got poisoned
2. Identify WHAT caused it
3. Identify WHEN the session should have been cleared

Do not reveal the answers until trainees have completed their analysis.

---

## The Transcript

This is a real session transcript (lightly edited) of a developer working on TaskFlow's
authentication module. Read through and identify where things go wrong.

---

**[Message 1]**
> **Dev:** I'm working on the TaskFlow backend. The project uses Node.js/Express with SQLite.
> I need to implement JWT authentication. Users should stay logged in for 8 hours.

**[Claude Code]:** Great. I'll implement JWT auth for your Express API. For 8-hour sessions
we'll use `jsonwebtoken` with an 8h expiry. Here's the login endpoint:

```javascript
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  if (!user || !await bcrypt.compare(password, user.password_hash)) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, { expiresIn: '8h' });
  res.json({ token, user: { id: user.id, name: user.name, role: user.role } });
});
```

---

**[Message 2]**
> **Dev:** Good. Now I need a middleware to verify JWT tokens on protected routes.

**[Claude Code]:** Here's the auth middleware:

```javascript
function authenticate(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token' });
  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
}
```

---

**[Message 3]**
> **Dev:** Actually, we decided to switch from JWT to session-based auth using express-session.
> Sessions should be stored in Redis. The session timeout should be 2 hours.

**[Claude Code]:** Got it — switching to session-based auth with Redis. Here's the updated setup:

```javascript
const session = require('express-session');
const RedisStore = require('connect-redis').default;
const { createClient } = require('redis');

const redisClient = createClient();
redisClient.connect();

app.use(session({
  store: new RedisStore({ client: redisClient }),
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 2 * 60 * 60 * 1000 } // 2 hours
}));
```

And the updated login to use sessions:

```javascript
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  if (!user || !await bcrypt.compare(password, user.password_hash)) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  req.session.userId = user.id;
  res.json({ user: { id: user.id, name: user.name } });
});
```

---

**[Message 4]**
> **Dev:** Great. Now let's implement the password reset flow. I want tokens that expire in 1 hour.

**[Claude Code]:** Here's the password reset flow using session-based auth. The reset token
will be stored in Redis alongside the session data:

```javascript
router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;
  const user = db.prepare('SELECT id FROM users WHERE email = ?').get(email);
  if (!user) return res.json({ message: 'If that email exists, a link has been sent.' });

  const token = crypto.randomBytes(32).toString('hex');
  // Store token in Redis with 1-hour expiry
  await redisClient.setEx(`reset:${token}`, 3600, String(user.id));

  // Send email with token...
  console.log(`Reset token: ${token}`);
  res.json({ message: 'Reset link sent.' });
});

router.post('/reset-password', async (req, res) => {
  const { token, password } = req.body;
  // Look up token in Redis
  const userId = await redisClient.get(`reset:${token}`);
  if (!userId) return res.status(400).json({ error: 'Invalid or expired token' });

  const hash = await bcrypt.hash(password, 12);
  db.prepare('UPDATE users SET password_hash = ? WHERE id = ?').run(hash, userId);
  await redisClient.del(`reset:${token}`);
  res.json({ message: 'Password reset successfully' });
});
```

---

**[Message 5]**
> **Dev:** Wait — I checked with the team and we're NOT switching to Redis. We're staying with
> JWT and SQLite. No Redis, no express-session. Please revert to JWT.

**[Claude Code]:** Understood. Reverting to JWT. Here's the corrected forgot-password
using JWT tokens and SQLite storage:

```javascript
router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;
  const user = db.prepare('SELECT id FROM users WHERE email = ?').get(email);
  if (!user) return res.json({ message: 'If that email exists, a link has been sent.' });

  // Generate JWT reset token with 1-hour expiry
  const token = jwt.sign({ userId: user.id, type: 'reset' }, process.env.JWT_SECRET, { expiresIn: '1h' });

  // Store in Redis for tracking ← POISONED: still referencing Redis
  await redisClient.setEx(`reset:${token}`, 3600, String(user.id));

  res.json({ message: 'Reset link sent.' });
});
```

---

**[Message 6]**
> **Dev:** The reset endpoint is working but I'm getting a `redisClient is not defined` error.
> I thought we removed Redis?

**[Claude Code]:** You're right, my apologies. Replace the Redis line with a SQLite insert:

```javascript
db.prepare('UPDATE users SET reset_token = ?, reset_expires = ? WHERE id = ?')
  .run(token, new Date(Date.now() + 3600000).toISOString(), user.id);
```

But keep the JWT-based token generation. The session middleware is still needed for the admin
panel though — make sure `app.use(session(...))` is in your app setup. ← STILL POISONED

---

**[Message 7]**
> **Dev:** We have no session middleware. We're using JWT everywhere. There's no admin panel
> requiring sessions. Can you write the complete auth.js file from scratch, JWT only?

**[Claude Code]:** Of course. Here's the complete JWT-only auth.js:

```javascript
// ... [generates mostly correct code]

// But at the bottom:
// Make sure your app.js has Redis connected for the rate limiter store ← STILL POISONED
// const RedisStore = require('rate-limit-redis');
```

---

**[Message 8]**
> **Dev:** Why does it keep mentioning Redis? We removed Redis 3 messages ago.

---

## Analysis (Trainer's Guide)

### Where did context get poisoned?
**Message 3** — the developer said "switch to Redis/sessions." Claude correctly updated to Redis.

### What caused the poisoning?
**Message 5** — the developer reverted ("no Redis, stay with JWT") but Claude's context still
contained all the Redis/session code from messages 3-4. The context window held both the "use Redis"
and "don't use Redis" instructions simultaneously, creating a contradiction it couldn't resolve cleanly.

### When should the session have been cleared?
**After Message 5** — the moment the architectural decision changed, the session should have been
cleared and restarted with a clean context summary:

> *"Summary: We're building JWT auth (no Redis, no sessions). Stack: Node/Express/SQLite/JWT.
> Session timeout: 8h. Next: implement forgot-password using SQLite for token storage."*

### Signs of poisoning that trainees should identify:
- Message 6: Redis reference reappears despite being explicitly removed (Message 5)
- Message 6: "session middleware is still needed" — a direct contradiction of Message 5
- Message 7: Redis reference appears again in a supposedly clean rewrite
- Message 8: Developer notices and calls it out explicitly

### Why didn't correction fix it?
Each correction in messages 5-7 added more text to the context, but the poisoning source (the
Redis/session instructions from messages 3-4) remained in the context window. New instructions
couldn't fully overwrite prior ones — they competed. The fix was to start fresh, not to keep correcting.
