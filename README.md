# my dotfiles

Configs live here, grouped by tool; `./link.sh` symlinks them into `$HOME`.
It's idempotent — safe to re-run any time — and backs up anything it would
replace to `<name>.pre-dotfiles`. A [justfile](justfile) coordinates it:

```sh
git clone https://github.com/d-v-b/dotfiles ~/dev/dotfiles
cd ~/dev/dotfiles
just setup   # brew-install tools, then link everything
```

Day to day: `just link` after adding a file, `just check` to validate the
zsh/ghostty configs, plain `just` to list recipes.

Everything targets macOS *and* Ubuntu: shell files detect their environment
at runtime (brew vs apt paths, GNU vs BSD `ls`), `just deps` dispatches on
OS, emacs splits via `init-osx.el`/`init-linux.el`, and machine-local or
secret config lives in untracked `~/.zshrc.local` / `~/.gitconfig.local`.

## zsh

| file | runs for | contains |
|---|---|---|
| `zsh/.zshenv` | every zsh, incl. scripts | XDG dirs, `EDITOR` — nothing else |
| `zsh/.zprofile` | login shells | PATH (Homebrew, cargo, Ghostty). PATH goes here, not `.zshenv`, because macOS `path_helper` reorders anything set earlier |
| `zsh/.zshrc` | interactive shells | options, history, completion, keybinds, fzf/atuin/autosuggestions/starship/syntax-highlighting |

The zsh config is shared across machines. Machine-specific things (conda,
nvm, cluster modules) go in `~/.zshrc.local`, which is sourced if present
and not tracked here. The old per-host files (`.zshrc.osx`,
`.zshrc.janelia_cluster`, ...) are kept for machines still symlinking them.

Homebrew packages the zshrc expects (all optional — it degrades gracefully):
`starship zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf atuin`

## emacs

`emacs/init.el` and `emacs/early-init.el` → `~/.emacs.d/`. init.el resolves
its own symlink, so the OS-specific fragments (`init-osx.el`,
`init-linux.el`) load straight from the repo without their own links.
Packages install themselves on first launch; the Python IDE setup expects
`ruff`, `basedpyright-langserver` (or `ty`), and `emacs-lsp-booster` on PATH.

## ghostty

`ghostty/config` → `~/.config/ghostty/config`. Ghostty's defaults are good;
this only sets a light/dark auto-switching theme, left-option-as-Meta,
copy-on-select, and shift+enter. Browse themes with `ghostty +list-themes`.
