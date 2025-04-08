if test "$(uname -s)" = Darwin
    set -gx IS_MAC 1
end

# set -gx GTK_IM_MODULE fcitx
# set -gx QT_IM_MODULE fcitx
# set -gx XMODIFIERS '@im=fcitx'

for name in helix hx
    if type -q $name
        set -gx HELIX $name
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

    import interactive.fish
else if status is-login
    # Let's source path
    systemctl --user import-environment PATH
end


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/diegovsky/.opam/opam-init/init.fish' && source '/home/diegovsky/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
