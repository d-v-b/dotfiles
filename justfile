# `just` with no arguments lists the recipes
default:
    @just --list

# symlink dotfiles into $HOME (idempotent, backs up replaced files)
link:
    #!/bin/sh
    set -eu
    repo={{quote(justfile_directory())}}
    link() {
      src="$repo/$1" dst="$2"
      mkdir -p "$(dirname "$dst")"
      if [ -L "$dst" ]; then
        [ "$(readlink "$dst")" = "$src" ] && { echo "ok      $dst"; return; }
        rm "$dst"
      elif [ -e "$dst" ]; then
        mv "$dst" "$dst.pre-dotfiles"
        echo "backup  $dst -> $dst.pre-dotfiles"
      fi
      ln -s "$src" "$dst"
      echo "linked  $dst -> $src"
    }
    link claude/CLAUDE.md       "$HOME/.claude/CLAUDE.md"
    link agents/AGENTS.md       "$HOME/AGENTS.md"
    link zsh/.zshenv            "$HOME/.zshenv"
    link zsh/.zprofile          "$HOME/.zprofile"
    link zsh/.zshrc             "$HOME/.zshrc"
    link git/.gitconfig         "$HOME/.gitconfig"
    link starship/starship.toml "$HOME/.config/starship.toml"
    link ghostty/config         "$HOME/.config/ghostty/config"
    # init.el resolves its own symlink and loads init-osx.el / init-linux.el
    # from the repo, so only these two need linking.
    link emacs/init.el          "$HOME/.emacs.d/init.el"
    link emacs/early-init.el    "$HOME/.emacs.d/early-init.el"

# install the tools the zsh config expects
[macos]
deps:
    brew install starship zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf atuin just

# install the tools the zsh config expects
[linux]
deps:
    sudo apt-get install -y zsh-autosuggestions zsh-syntax-highlighting fzf
    command -v starship >/dev/null || curl -sS https://starship.rs/install.sh | sh
    command -v atuin >/dev/null || curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# syntax-check the zsh files and validate the ghostty config
check:
    for f in zsh/.zshenv zsh/.zprofile zsh/.zshrc; do zsh -n "$f"; done
    command -v ghostty >/dev/null && ghostty +validate-config || echo "(ghostty not on PATH, skipped)"
    @echo all good

# everything a new machine needs: deps, then link
setup: deps link
