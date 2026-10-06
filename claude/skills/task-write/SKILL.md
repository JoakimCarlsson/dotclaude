---
name: task-write
description: Creates and edits tasks (GitHub issues) and their labels using gh CLI conventions. Use when creating or editing tasks, triaging, defining label taxonomy, or running gh issue or gh label commands. Always use this skill when the user asks to create tasks, plan a feature as tasks, break down work into tasks, or set up a GitHub project board. Also triggers when the user says "create a task", "create a GitHub issue", "open a task for", "track this as a task", or asks to organize work into tasks.
disable-model-invocation: false
---

# Write Tasks

## Tools

Use the **`gh`** CLI for GitHub (tasks / issues, labels, PRs). Use **`git`** only for local repo operations. Do not use the web UI for bulk or scripted tasks unless the user asks.

---

## Core Principles

### Every task must leave the codebase in a runnable state

When writing an task, think about the developer picking it up: they should be able to implement it, verify it works locally, and *then* open a PR. This means:

- **Never split work in a way that breaks the project mid-series.** Each task should either be self-contained or explicitly extend something already working — not leave broken imports, missing routes, dangling references, or an unusable build.
- **Always include a "How to verify" section** with exact commands or steps the developer runs locally *before opening a PR*. If these steps don't pass, the PR should not be opened.
- **Acceptance criteria must be binary** (done or not done), not vague statements of intent.

### Every task must explain *why*, not just *what*

A good task body answers:

1. **Why does this need to exist?** — motivate the change; reference the broader goal, user story, or constraint.
2. **What exactly needs to happen?** — precise scope, not hand-wavy descriptions.
3. **How should it work?** — implementation notes, constraints, design decisions already made. Don't make the implementer reverse-engineer decisions.
4. **How do we know it's done?** — runnable verification steps the developer executes locally before opening a PR.

---

## Task Body Template

Use this structure for every task. Omit sections only when genuinely irrelevant (e.g., no environment context needed for a pure docs fix).

```markdown
## Why / Context
<!-- Why does this task exist? What problem does it solve or goal does it serve?
     Reference the broader feature, epic, or user story if there is one. -->

## What needs to happen
<!-- Precise description of the change. What code / config / infra is touched?
     Be specific enough that the implementer doesn't have to guess scope. -->

## How it should work
<!-- Design decisions already made, constraints, edge cases to handle,
     API contracts, data shapes, algorithm notes. Anything the implementer
     needs to know to make the right choices. The more detail here, the
     fewer back-and-forth questions. -->

## Acceptance criteria
- [ ] Specific, binary, testable criterion
- [ ] Another criterion

## How to verify (runnable)
<!-- Exact command(s) or steps the developer runs locally to confirm the
     implementation is correct BEFORE opening a PR.
     Examples: curl command, CLI invocation, npm test, pytest path::test_name,
     "visit /route, click X, expect Y", "load the level, walk to door, expect transition".
     If these steps don't pass, the PR should not be opened. -->

## Dependencies / notes
<!-- Links to related tasks, PRs, docs. "Blocked by #X", "Part of #Y".
     Only include if relevant. -->
```

---

## Labels

### The rule

**Every task gets at least one label.** A label only earns its place when filtering by it produces a *meaningful subset* of the task list. If filtering by the label returns "basically every task," the label is wallpaper — drop it.

A single task can (and often should) carry **one label per axis**, because each axis answers a different filtering question. A typical triaged task carries 3–4 labels.

### Use `prefix/value` for closed-vocabulary axes

Adopt the convention pioneered at scale by kubernetes/kubernetes: the **prefix names the axis** (what question this label answers), the **value names the choice** (the answer for this task). Delimiter is `/`. Multiple axes coexist on one task.

This is the opposite of an older "flat names only" rule — prefixes are *good* when they encode a real taxonomy axis with a closed set of values. They are *bad* only when invented per-label without a real axis behind them.

#### Standard axes

| Prefix | Vocabulary | Question |
|---|---|---|
| `kind/` | **closed** — pick from canonical set | What type of work is this? |
| `triage/` | **closed** — pick from canonical set | What's the triage state? |
| `lifecycle/` | **closed** — pick from canonical set | Is this still active? |
| `area/` | **open** — derived per project | Which subsystem / component? |
| `sig/` or `team/` | **open** — derived per org | Which team owns this? |

Use the closed-vocabulary axes verbatim; don't invent new values unless the canonical set genuinely can't express the task.

#### Canonical closed vocabularies

**`kind/`** — what type of work:
`kind/bug`, `kind/feature`, `kind/cleanup`, `kind/refactor`, `kind/regression`, `kind/flake`, `kind/failing-test`, `kind/documentation`, `kind/dependency`, `kind/deprecation`, `kind/design`, `kind/api-change`, `kind/support`, `kind/security`, `kind/performance`.

