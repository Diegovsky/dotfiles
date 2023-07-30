export ZSH_DB="$ZDOTDIR/zshdb"

typeset -A __zsh_db

function error() {
    echo $@ 1>&2
}

function db_create() {
    touch $ZSH_DB
    command cat >$ZSH_DB <<EOF
typeset -A __zsh_db
export __zsh_db
EOF
}

function db_load() {
    if [[ -f "$ZSH_DB" ]]; then
        source "$ZSH_DB"
    else
        error "Failed to read $ZSH_DB"
        return 1
    fi
}
function db_flush() {
    db_create
    for key value in ${(kv)__zsh_db}; do
        echo "__zsh_db[$key]=$value" >> $ZSH_DB
        return 1
    done
}

function db_put() {
    if [[ -z $1 ]]; then
        error 'Missing key value'
        return 1
    fi
    if [[ -z $2 ]]; then
        error 'Missing value'
        return 1
    fi
    __zsh_db[$1]="$2"
}

function db_get() {
    if [[ -z $1 ]]; then
        error 'Missing key value'
        return 1
    fi
    echo ${__zsh_db[$1]}
}
db_load 2>/dev/null
if [[ $? -ne 0 ]]; then
    db_create
fi
