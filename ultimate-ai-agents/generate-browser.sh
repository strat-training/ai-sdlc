#!/bin/bash
# generate-browser.sh — Build a self-contained HTML agent browser
# Reads all agents from agents/claude/ and generates index.html
# Usage: ./generate-browser.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

OUT="index.html"

# ─── Collect agent data ────────────────────────────────────────────────────────
# We'll embed agent metadata as JSON, and full prompts as data attributes
AGENTS_JSON="["
FIRST=true

while IFS= read -r f; do
  # Parse frontmatter
  name=$(sed -n 's/^name: *//p' "$f" | head -1)
  desc=$(sed -n 's/^description: *//p' "$f" | head -1)

  # Extract department from path: agents/claude/<dept>/... or agents/claude/<dept>/<subdept>/...
  rel_path="${f#agents/claude/}"
  dept=$(echo "$rel_path" | cut -d'/' -f1)

  # Extract prompt body (everything after second ---)
  prompt=$(sed -n '/^---$/,/^---$/d; p' "$f")

  # Escape for JSON
  name_esc=$(echo "$name" | sed 's/"/\\"/g')
  desc_esc=$(echo "$desc" | sed 's/"/\\"/g')
  prompt_esc=$(echo "$prompt" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')
  dept_esc=$(echo "$dept" | sed 's/"/\\"/g')

  if [ "$FIRST" = true ]; then FIRST=false; else AGENTS_JSON+=","; fi
  AGENTS_JSON+="{\"name\":\"$name_esc\",\"desc\":\"$desc_esc\",\"dept\":\"$dept_esc\",\"prompt\":$prompt_esc}"
done < <(find agents/claude -name "*.md" -type f | sort)

AGENTS_JSON+="]"

# ─── Generate HTML ─────────────────────────────────────────────────────────────
cat > "$OUT" <<'HTMLHEAD'
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ultimate AI Agents</title>
<style>
  :root, [data-theme="light"] {
    --bg: #ffffff;
    --card: #f9fafb;
    --border: #e5e7eb;
    --text: #111827;
    --muted: #6b7280;
    --accent: #3b82f6;
    --accent-hover: #2563eb;
    --green: #22c55e;
    --radius: 8px;
  }
  [data-theme="dark"] {
    --bg: #0a0a0a;
    --card: #141414;
    --border: #262626;
    --text: #e5e5e5;
    --muted: #737373;
  }
  @media (prefers-color-scheme: dark) {
    :root:not([data-theme="light"]) {
      --bg: #0a0a0a;
      --card: #141414;
      --border: #262626;
      --text: #e5e5e5;
      --muted: #737373;
    }
  }
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: var(--bg);
    color: var(--text);
    line-height: 1.6;
    padding: 2rem;
    max-width: 1200px;
    margin: 0 auto;
  }
  h1 { font-size: 1.75rem; font-weight: 700; margin-bottom: 0.25rem; }
  .subtitle { color: var(--muted); margin-bottom: 0; font-size: 0.9rem; }

  /* Sticky header */
  .sticky-header {
    position: sticky;
    top: 0;
    z-index: 50;
    background: var(--bg);
    padding-bottom: 1rem;
    margin: -2rem -2rem 1.5rem -2rem;
    padding: 1.5rem 2rem 1rem 2rem;
    border-bottom: 1px solid var(--border);
  }

  /* Controls */
  .controls {
    display: flex;
    gap: 0.75rem;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
    align-items: center;
  }
  .search {
    flex: 1;
    min-width: 200px;
    padding: 0.5rem 0.75rem;
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text);
    font-size: 0.875rem;
    outline: none;
  }
  .search:focus { border-color: var(--accent); }
  .filter-btn {
    padding: 0.4rem 0.75rem;
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--muted);
    font-size: 0.8rem;
    cursor: pointer;
    transition: all 0.15s;
  }
  .filter-btn:hover { border-color: var(--accent); color: var(--text); }
  .filter-btn.active { background: var(--accent); border-color: var(--accent); color: #fff; }

  /* Platform selector */
  .platform-bar {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1.5rem;
    padding: 0.75rem;
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    align-items: center;
    flex-wrap: wrap;
  }
  .platform-bar label { color: var(--muted); font-size: 0.8rem; margin-right: 0.5rem; }
  .platform-btn {
    padding: 0.35rem 0.7rem;
    background: transparent;
    border: 1px solid var(--border);
    border-radius: 6px;
    color: var(--muted);
    font-size: 0.8rem;
    cursor: pointer;
    transition: all 0.15s;
  }
  .platform-btn:hover { color: var(--text); border-color: var(--muted); }
  .platform-btn.active { background: var(--accent); border-color: var(--accent); color: #fff; }

  /* Grid */
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 0.75rem;
  }

  /* Card */
  .card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 1rem;
    transition: border-color 0.15s;
    cursor: pointer;
  }
  .card:hover { border-color: var(--accent); }
  .card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem; }
  .card-name { font-weight: 600; font-size: 0.95rem; }
  .card-dept {
    font-size: 0.7rem;
    padding: 0.15rem 0.5rem;
    background: var(--bg);
    border-radius: 4px;
    color: var(--muted);
    white-space: nowrap;
  }
  .card-desc {
    font-size: 0.8rem;
    color: var(--muted);
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  /* Modal */
  .modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.7);
    z-index: 100;
    justify-content: center;
    align-items: flex-start;
    padding: 3rem 1rem;
    overflow-y: auto;
  }
  .modal-overlay.open { display: flex; }
  .modal {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 12px;
    max-width: 720px;
    width: 100%;
    padding: 1.5rem;
  }
  .modal-title { font-size: 1.25rem; font-weight: 700; margin-bottom: 0.25rem; }
  .modal-dept { color: var(--muted); font-size: 0.8rem; margin-bottom: 1rem; }
  .modal-instructions {
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 1rem;
    margin-bottom: 1rem;
    font-size: 0.8rem;
    color: var(--muted);
    line-height: 1.5;
  }
  .modal-instructions strong { color: var(--text); }
  .prompt-box {
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 1rem;
    max-height: 400px;
    overflow-y: auto;
    font-size: 0.8rem;
    font-family: 'SF Mono', 'Fira Code', monospace;
    white-space: pre-wrap;
    word-wrap: break-word;
    line-height: 1.5;
    margin-bottom: 1rem;
  }
  .btn-row { display: flex; gap: 0.5rem; flex-wrap: wrap; }
  .copy-btn {
    padding: 0.5rem 1rem;
    background: var(--accent);
    border: none;
    border-radius: var(--radius);
    color: #fff;
    font-size: 0.85rem;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.15s;
  }
  .copy-btn:hover { background: var(--accent-hover); }
  .copy-btn.copied { background: var(--green); }
  .close-btn {
    padding: 0.5rem 1rem;
    background: transparent;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--muted);
    font-size: 0.85rem;
    cursor: pointer;
  }
  .close-btn:hover { color: var(--text); border-color: var(--muted); }

  .count { color: var(--muted); font-size: 0.8rem; margin-bottom: 1rem; }

  /* Dev bar */
  .dev-bar {
    display: flex;
    gap: 0.75rem;
    margin-bottom: 1.5rem;
    padding: 0.75rem 1rem;
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    align-items: center;
    flex-wrap: wrap;
    font-size: 0.8rem;
    color: var(--muted);
  }
  .dev-bar span { margin-right: auto; }
  .dev-link {
    padding: 0.35rem 0.7rem;
    background: transparent;
    border: 1px solid var(--border);
    border-radius: 6px;
    color: var(--muted);
    font-size: 0.8rem;
    text-decoration: none;
    transition: all 0.15s;
  }
  .dev-link:hover { color: var(--text); border-color: var(--muted); }