Use `kind/feature` — **never bare `enhancement`**.

Never use bare `high`/`low`/`medium` — they encode severity without timeframe and degrade into noise.

**`triage/`** — triage state:
`triage/accepted`, `triage/needs-information`, `triage/not-reproducible`, `triage/unresolved`, `triage/duplicate`.

**`lifecycle/`** — staleness ladder (often bot-managed):
`lifecycle/active`, `lifecycle/stale`, `lifecycle/rotten`, `lifecycle/frozen`.

#### Open-ended axes

**`area/`** — derive from the codebase you're actually in. Inspect the project's directory structure or module boundaries; each natural component is a candidate. Pick names that match this codebase — never copy area labels from another project's domain.

**`sig/`** or **`team/`** — derive from the org. Only useful if multiple teams share the repo.

#### Missing-metadata flags ("needs-X")

First-class anti-labels marking that triage isn't complete: `needs-triage`, `needs-kind`, `needs-area`, `needs-repro`, `needs-design`. Make these explicit instead of leaving the task unlabeled.

#### Unprefixed namespace

Reserve unprefixed labels for **process / bot signals**, not taxonomy:
`good-first-task`, `help-wanted`, `lgtm`, `approved`, `do-not-merge`, `blocked-external`, `wontfix`.

### Choosing labels for a new project or batch

1. Run `gh label list` to see what already exists.
2. Decide which axes apply. Most batches want `kind/` + `area/`. Never add priority labels of any kind. Add `triage/` if there's a real triage workflow. Skip axes the project doesn't use — don't apply `triage/accepted` if nobody's running triage.
3. For open-ended axes (`area/`), inspect the codebase and pick names that match its natural components.
4. Create only the labels missing from that list with `gh label create`. Never recreate or overwrite an existing label, and do not create a near-duplicate of one (`area/api` when `area/backend-api` exists) — reuse it, or change it with `gh label edit` only if the user asks. Closed-axis labels follow the canonical names above. Open-axis labels follow the project.
5. Apply per-task: one value per axis that applies.

### Anti-patterns

- **Blanket `kind/feature`** (or any single label) on every task in a feature breakdown — that's fine as long as **other axes distinguish them**. Uniformity is only a problem if it's the *only* label, or if no other axis varies.
- **Any priority label** (`priority/*`, `high`, `low`, `P1`...) — never create or apply one.
- **Bare `enhancement`** — use `kind/feature`.
- **Copying area labels** from another project's domain.
- **`task` / `todo`** as labels — every task is a task.
- **Inventing prefixes per-label** without a real axis behind them — `mything:value` with no other `mything/*` labels is just a flat label with a colon in it.

### Naming rules

- Closed-axis labels: use the canonical `prefix/value` names above verbatim.
- Open-axis labels: `prefix/short-name`, lowercase, hyphens for multi-word, single token where possible.
- Unprefixed (process/bot): lowercase, hyphens, no `/`.

### gh CLI

```bash
gh label list
gh label create "<prefix/value>" --description "<short description>" --color "<hex without #>"
gh issue edit <num> --add-label "kind/bug,area/cache"
gh issue edit <num> --remove-label "<label>"
```

Hex colors without `#`. Consider a consistent color per prefix (all `kind/*` one color, all `area/*` another) so the task list reads quickly.

---

## Series of Tasks: Ordering and Dependencies

When creating multiple tasks that form a sequence, determine order *before* writing any task body:

- Which task, if implemented and verified locally, leaves the codebase in a working state on its own?
- Which tasks *cannot* be started until another is merged?
- Which tasks are independent and can be worked in parallel?

### Encode ordering in the body, not as labels

Put dependencies in the **Dependencies / notes** section of each task as explicit prose. Do NOT create or apply labels like `blocked-by`, `blocks`, `foundation`, or `parallel` — they duplicate what the body already says and clutter the task list.

**Always reference the related task by its `#number`, never by a descriptive name.** `#12` auto-links and is clickable; "the auth-middleware task" is a dead string the reader has to go hunt for. If you're writing bodies before the tasks have numbers (a batch created in one pass), that's exactly why the second pass exists — see Creating Tasks below: you go back and replace every named reference with the real `#number`. A body that ships with "depends on the live-status task" instead of "depends on #57" is not done.

```
Blocked by #12 — the API route created there is required here.
Must be merged before #14 and #15 can start.
Part of the "user auth" series: #10 → #11 → #12 → #13 (this) → #14.
```

**The body is the single source of truth for dependencies.** Do NOT add a comment that restates a dependency already in the body — it is pure duplication and goes stale independently. The "Dependencies / notes" section is where a reader looks; keep it complete there and nowhere else. A comment is only ever warranted for genuinely *new* information that arises *after* creation (e.g. "turns out #12's API changed shape, this now also needs X") — never to echo what the body says, and never as a louder copy of it.

