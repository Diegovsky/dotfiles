set -g git_branch

function _my_git_tracker --on-variable PWD
    set git_branch (git symbolic-ref --short HEAD 2>/dev/null)
    if test $status -ne 0
        set git_branch
        return
    end
    if git status --porcelain=v1 2>/dev/null | read -l l
        set git_branch "$git_branch*"
    end
end
_my_git_tracker

function _my_git_tracker2 --on-event fish_postexec
    set args (string split ' ' $argv[1])
    if test "$args[1]" = git
        switch $args[2]
            case status diff st
            case '*'
                _my_git_tracker
        end
    end
end

function fish_vcs_prompt
    if test -z $git_branch
        return
    end
    echo " ($git_branch)"
    return
end
