set fish_greeting

if test "$(uname -s)" = Darwin
    set -gx IS_MAC 1
end

for name in helix hx
    if type -q $name
        set -gx HELIX $name
    end
end

if ! type -q rust-analyzer; and type -q rustup
    fish_add_path (path dirname (rustup which rust-analyzer))
end

set -gx WEB_BROWSER zen-browser

if status is-interactive
    alias reload "exec fish"

    function import -a source tp
        if test "$tp" = dir
            set -l source $__fish_config_dir/$source
            for entry in $source/*.fish
                source $entry
            end
        else
            source $__fish_config_dir/$source
        end
    end

    import interactive.fish
else if status is-login
    # Let's source path
    if test $IS_MAC = 0
        systemctl --user import-environment PATH
    end
end
