function net::send() {
    meta::arg "$1" FILES 'to send' || return 5
    meta::arg "$2" REMOTE 'to send the files (will use ssh)' || return 5

    rsync -azvhe "ssh -p ${PORT:-6534}" ${@:2} "$1"
}

function net::setup-recv() {
    meta::arg "$1" REMOTE 'to connect (will use ssh)' || return 5
    tempdir

    ssh -p ${PORT:-6534} -t "$1" env RECV_DIR=$PWD zsh -l
}

function rust::net-build() {
    meta::arg "${RECV_DIR:-$1}" REMOTE 'to send the file (will use ssh)' || return 5

    exe="${EXE:-target/debug/$PWD}"

    cargo build

    if [[ ! -f "$exe" ]]; then
        meta::err "Executable '$exe' not found. You can put its path in the \$EXE variable instead."
        return 1
    fi

    local exename="$(basename $exename)"
    local tarexe="$exename.tar.xz"

    strip $exe
    tar -I xz -cf "$tarexe" "$exe"
    net::send "$tarexe" "$1"
}
