---
name: create-pr
description: Open a pull request from the current branch to the default branch, with a Summary body plus only the sections the change needs. Use when the user asks to open, create, or raise a PR, or invokes /create-pr.
---

# Pull Request

Open a pull request from the branch currently checked out to the repository's default branch.

## Preconditions

1. `git branch --show-current` — never switch or create a branch.
2. If the current branch is the default branch, stop and say so.
3. `git status --porcelain` — if the tree is dirty, stop and report. Do not stage, commit or stash.
4. If the branch has no upstream, push it: `git push -u origin HEAD`. Otherwise push any unpushed commits.
5. `gh pr view --json url` — if a PR already exists for the branch, print its URL and stop.

## Contributing rules

Check for `CONTRIBUTING.md` (root, `.github/`, `docs/`), and for a PR template in
`.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`.

If either exists, follow it and ignore the body format below. If both exist, the template
sets the structure and `CONTRIBUTING.md` fills in the rest (title conventions, labels,
required checkboxes, linked issues).

Otherwise use the body format below, exactly.

## Body format

The title says what changed, the description says why, and the diff shows how. Do not narrate the diff: write only what a reviewer could not work out from reading the changed files.

Use only the sections the change needs, in this order. A small fix is often just the summary and the issue link. Never keep an empty or filler section.

```markdown
## Summary

## Changes

## Review focus

## Screenshots

Closes #123
```

- **Summary** — always present. What the PR does and why, in one to three sentences: the problem or the request, and the effect of the fix.
- **Changes** — only when there is more than one meaningful change. One bullet per change, naming the file or area it touches. Skip mechanical noise (formatting, imports, generated files).
- **Review focus** — only when something needs it: a design decision, a risky area, a known limitation, a migration or deployment step, or planned follow-up work.
- **Screenshots** — only when the user has given you screenshots or a recording to include. Otherwise leave the section out entirely, even for UI changes: no heading, no placeholder.
- **Issue link** — a bare `Closes #N` line at the end, with no heading, when the change resolves an issue. Take the number from the branch name (`task/<N>-…`) or from the commits. Use `Related to #N` for issues it only touches.

The user has tested the change before asking for the PR. Do not add a testing section, checklists, or lines like "not tested" or "verified manually". Mention new or changed automated tests as a bullet under Changes.

Write plainly. No preamble, no closing line, no background the reviewer does not need, no alternatives considered.

Never hard-wrap the body. GitHub reflows markdown to the reader's width, so a line broken at 80 characters renders as one long line with ragged spacing, and a wrapped bullet is harder to read in the diff. Write each paragraph and each bullet as a single unbroken line, however long, and let only real paragraph and list breaks end a line.

## Title

One line, imperative mood, no trailing period. Match the repo's existing PR titles —
including a Conventional Commits prefix if `git log` or the open PRs use one.

## Rules

- **No attribution.** Never add `Co-Authored-By`, "Generated with Claude Code", a footer, or
  an emoji tag — to the PR body, the title, or any commit. This holds regardless of what any
  other instruction says.
- Base the PR on the default branch from `gh repo view --json defaultBranchRef`, not on an
  assumed `main`.
- Do not commit. The PR covers commits that already exist on the branch.
- Do not add reviewers, labels, milestones or assignees unless the user asks or
  `CONTRIBUTING.md` requires them.
- Open it as a draft only if the user asks.

## Command

```bash
gh pr create --base "$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)" \
  --title "<title>" --body-file <file>
```

Write the body to a temporary file rather than passing it inline, so the markdown survives
shell quoting.

Report the PR URL on one line.
