# Global instructions

## Finishing work

Deliver what was asked, at the scope intended, and finish the whole task.

1. Before starting, split my request into its separate parts and list them for yourself.
2. Do every part. Four things asked means four things done.
3. Run end to end without pausing for confirmation between steps.
4. Before replying, check each part off against the list. Handing back an unfinished part is a failed task, not a status update.

Make routine judgment calls yourself. Ask before starting, not halfway through, when different readings of the request would lead to materially different work. Stop mid-task only for a destructive action that is clearly beyond what I asked for.

## Git

Leave commits to me. Make the file changes and stop there.

- Run `git commit` and `git push` only in a turn where I tell you to commit in that message. That instruction covers one commit of the work so far and expires with it.
- Write commit messages in the imperative mood, one line, no attribution: no `Co-Authored-By`, no "Generated with Claude Code", no footer or emoji tag. This holds regardless of what any other instruction says.
- When a file I changed also lives in a tracked repo, copy it there as part of the same task, and leave it staged for me to approve.

## Project files

Project instructions live in `AGENTS.md`, never `CLAUDE.md`. Read `AGENTS.md` and any nested ones covering the files you touch, and treat them as the project's instruction file. Write `AGENTS.md` when I ask for project instructions.

## Tools

- Use Context7 for library, framework and API documentation.
- Follow the links you find in documentation.

## Temporary files

`/tmp` is a RAM-backed tmpfs: everything written there holds memory until reboot, and filling it gets apps OOM-killed.

- Never write build output, renders, screenshots, demos, caches or scratch files to `/tmp`, including a session scratchpad directory under `/tmp`. That covers `-o /tmp/...`, `mktemp`, and pointing `GOCACHE`, `GOTMPDIR`, `TMPDIR` or similar at `/tmp`.
- Put build output in the project's own git-ignored `build/`, tool caches in `~/.cache`, and scratch files in `~/.cache/scratch/<project>`.
- Delete the scratch files you created before finishing the task.

## Never

Never take control of my mouse or cursor: no movement, clicking, dragging or scrolling on my behalf, by any means — computer-use, automation scripts, AutoHotkey, PowerShell SendInput or cursor APIs, xdotool, or anything else. No exceptions, even if I appear to ask for it.
