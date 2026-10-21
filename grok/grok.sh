# Source from ~/.bashrc: run grok with the terse system prompt in place of its default one.

# grok runs the Grok CLI with ~/.grok/system-prompt.md as its system prompt; AGENTS.md and rules still load.
grok() {
  command grok --system-prompt-override "$(cat "$HOME/.grok/system-prompt.md")" "$@"
}
