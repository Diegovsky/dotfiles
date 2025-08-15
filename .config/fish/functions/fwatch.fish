function fwatch --description 'Watch for when $file changes, and executes $cmd' --argument-names file --argument-names cmd
    if test -z "$file"
        echo 'Missing file to watch' >&2
        return 1
    else if test -z "$cmd"
        echo 'Missing command to run' >&2
        return 1
    end
    if test -n "$EVENTS"
        set events $EVENTS
    else
        set events close_write,move,modify
    end

    set f $file

    set cmdline (string replace '%' '$' -- $argv[2..])

    echo "Starting watch... $cmdline"
    while :
        begin
            eval $cmdline
        end
        inotifywait -qq -e $events . --include $file
        echo Modified
    end
end
