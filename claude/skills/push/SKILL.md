---
name: push
description: Push the current branch to the remote. Use when the user asks to push or invokes /push.
disable-model-invocation: false
---

# Push

Push the current branch's commits to the remote. Do not commit.

## Rules

- **Never change branches.** Push whatever branch is currently checked out.
- **Never force-push.** No `--force` or `--force-with-lease`.
- **Never commit or stage anything.** Pushing only.
- **Push to the current branch's upstream.** If there is no upstream, set it to the same branch name on `origin` with `git push -u origin <branch>`.

## Steps

1. Run `git branch --show-current` and `git status -sb` to confirm the branch and what is unpushed.
2. Push to the upstream, or set it if missing.

## If something blocks the push

- Nothing to push: say so and stop.
- Push is rejected: report it and let the user decide.
