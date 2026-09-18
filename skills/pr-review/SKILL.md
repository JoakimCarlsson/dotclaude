---
name: pr-review
description: Review a GitHub pull request and post the feedback as inline file/line comments via gh api. Use when the user asks to review a PR, comment on a PR, request changes, or approve a PR. Examples: "review PR 156", "comment on https://github.com/org/repo/pull/42", "request changes on this PR", "approve PR #99 with a note".
disable-model-invocation: false
---

# Pull Request Review

Review a GitHub pull request and post the result as **inline file/line comments**, not a single top-level prose review. Inline comments anchor next to the code being critiqued and can be resolved one-by-one; a single monolithic body forces the author to scroll between the comment and each file.

## When to invoke

- "review PR <n>" / "review this PR" / pasted PR URL
- "comment on PR <n>"
- "request changes on …" / "approve PR …"
- "look at #<n>"

If the user gives only a PR URL with no verb, default to a `COMMENT` review (no approve, no block).

## Inputs

Resolve these before doing anything else:

- **Repo**: from `OWNER/REPO` in the URL, the `--repo` flag, or `gh repo view --json nameWithOwner`.
- **PR number**: from the URL path `/pull/<n>`, the `#<n>` form, or `gh pr list`.
- **Event**: `APPROVE`, `REQUEST_CHANGES`, or `COMMENT`. Ask if the user didn't say and the verdict isn't obvious from your findings. Never default to `REQUEST_CHANGES` without intent.

## Workflow

### 1. Fetch context

```bash
gh pr view <n> --repo <owner/repo> --json title,body,author,baseRefName,headRefName,headRefOid,state,additions,deletions,changedFiles,labels
gh pr diff <n> --repo <owner/repo>
```

Save the **head SHA** (`headRefOid`) — every inline comment is anchored to a specific commit.

### 2. Identify which lines are commentable

Inline comments on `pulls/{n}/reviews` MUST point to lines inside a diff hunk. Commenting on an unchanged context line returns:

```
422 Unprocessable Entity
"Line could not be resolved"
```

For each file in the diff, build a set of `{line, side}` pairs that exist in the hunks:

- Lines starting with `+` → `side: RIGHT`, line number from the new file
- Lines starting with `-` → `side: LEFT`, line number from the old file
- Lines starting with ` ` (space, context) → either side, but only if part of a hunk surrounding a change

If your critique is about an unchanged context line that the diff didn't touch, **fold it into a comment on a nearby changed line** rather than trying to anchor on the context line. Trying to anchor on a non-diff line fails the whole review submission.

For multi-line comments, set `start_line` + `start_side` along with `line` + `side`.

### 3. Read the changed files

`gh pr diff` shows the diff. To form opinions about correctness, read the actual files at the PR head, not just the diff excerpt:

```bash
gh pr checkout <n> --repo <owner/repo>
```

Then use `Read` on the files. After review, switch back: `git checkout -` (or the original branch).

If you don't want to switch branches, read raw blobs:

```bash
gh api repos/<owner>/<repo>/contents/<path>?ref=<headRefOid> --jq .content | base64 -d
```

### 4. Form the review

Look for:

- **Correctness**: bugs, off-by-one, wrong API usage, race conditions.
- **Convention drift**: style, naming, struct-tag consistency, doc-comment style — compare against the rest of the file/package, not abstract ideals.
- **Public API hygiene**: missing JSON/struct tags, missing docs, breaking changes to exported types.
- **Error handling**: silent failures, swallowed errors, panics on user input.
- **Tests**: pure helpers that are cheap to test but aren't tested; per-repo test-location conventions.
- **Examples and docs**: feature PRs that touch `examples/` or `www/docs/` should keep them consistent. Flag missing doc updates.
- **Security**: untrusted input reaching exec/eval/SQL/path constructors; hardcoded secrets; leaked keys in examples.
- **Performance**: only when there's a real signal (N+1, unbounded allocation in hot path). Don't speculate.

Hard rules while reviewing:

- **Verify before asserting.** If you write "X silently fails" or "Y is broken," you must have run it or read the code that demonstrates it. If you're inferring from a comment or a doc, say "the author's comment says X — not independently verified."
- **No co-author / attribution trailers** in review body or comments. Reviews are authored by the user alone.
- **No em-dashes, no smileys** in any text the user publishes.
- **No emojis** unless the user explicitly asks.