</style>
</head>
<body>

<div class="sticky-header">
<div style="display:flex;justify-content:space-between;align-items:flex-start">
  <div>
    <h1>Ultimate AI Agents</h1>
    <p class="subtitle">Browse agents by department. Click any agent to copy its prompt for your platform.</p>
  </div>
  <button id="theme-toggle" title="Toggle theme" style="background:none;border:1px solid var(--border);border-radius:var(--radius);padding:0.4rem 0.6rem;cursor:pointer;color:var(--text);font-size:1.1rem;line-height:1">
    <span id="theme-icon"></span>
  </button>
</div>

<div class="dev-bar" style="margin-top:0.75rem;margin-bottom:0">
  <span>For developers and advanced users:</span>
  <a href="https://ultimate-ai-agents-docs.pages.dev/install" class="dev-link" target="_blank">CLI Install Guide</a>
  <a href="https://ultimate-ai-agents-docs.pages.dev/platforms" class="dev-link" target="_blank">Platform Integration</a>
  <a href="https://ultimate-ai-agents-docs.pages.dev/reference" class="dev-link" target="_blank">Reference Docs</a>
  <a href="https://github.com/stratpoint-engineering/ultimate-ai-agents" class="dev-link" target="_blank">GitHub</a>
</div>

<div class="platform-bar" style="margin-top:0.75rem;margin-bottom:0">
  <label>Platform:</label>
  <button class="platform-btn active" data-platform="claude-web">Claude.ai</button>
  <button class="platform-btn" data-platform="chatgpt">ChatGPT</button>
  <button class="platform-btn" data-platform="gemini-web">Gemini</button>
  <button class="platform-btn" data-platform="ai-studio">AI Studio</button>
  <button class="platform-btn" data-platform="generic">Any LLM</button>
