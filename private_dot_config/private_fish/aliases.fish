
# Command aliases
function replace_for -a sub cmd 
    if type -q $cmd
        alias $sub $cmd
    else
        set -a _missing $cmd
    end
end

replace_for cat bat
replace_for ls eza

if type -q nvim
    function nvim 
        if test -n "$NVIM_LISTEN_ADDRESS"
            nvr -o "$argv"
        else
            command nvim "$argv"
        end
    end
end

if type -q helix
    alias hx helix
end

function latex-live-pdf -a input
    if ! test -f $input".tex"
        return 1
    end

    begin
        sleep 2 && xdg-open $input".pdf"
    end &
    
    while true
        pdflatex -shell-escape -interaction nonstopmode $input
        inotifywait -e modify $input".tex"
    end
end

set -g NOTES_DIR "$(xdg-user-dir DOCUMENTS)/Notes}"

function notes 
    if ! test -d $NOTES_DIR
        mkdir -p $NOTES_DIR
    end
    cd $NOTES_DIR &&
    $EDITOR
end

alias search "pacman -Ss"
alias install "sudo pacman -Syu"
alias tempdir 'cd `mktemp -d`'

alias nnvim 'cd ~/.confid/nvim && nvim'
alias build 'ninja -C build'
alias ch 'chezmoi'
alias la "ls -la"
alias tempdir 'cd `mktemp -d`'
alias zel zellij
