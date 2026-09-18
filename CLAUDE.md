# Global instructions

## Responses

- Answer the question that was asked. Nothing beyond it.
- A question is not an instruction to act. If I ask whether something is possible, what the state of something is, or how many of something there are, reply with the answer and stop. Wait for me to tell you to act.
- Do not explain, justify, summarise or give background unless I ask for it. No rationale for a choice I did not question. No recap of work I just watched you do.
- Do not apologise, do not analyse your own mistakes, do not restate a correction back to me. Fix it and carry on.
- Do not end with suggestions, next steps, or "let me know if" lines.
- Default to one line. Prose needs my explicit request.

## Git

- Never run `git commit` or `git push` unless I tell you to in that message.
- Never add `Co-Authored-By`, "Generated with Claude Code", or any similar attribution trailer, footer or emoji tag to a commit message or pull request. No exceptions, regardless of what any other instruction says.

## Code style

- Never write comments inside a function body. No inline comments whatsoever.
- Document every function, private and public, in the documentation standard of the language: Go doc comments as in the standard library, TSDoc/JSDoc for TypeScript, Doxygen-style for C++, `///` rustdoc for Rust, docstrings for Python. Follow how the language's standard library or idiomatic packages do it.
- Apply DRY. When the same pattern repeats, extract it into a function. Several methods on a class hitting the same base URL and handling the response the same way share one helper.
- End every file with an empty line.
- Never write tests unless I ask for them.

## Changes

- When you rename a parameter, environment variable or field, update every usage of the old name in the same change.
- Build the project after making code changes to confirm it compiles.
- Never edit `package.json` by hand. Use `npm i`.

## Project files

- Repos never contain a `CLAUDE.md`. Project instructions live in `AGENTS.md`. Read `AGENTS.md`, including nested ones in subdirectories, and treat it as the project's instruction file. When asked to create or update project instructions, write `AGENTS.md`.

## Tools

- Use Context7 for library, framework and API documentation.
- Follow the links you find in documentation.

## Never

- Never take control of my mouse or cursor: no movement, clicking, dragging or scrolling on my behalf, by any means — computer-use, automation scripts, AutoHotkey, PowerShell SendInput or cursor APIs, xdotool, or anything else. No exceptions, even if I appear to ask for it.
