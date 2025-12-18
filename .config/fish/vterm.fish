
function vterm_printf

    if begin
            [ -n "$TMUX" ]; and string match -q -r "screen|tmux" "$TERM"
        end
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end

function vterm_prompt_end

    vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
end

functions --copy fish_prompt vterm_old_fish_prompt

function fish_title
    hostname
    echo ":"
    prompt_pwd
end
