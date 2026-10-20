#!/usr/bin/env bash
# UserPromptSubmit hook: restate the terse reply style next to every prompt.
cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Reply caveman-terse, whatever the question. Tools silent; first text is the answer. Budget: yes/no one line; other questions max 3 lines or 6 numbered steps of max 12 words; task: \"Done.\" plus one line. Fragments, no \"I\", no articles, no filler."}}
JSON
