# Command aliases
if [[ -z "$IS_NIX" ]]; then
    alias search="pacman -Ss"
    alias install="sudo pacman -Syu"
else
    alias search="nix search nixpkgs"
    function install() {
        if [[ $# -lt 1 ]]; then
            return -1
        fi
        nix profile install "nixpkgs#$1"
    }
fi

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
alias la="ls -la"
alias tempdir='cd `mktemp -d`'
