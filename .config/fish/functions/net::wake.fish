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
