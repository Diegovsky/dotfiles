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

if type -q helix
    alias hx helix
end

function latex-live-pdf -a input
    if ! test -f $input".tex"
        return 1
    end

    begin
        sleep 2 && open $input".pdf"
    end &

    while true
        pdflatex -shell-escape -interaction nonstopmode $input
        inotifywait -e modify $input".tex"
    end
end

if test "$IS_MAC" != 1
    set -g NOTES_DIR "$(xdg-user-dir DOCUMENTS)/Notes"
else
    set -g NOTES_DIR "$HOME/Documents/Notes"
end


function notes
    if ! test -d $NOTES_DIR
        mkdir -p $NOTES_DIR
    end
    cd $NOTES_DIR &&
        $EDITOR
end

alias search "pacman -Ss"
alias install "sudo pacman -Syu"
alias nnvim 'cd ~/.config/nvim && nvim'
alias build 'ninja -C build'
alias ch chezmoi
alias la "ls -la"
alias tempdir 'cd (mktemp -d)'
alias zel zellij
alias nvim2 'NVIM_APPNAME=nvimv2 nvim'
alias lazyvim 'NVIM_APPNAME=lazyvim nvim'
alias notme='notify-me'
alias kilall='killall'
alias ka='killall'
