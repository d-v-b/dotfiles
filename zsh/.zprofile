# ~/.zprofile — login shells. Every Ghostty/Terminal window on macOS is a
# login shell, and this runs after /etc/zprofile's path_helper, so PATH set
# here keeps its order.

typeset -U path  # dedupe

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

[[ -r $HOME/.cargo/env ]] && . "$HOME/.cargo/env"

# Ghostty CLI (ghostty +list-themes, +show-config, ...)
[[ -d /Applications/Ghostty.app/Contents/MacOS ]] &&
  path+=(/Applications/Ghostty.app/Contents/MacOS)

path=($HOME/.local/bin $path)
export PATH
