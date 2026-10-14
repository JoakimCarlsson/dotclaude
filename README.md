# dotclaude

My custom Claude Code, Codex, and Grok configuration.

## Contents

| Path | What it is |
| --- | --- |
| `claude/` | Global Claude Code instructions, settings, hooks, agents, and skills |
| `codex/AGENTS.md` | Global Codex instructions applied to every repository |
| `codex/skills/` | Global Codex skills for Git, GitHub tasks, pull requests, and writing |
| `grok/` | Global Grok instructions, hooks, agents, and skills |

## Skills

All three configurations include the same skills:

| Skill | What it does |
| --- | --- |
| `commit` | Commit the session's changes without pushing |
| `push` | Push the current branch |
| `commit-and-push` | Commit the session's changes and push |
| `task` | Create a task branch from the starting branch and implement a GitHub issue |
| `task-write` | Create and edit GitHub issues and labels |
| `create-pr` | Open a pull request to the default branch |
| `create-pr-draft` | Open a draft pull request to the default branch |
| `write` | Write text in my voice |

Invoke skills with `/skill-name` in Claude Code and Grok, or `$skill-name` in Codex.

## Install

The session hooks require Bash, Git, and `jq`. GitHub workflows use the authenticated `gh` CLI.

```sh
git clone git@github.com:JoakimCarlsson/dotclaude.git
cd dotclaude

mkdir -p ~/.claude ~/.codex/skills ~/.grok/skills ~/.grok/agents ~/.grok/hooks
cp -R claude/. ~/.claude/
cp codex/AGENTS.md ~/.codex/AGENTS.md
cp -R codex/skills/. ~/.codex/skills/
cp grok/AGENTS.md ~/.grok/AGENTS.md
cp grok/agents/code-reviewer.md ~/.grok/agents/
cp grok/hooks/load-agents-md.sh grok/hooks/hooks.json ~/.grok/hooks/
cp -R grok/skills/. ~/.grok/skills/
```

Back up existing configuration first because installation overwrites files with matching names. The Claude hook path in `claude/settings.json` is absolute and must match the user's home directory. The Grok hook uses `$HOME`.

## Project instructions

Keep project instructions in `AGENTS.md`. The Claude and Grok session hooks load instruction files from the working directory up to the repository root. Both read `AGENTS.md` and `.claude/AGENTS.md`; Grok also reads `.grok/AGENTS.md`.

## Deliberately not tracked

- Claude permission allowlists and `settings.local.json`, because they can contain machine-specific commands and secrets.
- Plugin-synced or system-provided skills.
- Codex's machine-specific `config.toml`, sessions, caches, and bundled skills.
