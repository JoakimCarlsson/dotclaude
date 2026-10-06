---
name: commit-and-push
description: Commit and push the changes made in this session on the current branch. Use when the user asks to commit, push, or invokes /commit-and-push.
---

# Commit

Commit the changes made during this session and push them to the remote.

## Rules

- **Never change branches.** Commit on whatever branch is currently checked out. Do not `git checkout`, `git switch`, or create a new branch — not even if the current branch is `main`/`master`.
- **Only stage what was touched in this session.** Stage those paths explicitly by name. Never use `git add -A`, `git add .`, or `git commit -a`.
- **Keep the message short.** One or two sentences, maximum. No bullet lists, no body paragraphs, no novel.
- **No attribution lines.** Never add `Co-Authored-By`, `Generated with Claude Code`, or any similar trailer, footer, or emoji tag.
- **Push after committing**, to the current branch's upstream. If there is no upstream, set it to the same branch name on `origin`.

## Steps

1. Run `git status` and `git diff` to confirm what changed, and `git branch --show-current` to confirm the branch.
2. Stage only the files changed in this session, by path.
3. Check the staged diff with `git diff --cached` before writing the message.
4. Commit with a short message describing what changed and why.
5. Push to the current branch.

## Message format

A single line in the imperative mood, optionally followed by one sentence of context.

```
Add rate limiting to the auth endpoints

Limits are per-IP and configured through AUTH_RATE_LIMIT.
```

## If something blocks the commit

- Pre-commit hooks fail: report the failure and let the user decide. Never use `--no-verify`.
- Nothing to commit: say so and stop.
- Push is rejected: report it. Never force-push.
