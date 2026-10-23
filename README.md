# dotclaude

My custom Claude Code, Codex, and Grok configuration.

## Contents

| Path | What it is |
| --- | --- |
| `claude/` | Global Claude Code instructions, settings, session hook, and skills |
| `codex/AGENTS.md` | Global Codex instructions applied to every repository |
| `codex/skills/` | Global Codex skills for Git, GitHub tasks, and pull requests |
| `grok/` | Global Grok instructions and skills |

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

Invoke skills with `/skill-name` in Claude Code and Grok, or `$skill-name` in Codex.

## Install

These steps are written for an AI agent to follow. Run them from a clone of this repository:

```sh
git clone git@github.com:JoakimCarlsson/dotclaude.git
cd dotclaude
```

The session hooks require Bash and Git. GitHub workflows use the authenticated `gh` CLI.

### Global install

Global files apply to every repository for the current user.

1. Back up what exists. Installation overwrites files with matching names: `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.codex/AGENTS.md`, `~/.grok/AGENTS.md`.
2. Copy the files:

```sh
mkdir -p ~/.claude ~/.codex/skills ~/.grok/skills
cp -R claude/. ~/.claude/
cp codex/AGENTS.md ~/.codex/
cp -R codex/skills/. ~/.codex/skills/
cp grok/AGENTS.md ~/.grok/AGENTS.md
cp -R grok/skills/. ~/.grok/skills/
```

3. In `~/.claude/settings.json`, set the `SessionStart` hook command to the absolute path of `~/.claude/hooks/load-agents-md.sh` for the current user.
4. Make the hook scripts executable: `chmod +x ~/.claude/hooks/*.sh`.
5. Start a new session in each tool and confirm it loaded the instructions. In Grok, `grok inspect` lists the skills it found.

What lands where:

| Tool | Instructions | Skills |
| --- | --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/` |
| Codex | `~/.codex/AGENTS.md` | `~/.codex/skills/` |
| Grok | `~/.grok/AGENTS.md` | `~/.grok/skills/` |

### Local install

Local skills apply to one repository only. Run these from the root of the target repository, with `DOTCLAUDE` set to the path of the clone, and copy only the skills the project needs:

```sh
mkdir -p .claude/skills .grok/skills .agents/skills
cp -R "$DOTCLAUDE/claude/skills/commit" .claude/skills/
cp -R "$DOTCLAUDE/grok/skills/commit" .grok/skills/
cp -R "$DOTCLAUDE/codex/skills/commit" .agents/skills/
```

Check the result: `git status` shows only the new files, and `grok inspect` lists the project skills.

Project files take precedence over the global ones when they conflict.

## Project instructions

Keep project instructions in `AGENTS.md`. The Claude session hook loads `AGENTS.md` and `.claude/AGENTS.md` from the working directory up to the repository root. Codex and Grok read `AGENTS.md` natively.

## Deliberately not tracked

- Claude permission allowlists and `settings.local.json`, because they can contain machine-specific commands and secrets.
- Plugin-synced or system-provided skills.
- Codex's machine-specific `config.toml`, sessions, caches, and bundled skills.
