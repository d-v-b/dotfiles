# ~/.zshenv — read by every zsh invocation, including scripts. Keep minimal.
#
# Deliberately no PATH here: on macOS, /etc/zprofile runs path_helper, which
# reorders any PATH set in .zshenv. PATH lives in ~/.zprofile instead.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export EDITOR=emacs
export VISUAL=$EDITOR
