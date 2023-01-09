ZLS_COLOURS=""

LS_COLORS="$ZLS_COLOURS"
export LS_COLORS
export ZLS_COLOURS

setopt MENU_COMPLETE ALWAYS_TO_END
setopt HIST_SAVE_NO_DUPS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# This must be before loading keybinds
zmodload zsh/complist
autoload -U compinit promptinit
compinit
promptinit

# Case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache/}/zsh/.zcompcache"
zstyle ':completion:*' menu select interactive search 
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''

_comp_options+=(globdots)

export KEYTIMEOUT=1
export MOZ_ENABLE_WAYLAND=1

if [[ "$IS_NIX" = 1 ]]; then
    remove_profile() {
        if [[ $# -lt 1 ]]; then
            return 0
        fi
        profile=$(nix profile list | rg -i "$1" | cut -d' ' -f 1)
        if [[ -z $profile ]]; then
            echo  "No matching package found for '$1'"
            return -1
        fi
        nix profile remove $profile
        shift
        $0 "$@"
    }
fi
