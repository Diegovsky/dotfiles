
function set-title { 
    local OUTPUT="\033]0;$1\a"
    echo -en "$OUTPUT"
}

function command-name {
    setopt extended_glob
    echo ${1[(wr)^(*=*|sudo|ssh|-*)]:gs/%/%%}
}

function show-command-name {
    local CMD=$(command-name $1)
    set-title "$CMD"
}

function restore-term-name {
    local CMD=$(command-name $(basename $SHELL))
    set-title "$CMD"
}

restore-term-name

autoload -U add-zsh-hook
add-zsh-hook preexec show-command-name
add-zsh-hook precmd restore-term-name
