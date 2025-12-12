if test "$(uname -s)" = Darwin
    set -gx IS_MAC 1
end

# set -gx GTK_IM_MODULE fcitx
# set -gx QT_IM_MODULE fcitx
# set -gx XMODIFIERS '@im=fcitx'
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
test -r '/home/diegovsky/.opam/opam-init/init.fish' && source '/home/diegovsky/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true
# END opam configuration
# 
function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
    # Remove the trailing newline from the original prompt. This is done
    # using the string builtin from fish, but to make sure any escape codes
    # are correctly interpreted, use %b for printf.
    printf "%b" (string join "\n" (vterm_old_fish_prompt))
    vterm_prompt_end
end

function vterm_cmd --description 'Run an Emacs command among the ones been defined in vterm-eval-cmds.'
    set -l vterm_elisp ()
    for arg in $argv
        set -a vterm_elisp (printf '"%s" ' (string replace -a -r '([\\\\"])' '\\\\\\\\$1' $arg))
    end
    vterm_printf '51;E'(string join '' $vterm_elisp)
end