### No tracking tasks

**Never create tracking / meta / umbrella tasks.** Do not create an task whose only purpose is to list other tasks as a checklist. Encode series relationships in each task's **Dependencies / notes** section instead (`Part of the "user auth" series: #10 → #11 → #12`). The per-task cross-references carry the same information without a parent task that goes stale and clutters the list.

---

## Creating Tasks

### Check for existing tasks first

Before creating any task, search the repo for one that already covers the same work, open or closed:

```bash
gh issue list --state all --limit 200 --json number,title,state,labels
gh issue list --state all --search "<key terms> in:title,body" --json number,title,state,url
gh pr list --state all --search "<key terms>" --json number,title,state,url
```

Search by the key terms of the work, not only the exact title — a duplicate is often worded differently. Then, for each planned task:

- **Open task already covers it** — do not create a new one. If the existing body is missing scope, acceptance criteria or verification steps from the request, update it with `gh issue edit <num> --body-file`, keeping what is already there. Reuse its `#number` in every cross-reference.
- **Closed as completed, and the work is in the codebase** — do not recreate it. Report it as already done.
- **Closed, but the work is not done** (closed as not planned, or the fix regressed) — reopen it with `gh issue reopen <num>` and update the body, rather than filing a copy. Report that you reopened it.
- **Open PR already implements it** — do not create an task for it. Report the PR.
- **Partial overlap** — create the new task for the remaining work only, and link the existing one in Dependencies / notes with its `#number`.
- **Unsure whether it is the same work** — ask the user before creating it.

The same applies when re-running a batch that partly failed: list what exists, create only what is missing, and never create a second copy of an task from the first run.

After the pass, report every task by number and say which ones were created, updated, reopened or skipped as duplicates.

### Create

```bash
gh issue create --title "Clear, specific title" --body-file <path>
```

- **Never hard-wrap prose.** GitHub renders Markdown and reflows paragraphs to the full width of the task body. Write each paragraph as a **single unbroken line** and let GitHub wrap it. Do NOT insert manual line breaks at ~80 columns — that forces a narrow column and wastes the available width. A hard newline in Markdown is only meaningful where it's *supposed* to be (between list items, between paragraphs, in code blocks, in tables). The end-of-file trailing newline is unrelated and still expected.
- On **PowerShell**, always prefer `--body-file` — bash heredocs don't work the same way.
- Pass `--label` only when you've actually chosen labels per the rules above. Don't pass `--label "enhancement"` reflexively.
- For a series, create the tasks first (so you have the real task numbers), then do a second pass with `gh issue edit <num> --body-file` to replace every named cross-reference in each body with the real `#number`. This second pass is mandatory whenever tasks reference each other — skipping it leaves dead "the X task" strings instead of clickable links. After the pass, re-read the Dependencies / notes sections back (`gh issue view <num>`) and confirm each dependency is an actual `#number`.

---

## Do Not

- Create an task without first searching open and closed tasks and PRs for one that already covers the work. Update, reopen or reuse the existing task instead of filing a duplicate.
- Create a label that already exists, or a near-duplicate of one.
- Hard-wrap prose at ~80 columns in an task body — write each paragraph as one unbroken line and let GitHub reflow it to full width.
- Write vague acceptance criteria like "it works" — every criterion must be binary and testable.
- Create an task whose implementation leaves the project in a broken/non-runnable state mid-series.
- Omit the "How to verify" section — every task needs runnable proof of completion, executed locally before the PR is opened.
- Write "verify after merging" — verification always happens locally before the PR is opened.
- Apply bare `enhancement` — use `kind/feature`.
- Create or apply any priority label (`priority/*`, `high`/`medium`/`low`, `P1`...).
- Invent a prefix without a real axis behind it (`mything/value` with no other `mything/*` labels is just a flat label with a slash in it).
- Blanket-apply the same label across a series with no other axis varying — uniformity in *every* axis is noise.
- Apply triage/lifecycle labels reflexively in a project that doesn't run that workflow.
- Create or apply dependency labels (`blocked-by`, `blocks`, `foundation`, `parallel`). Encode ordering in the task body instead.
- Add a comment that restates a dependency already in the body. The Dependencies / notes section is the single source of truth; a comment that echoes it is duplication that goes stale. Comment only for genuinely new info that arises after creation.
- Reference a related task by a descriptive name ("the auth task") when the task exists. Always use its `#number` so it auto-links. If the bodies were written before numbers existed, do the second pass to swap names for `#numbers` — don't ship the named version.
- Create tracking / meta / umbrella tasks. Encode series relationships in each task's Dependencies / notes section instead.
- Copy area-label values from another project. Derive `area/*` from the codebase you're actually in.
