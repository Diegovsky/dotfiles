
needs() {
    if [[ -z ${commands[$1]} ]]; then
        echo "Missing '$1'" 1>&2
        exit 1
    elif [[ $# -gt 2 ]]; then
        shift
        needs $@
    fi
}

function remote::watch() {
    if [[ -z $1 ]]; then
        echo 'Missing FILE to be served'
        return 1
    fi
    if ! needs rclone inotifywait; then
        return 1
    fi

    echo "Setting up file serving using WebDav on directory $1..."
    systemctl --user start file-serving
    while inotifywait $1 -e modify -e create; do
        mv $1 /src/webdav
    done
}

function remote::run() {
    set -e
    if [[ -z $1 ]]; then
        echo 'Missing ADDR to connect'
        return 1
    fi
    if [[ -z $2 ]]; then
        echo 'Missing FILE to be received'
        return 1
    fi

    if ! needs rclone; then
        return 1
    fi

    local mount=/mnt/webdav
    local file="$mount/$2"

    rclone mount "$ADDR" "$mount"
    while inotifywait "$file" -e modify -e create ; do
        "$file"
    done
}