</div>

<div class="controls" style="margin-top:0.75rem;margin-bottom:0">
  <input class="search" type="text" placeholder="Search agents..." id="search">
  <button class="filter-btn active" data-dept="all">All</button>
</div>
</div>

<p class="count" id="count"></p>
<div class="grid" id="grid"></div>

<div class="modal-overlay" id="modal">
  <div class="modal">
    <div class="modal-title" id="modal-name"></div>
    <div class="modal-dept" id="modal-dept"></div>
    <div class="modal-instructions" id="modal-instructions"></div>
    <div class="prompt-box" id="modal-prompt"></div>
    <div class="btn-row">
      <button class="copy-btn" id="copy-btn">Copy to Clipboard</button>
      <button class="close-btn" id="close-btn">Close</button>
    </div>
  </div>
</div>

<script>
HTMLHEAD

# Inject the agents JSON
echo "const AGENTS = $AGENTS_JSON;" >> "$OUT"

cat >> "$OUT" <<'HTMLTAIL'

const DEPT_LABELS = {
  'engineering': 'Engineering',
  'product-design': 'Product & Design',
  'project-management': 'Project Management',
  'sales': 'Sales',
  'marketing': 'Marketing',
  'hr': 'HR',
  'l-and-d': 'L&D',
  'finance': 'Finance',
  'operations': 'Operations',
  'admin': 'Admin',
  'leadership': 'Leadership'
};

const PLATFORM_INSTRUCTIONS = {
  'claude-web': {
    label: 'Claude.ai Projects',
    steps: `<strong>How to install in Claude.ai:</strong><br>
1. Go to <strong>claude.ai</strong> → create or open a <strong>Project</strong><br>
2. Click <strong>Project instructions</strong> (or Custom instructions)<br>
3. Paste the prompt below into the instructions field<br>
4. Save — the agent is now active for all chats in this project`
  },
  'chatgpt': {
    label: 'ChatGPT',
    steps: `<strong>How to install in ChatGPT:</strong><br>
1. Go to <strong>chatgpt.com</strong> → <strong>Explore GPTs</strong> → <strong>Create</strong><br>
2. In the <strong>Instructions</strong> field, paste the prompt below<br>
3. Name the GPT and save<br>
<em>Or:</em> Go to <strong>Settings → Personalization → Custom Instructions</strong> and paste there`
  },
  'gemini-web': {
    label: 'Gemini Gems',
    steps: `<strong>How to install as a Gemini Gem:</strong><br>
1. Go to <strong>gemini.google.com</strong> → <strong>Gems</strong> → <strong>Create a Gem</strong><br>
2. Paste the prompt below into the <strong>System Instruction</strong> field<br>
3. Give it a name and save`
  },
  'ai-studio': {
    label: 'Google AI Studio',
    steps: `<strong>How to install in AI Studio:</strong><br>
1. Go to <strong>aistudio.google.com</strong> → <strong>Create prompt</strong><br>
2. Paste the prompt below into the <strong>System instructions</strong> field<br>
3. Select your model and start chatting`
  },
  'generic': {
    label: 'Any LLM',
    steps: `<strong>Universal installation:</strong><br>
1. Open your LLM's settings or system prompt field<br>
2. Paste the prompt below<br>
3. Start a new conversation — the agent is active<br>
<em>Works with:</em> Perplexity, Mistral, Llama, Cohere, local models, etc.`
  }
};

let currentPlatform = 'claude-web';
let currentDept = 'all';
let currentSearch = '';

