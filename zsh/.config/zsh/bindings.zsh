# vim: set ft=zsh:
declare -g -A keycode
keycode[up]='^[[A'
keycode[down]='^[[B'
keycode[Delete]='\e[3~'
keycode[Backspace]='^?'

if [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
    # if we're inside neovim terminal, use emacs mode
    bindkey -e
fi

# History based command completion
for direction (up down) {
  autoload "$direction-line-or-beginning-search"
  zle -N "$direction-line-or-beginning-search"
  bindkey "$keycode[$direction]" "$direction-line-or-beginning-search"
}

# Auto complete menu navigation
bindkey -M menuselect '^[[Z' vi-up-line-or-history
bindkey -M menuselect '\t' vi-down-line-or-history
bindkey -M menuselect '\e' send-break
bindkey -M command '\e' send-break
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect "$keycode[Delete]" send-break
bindkey -M menuselect "^H" backward-delete-word
bindkey -M menuselect '^?' backward-delete-char
# bindkey -M menuselect "^C" send-break
# bindkey -M menuselect '/' accept-and-infer-next-history

# Make Delete work
bindkey "$keycode[Delete]" delete-char
bindkey -M vicmd "$keycode[Delete]" delete-char
# Re-enable C-a and C-e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey -M vicmd '^A' beginning-of-line
bindkey -M vicmd '^E' end-of-line

# make backspace work from vim mode
bindkey -M main "^H" backward-delete-char
bindkey -M main "^?" backward-delete-char

bindkey "e[1~" beginning-of-line
bindkey "e[4~" end-of-line
bindkey "e[5~" beginning-of-history
bindkey "e[6~" end-of-history
bindkey "e[3~" delete-char
bindkey "e[2~" quoted-insert
bindkey "e[5C" forward-word
bindkey "eOc" emacs-forward-word
bindkey "e[5D" backward-word
bindkey "eOd" emacs-backward-word
bindkey "ee[C" forward-word
bindkey "ee[D" backward-word
bindkey "^H" backward-delete-word
# for rxvt
bindkey "e[8~" end-of-line
bindkey "e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "eOH" beginning-of-line
bindkey "eOF" end-of-line

if [[ -n ${commands[fzf]} ]]; then
    alias choose='fzf --bind=tab:up --bind=shift-tab:down'
    function fuzzy-history() {
        BUFFER=$(choose -q "$BUFFER" < $HISTFILE)
        if [[ $? -eq 0 ]]; then
            zle accept-line
        fi
        zle reset-prompt
    }
    zle -N fuzzy-history
    bindkey "^R" 'fuzzy-history'
else
    _missing+=fzf
fi

# Clear current command on <ESC><ESC>
# bindkey -M vicmd "\e" send-break
