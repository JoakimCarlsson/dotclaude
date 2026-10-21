# Benchmark

Before and after numbers for the instruction set in this repository: the caveman reply voice, the ponytail code rules, and the work rules, against no instructions, the previous version of this repository, and the two projects it borrows from.

## Method

Claude Code runs use the agentic benchmark from [ponytail](https://github.com/DietrichGebert/ponytail) (`benchmarks/agentic/run.py`). Every cell is a headless Claude Code session in a fresh workspace with a seeded file, scored on the code it leaves behind: a correctness check, a safety check against adversarial input (path traversal, SQL injection, forged tokens, malformed CSV rows, a rename that must reach every caller), source lines of code with tests excluded, output tokens, reply words and cost. Each arm gets its instructions through `--append-system-prompt`; user settings, `CLAUDE.md` files and memory are switched off, so the only difference between arms is the instruction text.

Tasks: `safe-path`, `rate-limit`, `csv-sum`, `cache`, `reuse-slug`, `trace-transfer`, `trace-amount`, `auth-token`, `scope-rename`, `conv-seam`, `open-decorators`, `vibe-todo`, `vibe-jsonconf`, `vibe-password`.

Arms:

| Arm | Instructions |
| --- | --- |
| No instructions | Claude Code's own system prompt only |
| Previous | This repository before the rewrite: prose `CLAUDE.md`, `lean` and `code-style` rules, the first terse output style |
| Caveman | The caveman `SKILL.md` |
| Ponytail | The ponytail `SKILL.md` |
| This repository | `CLAUDE.md`, `rules/code.md` and the terse output style |

## Claude Code, Opus 5.5

Current rules against ponytail alone: 14 tasks, 2 runs each, two separate runs on 2026-10-21. Totals over 28 cells per arm. "Code without doc comments" subtracts docstrings and `/** */` / `///` blocks from the lines of code, for both arms.

| Run | Arm | Passed | Lines of code | Code without doc comments | Output tokens | Reply words | Cost |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Ponytail | 28 | 604 | 534 | 41,832 | 4,115 | $2.30 |
| 1 | This repository | 28 | 584 | 506 | 29,720 | 2,055 | $2.16 |
| 2 | Ponytail | 28 | 594 | 520 | 42,522 | 4,278 | $2.42 |
| 2 | This repository | 28 | 590 | 496 | 29,496 | 2,214 | $2.13 |

Against ponytail: 29 to 31% fewer output tokens, about half the reply words, 5% less code without doc comments, every correctness and safety check passing. The rule that sends a vague request ("build me X") to one file, the fewest functions and built-in types closed the code gap; before it, the same rules wrote 563 lines without doc comments against ponytail's 538. Few tests are written because the rules say to write tests only when asked.

Earlier run with no-instruction baseline, before that rule (same tasks):

| Arm | Passed | Lines of code | Output tokens | Reply words | Cost | Wrote tests |
| --- | --- | --- | --- | --- | --- | --- |
| No instructions | 28 | 1,622 | 80,354 | 6,156 | $3.38 | 22 |
| Ponytail | 28 | 629 | 43,923 | 4,308 | $2.36 | 17 |
| This repository | 28 | 680 | 34,094 | 2,137 | $2.18 | 2 |

## Claude Code, Sonnet 5.5

12 tasks, 1 run each, 2026-10-20, with the first version of the rewrite.

| Arm | Passed | Lines of code | Output tokens | Reply words | Cost |
| --- | --- | --- | --- | --- | --- |
| No instructions | 12 | 521 | 24,072 | 1,726 | $0.59 |
| Caveman | 12 | 465 | 24,936 | 1,425 | $0.62 |
| Ponytail | 12 | 240 | 15,562 | 1,444 | $0.48 |
| Previous | 12 | 361 | 15,139 | 709 | $0.50 |
| This repository, first version | 12 | 346 | 14,097 | 639 | $0.48 |

Caveman alone cut reply words but not output tokens: most output tokens are thinking and tool calls, which a reply voice does not touch. The code rules are what shrink them, by giving the agent less to write.

## Codex, gpt-6.1-sol

Three prompts in the same sandbox repository, one run each, 2026-10-21: an "explain in detail" question, a review, and a small feature. Plain Codex runs from an empty `CODEX_HOME` with only the model and reasoning effort set.

| Arm | Output tokens | Reply words | Messages per prompt | Feature diff |
| --- | --- | --- | --- | --- |
| Plain Codex | 3,305 | 1,119 | 2 | 20 lines |
| This repository | 2,543 | 494 | 1 | 15 lines |

23% fewer output tokens and 56% fewer reply words. The extra message in plain Codex is narration before the first tool call. The feature reply was "Done." plus one line, after building and formatting the code.

## Grok

The same 12 tasks as the Sonnet run, one run each, 2026-10-20, through headless Grok with `~/.grok/AGENTS.md` and rules loaded in both arms.

| Arm | Passed | Output tokens on tasks both passed | Lines of code on tasks both passed |
| --- | --- | --- | --- |
| Default system prompt | 8 | 51,424 | 189 |
| `grok/system-prompt.md` | 11 | 41,992 | 197 |

The replacement system prompt passed three more tasks, including a bug fix the default prompt left half done, at 18% fewer output tokens.

## Limits

One or two runs per cell, so single-task numbers are noisy; the totals are steadier. The tasks are small Python files and open requests; large refactors in real repositories are not covered. Codex and Grok were measured on far fewer prompts than Claude Code.
