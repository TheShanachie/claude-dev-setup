# claude-dev-setup

Machine setup reference for `bengr`. Contains scripts and configuration
for automatically scaffolding `.claude/` directories in every repo under
`~/GitHub/`.

---

## What this sets up

Every time you `git clone` or `git init` a repo inside `~/GitHub/`, a
`.claude/` directory is created automatically:

```
.claude/
├── .gitignore        ← ignores all contents (stays local, never committed)
├── CLAUDE.md         ← project context loaded by Claude Code
├── settings.json     ← hooks and permissions for Claude Code
├── agents.md         ← agent workflow definitions
├── documents/        ← artifacts created during Claude sessions
└── commands/
    └── onboard.md    ← /onboard slash command
```

The `.claude/` directory is intentionally **not committed**. The
`.gitignore` inside it matches `*`, so git ignores all contents. This
keeps project-level Claude context local to each developer.

---

## How it works

### `git clone` — via git template hook

`~/.git-templates/hooks/post-checkout` is copied into every new repo's
`.git/hooks/` by git (controlled by `init.templateDir`). After a clone
completes, git fires the `post-checkout` hook, which calls
`claude-scaffold`.

### `git init` — via shell wrapper

`post-checkout` does not fire on `git init` (no checkout happens). A
`git()` wrapper function in `~/.bashrc` intercepts `git init` calls
inside `~/GitHub/` and calls `claude-scaffold` after.

### `claude-scaffold` — the script

`~/.local/bin/claude-scaffold` does the actual work. It is idempotent —
if `.claude/` already exists it exits without touching anything. You can
also call it manually on any existing repo:

```bash
claude-scaffold              # runs in current repo
claude-scaffold /path/to/repo
```

---

## Files in this repo

| File | Purpose |
|---|---|
| `bin/claude-scaffold` | The scaffold script (source of truth) |
| `git-templates/hooks/post-checkout` | The git hook (source of truth) |
| `bashrc-additions.sh` | The `git()` wrapper to paste into `~/.bashrc` |
| `setup.sh` | Idempotent installer — run on a fresh machine |

---

## Fresh machine setup

```bash
git clone https://github.com/TheShanachie/claude-dev-setup.git ~/GitHub/claude-dev-setup
cd ~/GitHub/claude-dev-setup
./setup.sh
```

Then manually append `bashrc-additions.sh` to `~/.bashrc` and reload:

```bash
cat bashrc-additions.sh >> ~/.bashrc
source ~/.bashrc
```

---

## What was configured on this machine (2026-05-01)

| Setting | Value |
|---|---|
| `git config --global init.templateDir` | `~/.git-templates` |
| `~/.local/bin/claude-scaffold` | installed + executable |
| `~/.git-templates/hooks/post-checkout` | installed + executable |
| `~/.bashrc` | `git()` wrapper appended |

Repos scaffolded at setup time:
- `~/GitHub/rdk-thunder-inspect`
- `~/GitHub/claude-dev-setup` (this repo)
