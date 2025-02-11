
function prompt-theme-blue
    set fish_color_user f0088a
    set fish_color_host 0100f1
    set fish_color_status aa0000
    set fish_color_cwd 49b2c8
    set -g prompt_color_sep 9010f5
end

function prompt-theme-yellow
    set red ff0055
    set yellow dd6
    set green 00dd00
    set dark_red aa0000
    set white ffffff

    set fish_color_user $red
    set fish_color_host $yellow
    # set fish_color_status $green
    set fish_color_status $dark_red
    set fish_color_cwd $white
    set -g prompt_color_sep $white

end

prompt-theme-blue
