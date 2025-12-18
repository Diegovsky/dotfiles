if test "$(uname -s)" = Darwin
    set -gx IS_MAC 1
end

# set -gx GTK_IM_MODULE fcitx
# set -gx QT_IM_MODULE fcitx
# set -gx XMODIFIERS '@im=fcitx'
for name in helix hx
    if which $name &>/dev/null
        set -gx HELIX $name
        break
    end
end
if ! type -q rust-analyzer; and type -q rustup
    fish_add_path (path dirname (rustup which rust-analyzer))
end

set -gx WEB_BROWSER firefox

if status is-interactive
    alias reload "exec fish"

    function import -a source tp
        if test "$tp" = dir
            set -l source $__fish_config_dir/$source
            for entry in (ls $source)
                source $source/$entry
            end
        else
            source $__fish_config_dir/$source
        end
    end

    import vterm.fish
    import interactive.fish
    import vterm-end.fish
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
