#!/usr/bin/env bash
# Idempotent setup script — run this on a fresh machine to reproduce the
# full claude-scaffold git template configuration.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing claude-scaffold to ~/.local/bin/"
mkdir -p "$HOME/.local/bin"
cp "$REPO_DIR/bin/claude-scaffold" "$HOME/.local/bin/claude-scaffold"
chmod +x "$HOME/.local/bin/claude-scaffold"

echo "==> Installing git template hook to ~/.git-templates/"
mkdir -p "$HOME/.git-templates/hooks"
cp "$REPO_DIR/git-templates/hooks/post-checkout" "$HOME/.git-templates/hooks/post-checkout"
chmod +x "$HOME/.git-templates/hooks/post-checkout"

echo "==> Configuring git to use ~/.git-templates/"
git config --global init.templateDir "$HOME/.git-templates"

echo ""
echo "Done. One manual step remaining:"
echo "  Add the git() wrapper from bashrc-additions.sh to your ~/.bashrc,"
echo "  then run: source ~/.bashrc"
echo ""
echo "After that, every 'git clone' or 'git init' inside ~/GitHub/ will"
echo "automatically create a .claude/ scaffold."
