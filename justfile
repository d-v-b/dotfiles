# `just` with no arguments lists the recipes
default:
    @just --list

# symlink dotfiles into $HOME (idempotent, backs up replaced files)
link:
    ./link.sh

# install the tools the zsh config expects
deps:
    brew install starship zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf atuin just

# syntax-check the zsh files and validate the ghostty config
check:
    for f in zsh/.zshenv zsh/.zprofile zsh/.zshrc; do zsh -n "$f"; done
    ghostty +validate-config
    @echo all good

# everything a new machine needs: deps, then link
setup: deps link
