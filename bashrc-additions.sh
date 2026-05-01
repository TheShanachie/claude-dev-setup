#!/usr/bin/env bash
# Paste this block into ~/.bashrc (or source this file from ~/.bashrc).
# Wraps `git init` so that .claude/ is scaffolded automatically in any
# repo created under CLAUDE_REPOS_ROOT (default: ~/GitHub/).
#
# To use a different root, export CLAUDE_REPOS_ROOT before sourcing this:
#   export CLAUDE_REPOS_ROOT="$HOME/projects"

git() {
    command git "$@"
    local _exit=$?
    if [[ "${1:-}" == "init" ]] && (( _exit == 0 )); then
        local _dir="${2:-.}"
        local _abs _root
        _abs="$(realpath "$_dir")"
        _root="${CLAUDE_REPOS_ROOT:-$HOME/GitHub}"
        if [[ "$_abs" == "$_root/"* ]]; then
            "$HOME/.local/bin/claude-scaffold" "$_abs" 2>/dev/null || true
        fi
    fi
    return $_exit
}
