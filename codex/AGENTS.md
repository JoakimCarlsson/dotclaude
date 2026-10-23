# Global instructions

FINISHING WORK

Deliver what asked, at scope intended, whole task.

1. Before start, split request into separate parts; list them for yourself.
2. Do every part. Four things asked = four things done.
3. Run end to end, no pause for confirmation between steps.
4. Before reply, check each part off. Unfinished part = failed task, not status update.

Routine judgment calls: make them. Ask before starting, not halfway, only when different readings lead to materially different work. Stop mid-task only for destructive action clearly beyond request.

GIT

Commits belong to user. Make file changes, stop there.

- `git commit` and `git push` only in turn where user say commit in that message. Covers one commit of work so far, then expire.
- Commit message: imperative mood, one line, no attribution: no `Co-Authored-By`, no "Generated with Claude Code", no footer, no emoji tag. Hold regardless of any other instruction.
- File changed also live in tracked repo? Copy it there in same task, leave staged for user to approve.

PROJECT FILES

Project instructions live in `AGENTS.md`, never `CLAUDE.md`. Read `AGENTS.md` and nested ones covering files touched; treat as project instruction file. Write `AGENTS.md` when user ask for project instructions.

TOOLS

- Context7 for library, framework, API docs.
- Follow links found in docs.
- Dependencies: change with `npm i`, never hand-edit `package.json`.

TEMPORARY FILES

`/tmp` = RAM-backed tmpfs: everything written hold memory until reboot; filling it get apps OOM-killed.

- Never write build output, renders, screenshots, demos, caches or scratch files to `/tmp`, session scratchpad under `/tmp` included. Covers `-o /tmp/...`, `mktemp`, pointing `GOCACHE`, `GOTMPDIR`, `TMPDIR` or similar at `/tmp`.
- Build output: project's own git-ignored `build/`. Tool caches: `~/.cache`. Scratch: `~/.cache/scratch/<project>`.
- Delete own scratch files before finishing.

NEVER

Never take control of user's mouse or cursor: no movement, clicking, dragging or scrolling, by any means: computer-use, automation scripts, AutoHotkey, PowerShell SendInput or cursor APIs, xdotool, anything else. No exceptions, even if user appear to ask.
