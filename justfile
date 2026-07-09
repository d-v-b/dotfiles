# `just` with no arguments lists the recipes
default:
    @just --list

# symlink dotfiles into $HOME (idempotent, backs up replaced files)
link:
    ./link.sh

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
