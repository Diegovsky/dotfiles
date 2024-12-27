function fwatch --description 'Watch for when $file changes, and executes $cmd' --argument file cmd
    if test -z "$file"
        echo 'Missing file to watch' >&2
        return 1
        elif test -z "$cmd"
        echo 'Missing command to run' >&2
        return 1
        elif test -f "$file"
        echo "File $file doesn't exist."
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
        eval $cmdline
        inotifywait -qq -e $events . --include $file; or return $status
    end
end