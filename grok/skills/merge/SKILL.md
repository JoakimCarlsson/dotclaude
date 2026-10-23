---
name: merge
description: Merge the pull request for the current branch, resolving merge conflicts first if there are any. Use when the user asks to merge the PR or invokes /merge.
---

# Merge

Merge the pull request for the branch currently checked out.

## Rules

- **Never change branches.** Stay on the current branch.
- **Never force-push, never use `--no-verify`, never bypass branch protection** (no `--admin`).
- **Merge only the PR for this branch.** Never merge another PR.
- **Resolve conflicts by merging the base branch into this branch**, never by rebasing.

## Steps

1. `git branch --show-current`. If it is the default branch, stop and say so.
2. `gh pr view --json number,url,state,baseRefName,mergeable,mergeStateStatus`. No PR: stop and say so. Already merged or closed: report and stop.
3. `git status --porcelain`. If the tree is dirty, stop and report. Do not stage, commit or stash.
4. If `mergeable` is `CONFLICTING`, resolve the conflicts:
   1. `git fetch origin`, then `git merge origin/<baseRefName>`.
   2. Read each conflicted file, fix it so both sides' intent survives, and `git add` it by path.
   3. Build and run existing tests when the project has them. Fix what the merge broke.
   4. `git commit` to conclude the merge, then push using the `commit-and-push` skill. If the merge commit is already made, just `git push`.
   5. Re-run `gh pr view` until `mergeable` is no longer `UNKNOWN`.
   6. A conflict whose right answer is unclear: stop and ask. Never guess at data loss.
5. Merge with the repository's convention. If it is unknown, use `gh pr merge --merge`. Add `--delete-branch` only when the user asked. Do not use `--auto` unless the user asked.
6. If checks are failing or pending, or review is required, report it and stop. Do not bypass.
7. Print the PR URL and the merge result.
