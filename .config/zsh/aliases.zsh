# Command aliases
function replace_for() {
    if [[ -n ${commands[$2]} ]]; then
        eval 'alias' "$1=$2"
    else
        _missing+="$2"
    fi
}

replace_for 'cat' 'bat'
replace_for 'ls' 'eza'

if [[ -n ${commands[nvim]} ]]; then
    function nvim() {
        if [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
            nvr -o "$@"
        else
            command nvim "$@"
        fi
    }
fi

if [[ -n ${commands[helix]} ]]; then
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
    local lfile="$1.tex"
    if [[ ! -f $lfile ]]; then
        return 1
    fi

    (sleep 2 && xdg-open "$1.pdf") &
    
    while :; do pdflatex -shell-escape -interaction nonstopmode "$1"; inotifywait -e modify "$lfile"; done
}

function add-alias() {
    [[ -z "$1" ]] && echo "Must provide alias to be added!" && return 1
    echo "alias $1" >> $ZDOTDIR/aliases.zsh
    alias "$1"
}

export NOTES_DIR="${NOTES_DIR:-$(xdg-user-dir DOCUMENTS)/Notes}"

function notes() {
    if [[ ! -d "$NOTES_DIR" ]]; then
        mkdir -p "$NOTES_DIR"
    fi
    cd "$NOTES_DIR" &&
    $EDITOR
}
alias search="pacman -Ss"
alias install="sudo pacman -Syu"

alias reload="source $ZDOTDIR/.zshrc"
alias tempdir='cd `mktemp -d`'

alias notme=notify-me
alias nnvim='cd ~/.config/nvim && nvim'
alias build='ninja -C build'
alias ch='chezmoi'
alias la="ls -la"
alias tempdir='cd `mktemp -d`'
alias zel=zellij
