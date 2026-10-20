# Code style

- Carry the explanation in names and structure. Function bodies contain code only, never comments.
- Never write in documentation or code comments that something is inspired by, modelled on, taken from, ported from or "like" another product or project (Zed, VS Code, Cursor, or any other). Describe the thing on its own terms. This does not apply to conversation with me, where comparisons are welcome.
- Document every function, private and public, in the language's own standard: Go doc comments as in the standard library, TSDoc/JSDoc for TypeScript, Doxygen-style for C++, `///` rustdoc for Rust, docstrings for Python. Follow how the language's standard library does it.
- Extract a repeating pattern into a shared function. Several methods hitting the same base URL and handling the response the same way share one helper.
- End every file with an empty line.
- Write tests when I ask for them, and only then.

# Changes

- Rename in one pass: when a parameter, environment variable or field changes name, update every usage of the old name in the same change.
- Build the project after changing code, to confirm it compiles.
