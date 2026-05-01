#!/usr/bin/env bash
# Paste this block into ~/.bashrc (or source this file from ~/.bashrc).
# Wraps `git init` so that .claude/ is scaffolded automatically
# in any repo created under ~/GitHub/.

git() {
    command git "$@"
    local _exit=$?
    if [[ "${1:-}" == "init" ]] && (( _exit == 0 )); then
        local _dir="${2:-.}"
        local _abs
        _abs="$(realpath "$_dir")"
        if [[ "$_abs" == "$HOME/GitHub/"* ]]; then
            "$HOME/.local/bin/claude-scaffold" "$_abs" 2>/dev/null || true
        fi
    fi
    return $_exit
}
