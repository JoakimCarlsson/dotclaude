# dotclaude

My custom Claude Code, Codex, and Grok configuration.

## Contents

| Path | What it is |
| --- | --- |
| `claude/` | Global Claude Code instructions, settings, hooks, agents, and skills |
| `codex/AGENTS.md` | Global Codex instructions applied to every repository |
| `codex/skills/` | Global Codex skills such as `$commit`, `$issue`, and `$pr` |
| `grok/` | Global Grok instructions, hooks, agents, and skills |

## Install

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

## Deliberately not tracked

- Claude permission allowlists and `settings.local.json`, because they can contain machine-specific commands and secrets.
- Plugin-synced or system-provided skills.
- Codex's machine-specific `config.toml`, sessions, caches, and bundled skills.
