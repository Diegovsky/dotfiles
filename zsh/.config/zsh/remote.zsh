
function remote::watch() {
    ! arg $1 FILE 'to serve' && return 1
    ! meta::needs rclone inotifywait && return 1

    echo "Setting up file serving using WebDav on directory $1..."

    systemctl --user start file-serving

    while meta::watchfile $1; do
        mv $1 /src/webdav
    done
}

function remote::run() {
    ! arg $1 ADDR 'to connect' && return 1
    ! arg $2 FILE 'to be received' && return 1
    ! meta::needs rclone && return 1

    local mount=/tmp/webdav
    local file="$mount/$2"

    mkdir -p $mount

    (! rclone mount "$1" "$mount" && return 1) &
    while meta::watchfile "$file" ; do
        echo "Got file!"
        "$file"
    done
}
