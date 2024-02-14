function net::send() {
    meta::arg "$1" FILES 'to send' || return 5
    meta::arg "$2" REMOTE 'to send the files (will use ssh)' || return 5

    rsync -azvhe "ssh -p ${PORT:-6534}" $@
}

function net::setup-recv() {
    meta::arg "$1" REMOTE 'to connect (will use ssh)' || return 5
    tempdir

    ssh -p ${PORT:-6534} -t "$1" env RECV_DIR=$PWD zsh -l
}

function rust::net-build() {
    local remote="${RECV_DIR:-$1}"
    meta::arg "$remote" REMOTE 'to send the file (will use ssh)' || return 5

    exe="${EXE:-target/debug/$(basename $PWD)}"

    cargo build

    if [[ ! -f "$exe" ]]; then
        meta::err "Executable '$exe' not found. You can put its path in the \$EXE variable instead."
        return 1
    fi

    local exename="$(basename $exe)"
    local tarexe="$exename.tar.xz"

    strip "$exe"

    echo "Compressing '$exe'..."
    tar -I xz -vcf "$tarexe" "$exe"
    echo "Done!"

    net::send "$tarexe" "$remote"
}
