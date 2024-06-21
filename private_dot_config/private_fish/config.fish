if status is-interactive
    alias reload "source $__fish_config_dir/config.fish"

    function import -a source
        source $__fish_config_dir/$source
    end

    import interactive.fish

    functions -e import
end
