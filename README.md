# dotclaude

My Claude Code configuration (`~/.claude`).

## Contents

| Path | What it is |
| --- | --- |
| `CLAUDE.md` | Global instructions applied to every project |
| `settings.json` | Hooks, enabled plugins, model settings |
| `agents/` | Custom subagent definitions |
| `hooks/` | Shell hooks invoked by Claude Code |
| `skills/` | Custom skills (`/commit`, `/github-issues-labels`) |

## Install

```sh
git clone git@github.com:JoakimCarlsson/dotclaude.git
cd dotclaude
cp -R CLAUDE.md settings.json agents hooks skills ~/.claude/
```

Back up your existing `~/.claude` first — this overwrites. The hook path in
`settings.json` is absolute; adjust it if your home directory differs.

## Deliberately not tracked

- **`permissions`** — the local allowlist accumulates raw session commands,
  which routinely embed API keys, database passwords and bearer tokens. It is
  machine-specific and never belongs in a repo. Merging this `settings.json`
  leaves your local `permissions` block untouched.
- `settings.local.json`, for the same reason.
- `skills/synced/` — plugin-synced, machine-generated.
