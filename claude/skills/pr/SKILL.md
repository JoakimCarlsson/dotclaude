---
name: pr
description: Open a pull request from the current branch to the default branch, with a Why / Changes / Verification body. Use when the user asks to open, create, or raise a PR, or invokes /pr.
disable-model-invocation: false
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

Three level-2 headings, in this order, and nothing else. No preamble, no closing line, no
extra sections, no checklists.

```markdown
## Why

## Changes

## Verification
```

- **Why** — the reason the change exists. One or two sentences. The problem or the request, not a retelling of the diff.
- **Changes** — one bullet per meaningful change, each naming the file or area it touches. Skip mechanical noise (formatting, imports, generated files).
- **Verification** — how it was checked: the build, lint or test command that was run and its result, or the manual steps taken. If it was not verified, say so in one line.

Write plainly. No justification of decisions, no background, no alternatives considered, no
notes on what was deliberately left out unless it blocks the reviewer.

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
