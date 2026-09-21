---
name: issue
description: Start work on a GitHub issue — check out a task/ISSUENUMBER-slugified-title branch and implement the issue. Use when the user links or names a GitHub issue, or invokes /issue.
---

# Issue

Given a GitHub issue (URL or number), branch for it and implement it.

## Input

- Full URL: `https://github.com/OWNER/REPO/issues/NUMBER`
- Bare number (`176` or `#176`): use the repo of the current working directory.

If neither is given, ask for the issue.

## Part 1 — Branch

1. Fetch the issue:
   - URL: `gh issue view NUMBER --repo OWNER/REPO --json number,title,body,labels,state,comments`
   - Bare number: `gh issue view NUMBER --json number,title,body,labels,state,comments`
2. Build the branch name: `task/<number>-<slug>` where `<slug>` is the title:
   - lowercased
   - non-alphanumeric runs replaced by a single `-`
   - leading/trailing `-` stripped
   - truncated to 60 characters at a `-` boundary
3. Make sure the working tree is clean (`git status --porcelain`). If it is not, stop and report — do not stash or discard.
4. `git fetch origin`, then branch off the default branch's remote head, not the local checkout:
   `git checkout -b task/<number>-<slug> origin/<default>`
   - If the branch already exists locally, check it out instead of recreating it.
   - If it exists on the remote, check out a tracking branch.
   - Never force-create (`git checkout -B`) over an existing branch.

Report the branch name before moving on.

## Part 2 — Implement

5. Read the issue body **and its comments** in full; follow any links in them. Treat later comments as refinements of the original body.
6. Read the repo's `AGENTS.md` files (root and any nested ones covering the files you touch) and follow them.
7. Explore the relevant code before editing. Match the surrounding style, naming, and structure.
8. Implement the issue completely — every point it asks for. If part of it is blocked or ambiguous in a way that changes the outcome, do the rest and say explicitly what you left out and why.
9. Build the project to verify it compiles. If there is a lint or type-check step, run it too. Fix what you broke.
10. Summarize: the branch, what changed and where, how it was verified, and anything left open.

## Rules

- **Scope is the issue.** Do not refactor unrelated code or fix unrelated bugs you notice — mention them instead.
- **Do not write tests** unless the issue explicitly asks for them.
- **Do not commit or push.** Leave the changes in the working tree and tell the user to run `/commit` when they're happy.
- Do not open a pull request.

## Example

```
/issue https://github.com/JoakimCarlsson/wasa-cli/issues/176
```

Issue #176 titled "Add `--json` output to `wasa status`" becomes branch:

```
task/176-add-json-output-to-wasa-status
```

then the change is implemented on that branch.