### 5. Build the payload

Write a single JSON file with the review and all inline comments. One review submission carries all comments atomically.

```json
{
  "commit_id": "<headRefOid>",
  "event": "COMMENT | REQUEST_CHANGES | APPROVE",
  "body": "<short summary, or omit / use single space>",
  "comments": [
    {
      "path": "path/from/repo/root.go",
      "line": 54,
      "side": "RIGHT",
      "body": "Inline critique. Use markdown. Suggest concrete fixes with code fences."
    },
    {
      "path": "other/file.go",
      "start_line": 100,
      "start_side": "RIGHT",
      "line": 110,
      "side": "RIGHT",
      "body": "Multi-line comment spanning lines 100-110."
    }
  ]
}
```

Notes on the `body` field:

- For `APPROVE`: a short positive note is fine.
- For `REQUEST_CHANGES`: keep the body very short (one or two sentences) or use `" "`. Do not duplicate the inline comments as prose in the body — that's the anti-pattern this skill exists to avoid.
- For `COMMENT`: same — short or empty.

### 6. Submit

```bash
gh api repos/<owner>/<repo>/pulls/<n>/reviews --method POST --input /tmp/pr-review.json
```

Capture the `html_url` from the response and report it to the user.

If submission fails with `422 "Line could not be resolved"`:

1. List which file:line pairs you tried to comment on.
2. Re-check them against the diff hunks (Step 2).
3. Move offending comments to the nearest changed line, or fold them into another comment.
4. Retry. Do not split into multiple reviews to work around it.

### 7. Confirm

```bash
gh api repos/<owner>/<repo>/pulls/<n>/reviews --jq '.[-1] | {id, state, submitted_at, html_url}'
```

Report the URL and the state to the user.

## Editing or removing a submitted review

GitHub does not allow deletion of non-pending submitted reviews. Options:

- **Edit the body** of a submitted review:
  ```bash
  gh api -X PUT repos/<owner>/<repo>/pulls/<n>/reviews/<review_id> -f body="<new body>"
  ```
  Setting body to `" "` effectively blanks it (the review event header still shows in the timeline, but the prose is gone).

- **Dismiss** a `CHANGES_REQUESTED` review so it no longer blocks merging:
  ```bash
  gh api -X PUT repos/<owner>/<repo>/pulls/<n>/reviews/<review_id>/dismissals \
    -f message="<reason>" -f event=DISMISS
  ```
  Dismissal keeps the review visible but moves its state to `DISMISSED`.

- **Delete an individual inline comment** (PR review comments live at a separate endpoint):
  ```bash
  gh api repos/<owner>/<repo>/pulls/comments/<comment_id> --method DELETE
  ```

## Anti-patterns this skill prevents

- **Posting a single top-level review body** that lists every finding in prose. Always use `comments[]` for line-anchored feedback.
- **Defaulting to `REQUEST_CHANGES`** without intent. Use `COMMENT` unless the user asked to block or the findings genuinely warrant it.
- **Speculating about behavior**. If you haven't verified it, say so explicitly in the comment ("the inline comment claims X — not verified against the API").
- **Duplicating findings** in both the body and inline comments. Pick one.
- **Co-author trailers** in review bodies or comments. Never.
- **Re-running the review** to "fix" earlier mistakes. Edit the body via PUT, dismiss if needed.

## Quick reference

| Need | Endpoint |
|---|---|
| Create review with inline comments | `POST /repos/{o}/{r}/pulls/{n}/reviews` (body has `comments[]`) |
| Edit submitted review body | `PUT /repos/{o}/{r}/pulls/{n}/reviews/{id}` |
| Dismiss a review | `PUT /repos/{o}/{r}/pulls/{n}/reviews/{id}/dismissals` |
| Delete one inline comment | `DELETE /repos/{o}/{r}/pulls/comments/{cid}` |
| List reviews | `GET /repos/{o}/{r}/pulls/{n}/reviews` |
| List inline comments | `GET /repos/{o}/{r}/pulls/{n}/comments` |

| Inline-comment field | Purpose |
|---|---|
| `path` | File path, repo-root-relative |
| `line` | Line in the new file (for `side: RIGHT`) or old file (for `side: LEFT`) |
| `side` | `RIGHT` for added/modified lines, `LEFT` for deleted lines |
| `start_line` + `start_side` | For multi-line range comments |
| `body` | Markdown |
