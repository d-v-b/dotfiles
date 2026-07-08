# ~/.zshrc — interactive shells. Shared across machines; anything
# machine-specific (conda, nvm, cluster modules, ...) goes in ~/.zshrc.local.
#
# Startup profiling: uncomment this line and `zprof` at the bottom.
# zmodload zsh/zprof

# --- options ---------------------------------------------------------------
setopt auto_cd auto_pushd pushd_ignore_dups pushd_silent
setopt interactive_comments extended_glob no_beep

# --- history ---------------------------------------------------------------
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" \
         "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=120000   # > SAVEHIST so expiring dups has headroom
SAVEHIST=100000
setopt extended_history share_history
setopt hist_ignore_all_dups hist_expire_dups_first hist_find_no_dups
setopt hist_save_no_dups hist_ignore_space hist_reduce_blanks hist_verify

# --- completion ------------------------------------------------------------
if [[ -n $HOMEBREW_PREFIX ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh-completions"
         "$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi
autoload -Uz compinit
# Full rebuild (with security audit) at most once a day; otherwise trust the
# cached dump (-C), which cuts ~50ms off startup.
_zcd="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
if [[ -n $_zcd(#qN.mh+24) ]]; then
  compinit -d "$_zcd"
else
  compinit -C -d "$_zcd"
fi
unset _zcd
zmodload zsh/complist
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'

# --- keybindings -----------------------------------------------------------
bindkey -e  # emacs mode, explicitly (zsh guesses vi mode from EDITOR)
autoload -Uz edit-command-line && zle -N edit-command-line
bindkey '^X^E' edit-command-line
# up/down search history for the prefix already typed
bindkey '^[[A' history-beginning-search-backward
bindkey '^[OA' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[OB' history-beginning-search-forward
# option+arrows move by word, fn+delete deletes forward
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[3~' delete-char

autoload -Uz zmv  # pattern renamer: zmv -n '(*).jpeg' '$1.jpg'

# --- aliases ---------------------------------------------------------------
alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -lahG'

# --- tools (each guarded so this file works on machines without them) ------
# fzf: ctrl-t file picker, alt-c cd into directory
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# atuin: ctrl-r history search; arrows stay native (bound above)
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

if [[ -r $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# prompt (gh-account indicator lives in starship.toml)
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- machine-specific overrides --------------------------------------------
[[ -r $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"

# syntax highlighting must be sourced after everything that defines widgets
if [[ -r $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# zprof
