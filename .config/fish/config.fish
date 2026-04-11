set fish_greeting

if test "$(uname -s)" = Darwin
    set -gx IS_MAC 1
end

function __import -a arg
    if not test -e $arg
        set arg $HOME/.config/fish/$arg
    end
    if test -d $arg
        for entry in $arg/*
            __import $entry
        end
    else
        source $arg
    end
end

# set -gx GTK_IM_MODULE fcitx
# set -gx QT_IM_MODULE fcitx
# set -gx XMODIFIERS '@im=fcitx'

set -gx WEB_BROWSER vivaldi

if status is-interactive
    alias reload "exec fish"

    # import vterm.fish
    __import interactive.fish
    # import vterm-end.fish
else if status is-login
    # Let's source path
    systemctl --user import-environment PATH
end

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
set OPAM_INIT $HOME/.opam/opam-init/init.fish
test -r $OPAM_INIT && source $OPAM_INIT >/dev/null 2>/dev/null; or true
# END opam configuration
# 
