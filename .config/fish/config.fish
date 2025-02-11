if test "$(uname -s)" = Darwin
    set -gx IS_MAC 1
end

# set -gx GTK_IM_MODULE fcitx
# set -gx QT_IM_MODULE fcitx
# set -gx XMODIFIERS '@im=fcitx'

for name in helix hx
    if type -q $name then
        set -gx HELIX $name
    end
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
