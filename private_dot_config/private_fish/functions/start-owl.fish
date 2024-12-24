function start-owl
    set -l card wlp4s0
    sudo ip link set $card down
    sudo iw $card set type monitor
    sudo iw $card set monitor active
    sudo ip link set $card up
    sudo owl -i $card $argv
end
