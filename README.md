# claude-dev-setup

Automatically scaffolds a local `.claude/` directory into every repo you
clone or create, giving each project a ready-made Claude Code context file,
settings, and custom commands -- all gitignored so nothing is committed.

---

## What this sets up

Every time you `git clone` or `git init` a repo inside `CLAUDE_REPOS_ROOT`
(default: `~/GitHub/`), a `.claude/` directory is created automatically:

```
.claude/
|-- .gitignore        <- ignores all contents (stays local, never committed)
|-- CLAUDE.md         <- project context loaded by Claude Code
|-- settings.json     <- hooks and permissions for Claude Code
|-- agents.md         <- agent workflow definitions
|-- documents/        <- artifacts created during Claude sessions
\-- commands/
    \-- onboard.md    <- /onboard slash command
```

The `.claude/` directory is intentionally **not committed**. The
`.gitignore` inside it matches `*`, so git ignores all contents. This
keeps project-level Claude context local to each developer.

---

## How it works

### `git clone` -- via git template hook

`~/.git-templates/hooks/post-checkout` is copied into every new repo's
`.git/hooks/` by git (controlled by `init.templateDir`). After a clone
completes, git fires the `post-checkout` hook, which calls
`claude-scaffold`.

### `git init` -- via shell wrapper

`post-checkout` does not fire on `git init` (no checkout happens). A
`git()` wrapper function in `~/.bashrc` intercepts `git init` calls
inside `CLAUDE_REPOS_ROOT` and calls `claude-scaffold` after.

### `claude-scaffold` -- the script

`~/.local/bin/claude-scaffold` does the actual work. It is idempotent --
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
| `setup.sh` | Idempotent installer -- run on a fresh machine |

---

## Fresh machine setup

```bash
git clone git@github.com:TheShanachie/claude-dev-setup.git ~/GitHub/claude-dev-setup
cd ~/GitHub/claude-dev-setup
./setup.sh
```

Then manually append `bashrc-additions.sh` to `~/.bashrc` and reload:

```bash
cat bashrc-additions.sh >> ~/.bashrc
source ~/.bashrc
```

---

## Configuration

By default the scaffold only fires for repos inside `~/GitHub/`. To use a
different root directory, export `CLAUDE_REPOS_ROOT` in your `~/.bashrc`
**before** the `git()` wrapper block:

```bash
export CLAUDE_REPOS_ROOT="$HOME/projects"
```

You can also run `claude-scaffold` manually on any existing repo at any time:

```bash
claude-scaffold              # uses current git repo
claude-scaffold /path/to/repo
```
