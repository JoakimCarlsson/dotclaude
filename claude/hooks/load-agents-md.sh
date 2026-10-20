#!/usr/bin/env bash
# SessionStart hook: inject AGENTS.md files (cwd and ancestors) into context.
set -uo pipefail

input=$(cat)
cwd=$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -z "$cwd" ] && cwd=$PWD
[ -d "$cwd" ] || exit 0

stop=$(cd "$cwd" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)
[ -z "$stop" ] && stop=$cwd

files=()
dir=$cwd
while :; do
  for name in "$dir/AGENTS.md" "$dir/.claude/AGENTS.md"; do
    [ -f "$name" ] && files+=("$name")
  done
  [ "$dir" = "$stop" ] && break
  parent=$(dirname "$dir")
  [ "$parent" = "$dir" ] && break
  dir=$parent
done

[ ${#files[@]} -eq 0 ] && exit 0

for f in "${files[@]}"; do
  printf 'Contents of %s (project instructions, checked into the codebase):\n\n' "$f"
  cat "$f"
  printf '\n\n'
done
