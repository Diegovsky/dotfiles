typeset -A macs=()
macs[homearch]='a8:a1:59:43:fd:cd'

function net::send() {
    meta::arg "$1" FILES 'to send' || return 5
    meta::arg "$2" REMOTE 'to send the files (will use ssh)' || return 5

    local files=(${@[1,-2]})
    local remote="${@[-1]}"

    echo "Sending $files to $remote"
    rsync -azvhe "ssh -p ${PORT:-6534}" $files $remote
    return $?
}

function net::wake() {
    local machine="$1"
    if [[ -z "$machine" ]]; then
        print "Which machine do you want to wake?"
        for m a in "${(@kv)macs}"; do
            echo "    - $m | $a"
        done | column -t
        echo -n '> '
        read machine
    fi
    wol "${macs[$machine]}"
}

RECV_DIR="$HOME/Downloads/ssh-recv"

function net::setup-run() {
    meta::arg "$1" FILE 'to run' || return 5

    mkdir -p "$RECV_DIR"
    cd "$RECV_DIR"

    local arquive="$1.xz"

    while :; do
        echo "Waiting to receive file..."
        meta::watchfile "$1*"
        if [[ ! -f "$arquive" ]]; then
            echo "Just rerun what we have"
        else
            echo "Got it"
            rm -f "$1"
            xz -d "$arquive"
            rm -f "$arquive"
            chmod +x "$1"
        fi
        "./$1"
    done
}

function rust::net-build() {
    meta::arg "$1" HOST "to send the file (will use ssh and place file at '${RECV_DIR/$HOME/~}')" || return 5
    local remote="$1"

    exe="${EXE:-target/debug/$(basename $PWD)}"

    cargo build || return 5

    if [[ ! -f "$exe" ]]; then
        meta::err "Executable '$exe' not found. You can put its path in the \$EXE variable instead."
        return 1
    fi

    if [[ "${__file_hashes[$exe]}" == "$(sha1sum $exe)" ]]; then
        echo "Same file detected. Updating timestamp..."
        ssh -p ${PORT:-6534} $remote touch "$RECV_DIR/${(t)exe}"
        return 0
    fi


    local exename="$(basename $exe)"
    local arquive="$exename.xz"

    typeset -A __file_hashes
    __file_hashes[$exe]=$(sha1sum $exe)

    strip "$exe" || return 5

    echo "Compressing '$exe'..."
    xz -c "$exe" > "$arquive" || return 5
    echo "Done!"

    net::send "$arquive" "$remote:$RECV_DIR" || return 5
}
