Prefix PR descriptions and comments on PRs with the line ":robot: _AI text below_ :robot:" to indicate you are an agent speaking on a user's behalf.

If you make a commit, follow conventional commits and add a trailer: `Assisted-by: <harness>:<model>`, where `<harness>` is the current agent harness (like ClaudeCode), and `<model>` is the AI model (Like claude-opus-4.8). You don't need to add a coauthored-by claude when you have this.

If you have a function `f(a,b,c) -> d` that has internal branching and some error conditions, the ideal way to test is:
- *one* test function that ensures that for reasonable combinations of `a`,`b`,`c`, the expected `d` is produced
- *N* test functions, one for each error case. 

When opening a PR, default to the user's fork (`d-v-b/<repo>`). Only open PRs against public projects when explicitly asked to.

When posting public content, do not impersonate a human. Describe your actions in third-person, e.g. "the agent did...". Do not address other users directly.

When writing PR titles and descriptions:
- Keep the conventional-commit prefix in the title, and start the text after it with a verb describing the effect on the codebase, e.g. `fix(zarr-metadata): reject ...`, `feat(store): copy ...`.
- After the ":robot:" line, start the body with the changelog fragment text, or two plain sentences if there is no fragment.
- Put everything else the agent writes (its summary, design and test notes, review findings) inside `<details>` blocks, so the visible body stays short and the user can add their own summary above. Stack bookkeeping, merge order, and relationships to other PRs must be presented outside `<details>` blocks.

When opening a stack of dependent PRs, only the bottom PR is ready for review; open every PR above it as a draft. A stack can only be merged one PR at a time, so mark the next PR ready only after the one below it merges and the base branch has been merged into it. This holds whether each PR targets its parent branch or every PR targets the base branch.

Adversarially review every substantive change before calling it done or marking its PR ready. Past rounds found a serious bug about 60% of the time, and two thirds of the time in round 1. Run the review this way:
- Spawn fresh reviewer agents. Give them the diff and the files to read, not your conclusions.
- Before fixing a finding, confirm it: reproduce it or trace it in the code.
- Fixes cause many late-round bugs. From round 3 on, review only the latest fix diff and the code it touches.
- Stop after two rounds in a row with no serious finding. Don't keep looping.
- Record what happened to each finding (fixed in which commit, or rejected and why) in the PR or as a roborev comment.

Always look for ways we can improve our processes. Suggest holistic fixes instead of repeatedly fixing symptoms of bad design. Self-evaluate when you find yourself looping back. 
