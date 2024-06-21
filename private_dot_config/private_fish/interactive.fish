
import aliases.fish

if ! set -q
    set -U NOTIFY_CMD_LEN 30
end

# Notifies me when a long-running command has finished.
function notify-me -a cmd --on-event fish_postexec
    set --local code $status

    if test $CMD_DURATION -lt 2000; or test "$TERM_FOCUSED" = yes
        return
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
    if test (string length $cmd) -ge (math $NOTIFY_CMD_LEN + 3)
        set cmd (string sub -l $NOTIFY_CMD_LEN $cmd)...
    end
    notify-send --category="$category" --icon="$img" "Command '$cmd' finished" "$msg"
end


# Enable zoxide integration
zoxide init fish | source
# Enable direnv integration
direnv hook fish | source

# Enable receiving Focus In/Out sequences
echo -ne '\e[1004h'

bind \e\[I 'set -g TERM_FOCUSED yes'
bind \e\[O 'set -g TERM_FOCUSED no'