// Build department filters
const depts = [...new Set(AGENTS.map(a => a.dept))].sort();
const controls = document.querySelector('.controls');
depts.forEach(d => {
  const btn = document.createElement('button');
  btn.className = 'filter-btn';
  btn.dataset.dept = d;
  btn.textContent = DEPT_LABELS[d] || d;
  controls.appendChild(btn);
});

// Render
function render() {
  const grid = document.getElementById('grid');
  const filtered = AGENTS.filter(a => {
    if (currentDept !== 'all' && a.dept !== currentDept) return false;
    if (currentSearch && !a.name.includes(currentSearch) && !a.desc.toLowerCase().includes(currentSearch)) return false;
    return true;
  });

  document.getElementById('count').textContent = `${filtered.length} agent${filtered.length !== 1 ? 's' : ''}`;

  grid.innerHTML = filtered.map((a, i) => `
    <div class="card" data-idx="${AGENTS.indexOf(a)}">
      <div class="card-header">
        <span class="card-name">${a.name}</span>
        <span class="card-dept">${DEPT_LABELS[a.dept] || a.dept}</span>
      </div>
      <div class="card-desc">${a.desc.substring(0, 150)}${a.desc.length > 150 ? '...' : ''}</div>
    </div>
  `).join('');
}

// Events
document.querySelectorAll('.filter-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    currentDept = btn.dataset.dept;
    render();
  });
});

document.querySelectorAll('.platform-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.platform-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    currentPlatform = btn.dataset.platform;
  });
});

document.getElementById('search').addEventListener('input', e => {
  currentSearch = e.target.value.toLowerCase();
  render();
});

// Card click → modal
document.getElementById('grid').addEventListener('click', e => {
  const card = e.target.closest('.card');
  if (!card) return;
  const agent = AGENTS[card.dataset.idx];
  const platform = PLATFORM_INSTRUCTIONS[currentPlatform];

  document.getElementById('modal-name').textContent = agent.name;
  document.getElementById('modal-dept').textContent = DEPT_LABELS[agent.dept] || agent.dept;
  document.getElementById('modal-instructions').innerHTML = platform.steps;
  document.getElementById('modal-prompt').textContent = agent.prompt.trim();
  document.getElementById('modal').classList.add('open');

  const copyBtn = document.getElementById('copy-btn');
  copyBtn.textContent = 'Copy to Clipboard';
  copyBtn.classList.remove('copied');
});

document.getElementById('copy-btn').addEventListener('click', () => {
  const text = document.getElementById('modal-prompt').textContent;
  navigator.clipboard.writeText(text).then(() => {
    const btn = document.getElementById('copy-btn');
    btn.textContent = 'Copied!';
    btn.classList.add('copied');
    setTimeout(() => { btn.textContent = 'Copy to Clipboard'; btn.classList.remove('copied'); }, 2000);
  });
});

document.getElementById('close-btn').addEventListener('click', () => {
  document.getElementById('modal').classList.remove('open');
});

document.getElementById('modal').addEventListener('click', e => {
  if (e.target === document.getElementById('modal')) {
    document.getElementById('modal').classList.remove('open');
  }
});

document.addEventListener('keydown', e => {
  if (e.key === 'Escape') document.getElementById('modal').classList.remove('open');
});

render();

// Theme toggle
const themeToggle = document.getElementById('theme-toggle');
const themeIcon = document.getElementById('theme-icon');
function getTheme() {
  return localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
}
function applyTheme(t) {
  document.documentElement.setAttribute('data-theme', t);
  themeIcon.innerHTML = t === 'dark'
    ? '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>'
    : '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>';
}
applyTheme(getTheme());
themeToggle.addEventListener('click', () => {
  const next = getTheme() === 'dark' ? 'light' : 'dark';
  localStorage.setItem('theme', next);
  applyTheme(next);
});
</script>
</body>
</html>
HTMLTAIL

AGENT_COUNT=$(echo "$AGENTS_JSON" | python3 -c 'import sys,json; print(len(json.loads(sys.stdin.read())))')
echo "Generated $OUT with $AGENT_COUNT agents"

# Also copy to docs site if it exists
if [ -d "$SCRIPT_DIR/docs/public" ]; then
  cp "$OUT" "$SCRIPT_DIR/docs/public/browser.html"
  echo "Copied to docs/public/browser.html"
fi
