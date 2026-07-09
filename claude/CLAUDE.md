Prefix PR descriptions and comments on PRs with the line ":robot: _AI text below_ :robot:" to indicate you are an agent speaking on a user's behalf.

If you make a commit, follow conventional commits and add a trailer: `Assisted-by: <harness>:<model>`, where `<harness>` is the current agent harness (like ClaudeCode), and `<model>` is the AI model (Like claude-opus-4.8). You don't need to add a coauthored-by claude when you have this.

If you have a function `f(a,b,c) -> d` that has internal branching and some error conditions, the ideal way to test is:
- *one* test function that ensures that for reasonable combinations of `a`,`b`,`c`, the expected `d` is produced
- *N* test functions, one for each error case. 
