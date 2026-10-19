# dotclaude

My custom Claude Code, Codex, and Grok configuration.

## Contents

| Path | What it is |
| --- | --- |
| `claude/` | Global Claude Code instructions, rules, settings, hooks, agents, and skills |
| `codex/AGENTS.md` | Global Codex instructions applied to every repository |
| `codex/skills/` | Global Codex skills for Git, GitHub tasks, pull requests, and writing |
| `grok/` | Global Grok instructions, rules, hooks, agents, and skills |

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

These steps are written for an AI agent to follow. Run them from a clone of this repository:

```sh
git clone git@github.com:JoakimCarlsson/dotclaude.git
cd dotclaude
```

The session hooks require Bash, Git, and `jq`. GitHub workflows use the authenticated `gh` CLI.

### Global install

Global files apply to every repository for the current user.

1. Back up what exists. Installation overwrites files with matching names: `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.codex/AGENTS.md`, `~/.grok/AGENTS.md`.
2. Copy the files:

```sh
mkdir -p ~/.claude ~/.codex/skills ~/.grok/rules ~/.grok/skills ~/.grok/agents ~/.grok/hooks
cp -R claude/. ~/.claude/
cp codex/AGENTS.md ~/.codex/AGENTS.md
cp -R codex/skills/. ~/.codex/skills/
cp grok/AGENTS.md ~/.grok/AGENTS.md
cp -R grok/rules/. ~/.grok/rules/
cp grok/agents/code-reviewer.md ~/.grok/agents/
cp grok/hooks/load-agents-md.sh grok/hooks/hooks.json ~/.grok/hooks/
cp -R grok/skills/. ~/.grok/skills/
```

3. In `~/.claude/settings.json`, set the `SessionStart` hook command to the absolute path of `~/.claude/hooks/load-agents-md.sh` for the current user. The Grok hook already uses `$HOME`.
4. Make the hook scripts executable: `chmod +x ~/.claude/hooks/*.sh ~/.grok/hooks/*.sh`.
5. Start a new session in each tool and confirm it loaded the instructions. In Grok, `grok inspect` lists the rules, skills, and hooks it found.

What lands where:

| Tool | Instructions | Rules | Skills |
| --- | --- | --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/rules/` | `~/.claude/skills/` |
| Codex | `~/.codex/AGENTS.md` (rules are inside it) | none | `~/.codex/skills/` |
| Grok | `~/.grok/AGENTS.md` | `~/.grok/rules/` | `~/.grok/skills/` |

### Local install

Local files apply to one repository only. Run these from the root of the target repository, with `DOTCLAUDE` set to the path of the clone.

1. Rules and instructions, committed with the project:

```sh
mkdir -p .claude/rules .grok/rules
cp "$DOTCLAUDE/claude/rules/lean.md" .claude/rules/
cp "$DOTCLAUDE/grok/rules/lean.md" .grok/rules/
```

2. Codex has no rules folder. Append the "Lean code" section from `codex/AGENTS.md` to the repository's `AGENTS.md`, creating the file if it is missing. Do not overwrite an existing `AGENTS.md`.
3. Skills, only the ones the project needs:

```sh
mkdir -p .claude/skills .grok/skills .agents/skills
cp -R "$DOTCLAUDE/claude/skills/commit" .claude/skills/
cp -R "$DOTCLAUDE/grok/skills/commit" .grok/skills/
cp -R "$DOTCLAUDE/codex/skills/commit" .agents/skills/
```

4. Check the result: `git status` shows only the new files, and `grok inspect` lists the project rules and skills.

Project files take precedence over the global ones when they conflict.

## Project instructions

Keep project instructions in `AGENTS.md`. The Claude and Grok session hooks load instruction files from the working directory up to the repository root. Both read `AGENTS.md` and `.claude/AGENTS.md`; Grok also reads `.grok/AGENTS.md`.

## Deliberately not tracked

- Claude permission allowlists and `settings.local.json`, because they can contain machine-specific commands and secrets.
- Plugin-synced or system-provided skills.
- Codex's machine-specific `config.toml`, sessions, caches, and bundled skills.
