#!/bin/sh
# Symlink dotfiles from this repo into $HOME. Idempotent: already-correct
# links are left alone, existing regular files are backed up to
# <name>.pre-dotfiles before linking.
set -eu

repo="$(cd "$(dirname "$0")" && pwd)"

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
