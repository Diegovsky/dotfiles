# Command aliases
alias search="pacman -Ss"
alias install="sudo pacman -Syu"

alias reload="source $ZDOTDIR/.zshrc"
alias tempdir='cd `mktemp -d`'
function replace_for() {
    if which $2 > /dev/null; then
        eval 'alias' "$1=$2"
    else
        local key="show_error_alias_$2"
        local shown_error=$(db_get $key)
        if [[ -z $shown_error ]]; then
            echo "Command '$2' missing, falling back to '$1'"
            db_put $key 1
        fi
    fi
}
replace_for 'cat' 'bat'
replace_for 'ls' 'exa'

if which nvim > /dev/null; then
    function nvim() {
        if [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
            nvr -o "$@"
        else
            command nvim "$@"
        fi
    }
fi

alias la="ls -la"
alias tempdir='cd `mktemp -d`'
if which helix > /dev/null; then
    alias hx=helix
fi


# Help command
autoload -Uz run-help-git run-help-ip run-help-openssl run-help-p4 run-help-sudo run-help-svk run-help-svn
autoload -Uz run-help;

(( ${+aliases[run-help]} )) && unalias run-help
help() {
    PAGER='less -S' run-help $@
}

function notify-me() {
    local code=$?
    local cmd
    if [[ $# == 0 ]]; then
        cmd=$( echo "$history[$HISTCMD]" | cut -d';' -f1 )
        cmd="${cmd## }"
    else
        $@
        code=$?
        cmd="$@"
    fi
    local img
    local msg
    local category
    if [[ $code == 0 ]]; then
        img="$ZDOTDIR/img/ok.png"
        msg="Finished <b>successfully</b>"
        category='transfer.complete'
    else
        img="$ZDOTDIR/img/error.png"
        msg="Failed with error code <b>$code</b>"
        category='transfer.fail'
    fi
    if [[ ${#cmd} -ge 15 ]]; then
        cmd="${cmd::12}..."
    fi
    notify-send --category="$category" --icon="$img" "Command '${cmd}' finished" "$msg"

}

function latex-live-pdf() {
    local lfile="$1.latex"
    if [[ ! -f $lfile ]]; then
        echo "File $lfile not found"
        lfile="$1.tex"
        if [[ ! -f $lfile ]]; then
            echo "File $lfile not found"
            return 1
        fi
    fi

    
    while :; do inotifywait -e modify "$lfile"; pdflatex -interaction nonstopmode "$1"; done
}

alias notme=notify-me
alias nnvim='cd ~/.config/nvim && nvim'
alias build='ninja -C build'
