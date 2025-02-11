# Notifies me when a long-running command has finished.
function notify-me -a mode
    set --local cmd
    set --local code 

    switch $mode
        case wait w -w --wait
            set cmd $history[1]
            fg
            set code $status
        case ''
            set code $status
            set -l line $(status current-commandline)
            set cmd (string split ';' $line | string trim | head -n -1 | string join '; ')
        case '*'
            echo -e 'Not a valid method'
            return 1
    end

    set --local img
    set --local msg
    set --local category
    if test $code = 0
        set img "$ZDOTDIR/img/ok.png"
        set msg "Finished <b>successfully</b>"
        set category 'transfer.complete'
    else
        set img "$ZDOTDIR/img/error.png"
        set msg "Failed with error code <b>$code</b>"
        set category 'transfer.fail'
    end
    set cmd (string shorten -m $NOTIFY_CMD_LEN $cmd)
    notify-send --category="$category" --icon="$img" "Command '$cmd' finished" "$msg"
end

