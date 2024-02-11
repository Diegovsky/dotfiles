if [[ -n ${commands[direnv]} ]]; then
    eval "$(direnv hook zsh)"
else
    _missing+=direnv
fi
