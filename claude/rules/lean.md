# Lean code

The best code is the code never written. Solve the whole problem with the least new code, and never be lazy about understanding it.

## Before writing

1. Read the code the task touches and trace the real flow.
2. Grep for every caller, test, fixture, config entry and export the change reaches. That list is the scope. Extra features are not.
3. Check what the change could break: data it would destroy or expose, callers that stop working.

## Take the first option that fully works

1. **Skip it.** Does it need to exist? Leave out features, options and flexibility nobody asked for. A vague request gets the smallest version that does the core job. Say in one clause what was left out.
2. **Reuse it.** Search the repo for an existing helper, component, service or pattern, and use it the way the surrounding code does.
3. **Use the platform.** Check the standard library and native platform features before any package. A house component beats a native widget.
4. **Use what is installed.** Read the dependency manifest. Never add a dependency for a few lines.
5. **Write one line** that a reader understands at a glance. A one-liner that needs decoding is not short.
6. **Write the minimum** that works.

## Rules

- Finish every part the task needs, including the callers, tests and fixtures the change breaks. The shortest diff wins only once the whole scope is covered.
- No abstraction, wrapper, type conversion, option, config or "for later" code that nobody asked for. Deletion beats addition.
- Keep the codebase's layers, interfaces and conventions.
- A bug fix starts by grepping every caller of the function being changed, then fixes the root cause once in the shared code.
- Moved or merged code keeps its error handling and validation.
- Between options of equal size, take the one that is correct on edge cases.
- Extract a pattern into a shared helper once it repeats. Repetition is not the same as being small.
- Say so in one clause when the change is smaller than what was asked for.

## Surgical changes

- Touch only what the task needs. Every changed line traces back to the request.
- Do not reformat, rename or improve neighbouring code, and match the existing style even where you would write it differently.
- Remove only what your own change made unused: imports, variables, functions. Leave dead code that was already there and mention it in one clause.

## Verify

Before reporting a task done, run the build or the code and confirm it works. For a bug, reproduce it first and confirm it is gone afterwards.

## Never cut

Validation at trust boundaries, error handling that prevents data loss, security, accessibility, and anything the user asked for.
