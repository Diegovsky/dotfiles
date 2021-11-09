PROMPT='%K{#444}%F{#ff0055}%n%f@%F{#dd6}%m%f: %~>%k '

# PLUGINS
source "$ZDOTDIR/ls_colours"
# This must be before compinit
zmodload zsh/complist
# Case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit; compinit
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache/}/zsh/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

_comp_options+=(globdots)

setopt MENU_COMPLETE ALWAYS_TO_END
setopt HIST_SAVE_NO_DUPS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# VIM mode
source $ZDOTDIR/'cursor_mode'
export KEYTIMEOUT=1
# Load other keybindings
source "$ZDOTDIR/bindings"

# Command aliases
alias ls="exa"
alias la="exa -la"
alias search="pacman -Ss"
alias install="pacman -Syu"
alias reload="source $ZDOTDIR/.zshrc"

