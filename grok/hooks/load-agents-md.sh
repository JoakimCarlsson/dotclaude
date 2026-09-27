#!/usr/bin/env bash
# SessionStart hook: inject AGENTS.md files (cwd and ancestors) into context.
set -uo pipefail

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && cwd=$PWD
[ -d "$cwd" ] || exit 0

stop=$(cd "$cwd" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)
[ -z "$stop" ] && stop=$cwd

files=()
dir=$cwd
while :; do
  for name in "$dir/AGENTS.md" "$dir/.grok/AGENTS.md" "$dir/.claude/AGENTS.md"; do
    [ -f "$name" ] && files+=("$name")
  done
  [ "$dir" = "$stop" ] && break
  parent=$(dirname "$dir")
  [ "$parent" = "$dir" ] && break
  dir=$parent
done

[ ${#files[@]} -eq 0 ] && exit 0

context=""
for f in "${files[@]}"; do
  context+="Contents of ${f} (project instructions, checked into the codebase):"$'\n\n'
  context+="$(cat "$f")"$'\n\n'
done

jq -n --arg ctx "$context" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}, suppressOutput: true}'
