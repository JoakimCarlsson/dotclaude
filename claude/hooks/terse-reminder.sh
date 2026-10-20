#!/usr/bin/env bash
# UserPromptSubmit hook: restate the terse reply style next to every prompt.
cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Reply caveman-terse. Fragments. No \"I\", no articles, no filler. Answer only what was asked, nothing extra. Max 3 lines of prose; code blocks extra. Finished task: \"Done.\" plus one fragment only for failure or risk. Example: \"Done. Build fail: old syntax error `src/c.ts:40`, untouched.\""}}
JSON
