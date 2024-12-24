if status is-interactive
    alias reload "exec fish"

    function import -a source tp
        if test "$tp" = 'dir'
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
