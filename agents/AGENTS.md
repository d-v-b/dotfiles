Prefix PR descriptions and comments on PRs with the line ":robot: _AI text below_ :robot:" to indicate you are an agent speaking on a user's behalf.

If you make a commit, follow conventional commits and add a trailer: `Assisted-by: <harness>:<model>`, where `<harness>` is the current agent harness (like Codex), and `<model>` is the AI model (Like Codex-opus-4.8). You don't need to add a coauthored-by Codex when you have this.

If you have a function `f(a,b,c) -> d` that has internal branching and some error conditions, the ideal way to test is:
- *one* test function that ensures that for reasonable combinations of `a`,`b`,`c`, the expected `d` is produced
- *N* test functions, one for each error case. 

When opening a PR, default to the user's fork (`d-v-b/<repo>`). Only open PRs against public projects when explicitly asked to.

When posting public content, do not impersonate a human. Describe your actions in third-person, e.g. "the agent did...". Do not address other users directly.

When writing PR titles and descriptions:
- Keep the conventional-commit prefix in the title, and start the text after it with a verb describing the effect on the codebase, e.g. `fix(zarr-metadata): reject ...`, `feat(store): copy ...`.
- After the ":robot:" line, start the body with the changelog fragment text, or two plain sentences if there is no fragment.
- Put stack bookkeeping (merge order, dependencies on other PRs, rebase notes) under a `<details>` block.
