# dotclaude

My custom Claude Code, Codex, and Grok configuration.

## Contents

| Path | What it is |
| --- | --- |
| `claude/` | Global Claude Code instructions, output style, rules, settings, hooks, and skills |
| `codex/AGENTS.md` | Global Codex instructions applied to every repository |
| `codex/skills/` | Global Codex skills for Git, GitHub tasks, and pull requests |
| `grok/` | Global Grok instructions, rules, hooks, and skills |

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

## Rules

Rules are always-on instructions. Claude Code and Grok load them from a `rules/` folder; Codex has no rules folder, so the same content sits inside `codex/AGENTS.md`. All instruction text is written in the same terse voice the replies should use, because the style of a prompt carries over into the style of the output.

| Rule | What it does |
| --- | --- |
| `code` | Smallest complete change: read and trace first, then skip, reuse, use the platform or an installed dependency before writing new code; finish every caller and fixture the change reaches; never cut validation, error handling, security or accessibility; code style and verification |

## Output style

`claude/output-styles/terse.md` sets how Claude Code replies: caveman-terse, answer first, a length budget, "Done." plus one line for finished tasks. `outputStyle` in `claude/settings.json` selects it, and the `terse-reminder.sh` UserPromptSubmit hook restates the voice and the smallest-change rule next to every prompt; without the reminder, replies drift back to prose.

Codex and Grok have no output style, so the same text is the Responses section of their `AGENTS.md`. Codex also gets the per-prompt reminder from `codex/hooks.json`. Its built-in base prompt asks for warm, connected prose and frequent commentary, which outranks `AGENTS.md`, so `codex/instructions.md` replaces it: the `gpt-6.1-sol` base prompt from `~/.codex/models_cache.json` with the Personality, commentary and Visualizations sections swapped for the terse voice. Rebuild it when a Codex update changes the base prompt. Load it from `~/.codex/config.toml`, at top level:

```toml
model_instructions_file = "/home/<user>/.codex/instructions.md"
```

Measured with ponytail's agentic benchmark on Opus 5.5 (14 tasks, 2 runs each, two runs, 2026-10-21), against ponytail alone: 29 to 31% fewer output tokens, about half the reply words and 5% less code not counting doc comments; against no instructions, an earlier version wrote 58% fewer output tokens and 58% less code. Every arm passed every correctness and safety check. Full tables and method: [BENCHMARK.md](BENCHMARK.md).

Codex with this config against a plain Codex, same three prompts on `gpt-6.1-sol`: 23% fewer output tokens, 56% fewer reply words, no narration message before tool calls, and a 15-line diff for the task against 20.

Grok discards `UserPromptSubmit` hook output, so it gets no per-prompt reminder. Its default system prompt asks for complete sentences and puts scratch files in `/tmp`, and agent definitions only append to it, so `grok/system-prompt.md` replaces it: Grok 1.0.62's prompt with the communication and formatting sections swapped for the terse voice and scratch files moved to `~/.cache/scratch`. `grok/grok.sh` defines a `grok` shell function that passes it with `--system-prompt-override`; `AGENTS.md` and rules still load. On the same 12 benchmark tasks, Grok with the override passed 11 against 8 without it, at 18% fewer output tokens on the tasks both passed. Rebuild it from a session's `system_prompt.txt` under `~/.grok/sessions/` when a Grok update changes the prompt.

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
mkdir -p ~/.claude ~/.codex/skills ~/.grok/rules ~/.grok/skills ~/.grok/hooks
cp -R claude/. ~/.claude/
cp codex/AGENTS.md codex/hooks.json codex/instructions.md ~/.codex/
mkdir -p ~/.codex/hooks && cp codex/hooks/terse-reminder.sh ~/.codex/hooks/
cp -R codex/skills/. ~/.codex/skills/
cp grok/AGENTS.md ~/.grok/AGENTS.md
cp -R grok/rules/. ~/.grok/rules/
cp grok/hooks/load-agents-md.sh grok/hooks/hooks.json ~/.grok/hooks/
cp grok/system-prompt.md grok/grok.sh ~/.grok/
cp -R grok/skills/. ~/.grok/skills/
```

3. In `~/.claude/settings.json`, set the `SessionStart` and `UserPromptSubmit` hook commands to the absolute paths of `~/.claude/hooks/load-agents-md.sh` and `~/.claude/hooks/terse-reminder.sh` for the current user. The Grok hook already uses `$HOME`.
4. Make the hook scripts executable: `chmod +x ~/.claude/hooks/*.sh ~/.codex/hooks/*.sh ~/.grok/hooks/*.sh`, add the `model_instructions_file` line above to `~/.codex/config.toml`, and add `[ -f "$HOME/.grok/grok.sh" ] && . "$HOME/.grok/grok.sh"` to `~/.bashrc`.
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
cp "$DOTCLAUDE/claude/rules/code.md" .claude/rules/
cp "$DOTCLAUDE/grok/rules/code.md" .grok/rules/
```

2. Codex has no rules folder. Append the "Code" section from `codex/AGENTS.md` to the repository's `AGENTS.md`, creating the file if it is missing. Do not overwrite an existing `AGENTS.md`.
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
