
function remote::watch() {
    meta::arg $1 FILE 'to serve' || return 1
    meta::needs rclone inotifywait || return 1

    echo "Setting up file serving using WebDav on directory $1..."

    systemctl --user start file-serving

    while meta::watchfile $1; do
        mv $1 /srv/webdav
    done
}

function remote::run() {
    emulate -LR zsh
    set -euo pipefail

    meta::arg $1 REMOTE 'to connect (this is an rclone remote. Run `rclone config` to define one)'
    meta::arg $2 FILE 'to be received'
    meta::needs rclone

    local mount="/tmp/$1"
    local file="$mount/$2"

    mkdir -p $mount

    systemctl --user start "file-grabbing@$1.service"

    while meta::watchfile "$file" ; do
        echo "Got file!"
        "$file"
    done
}
