set -g git_branch

function _my_git_tracker --on-variable PWD
    set git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test $status -ne 0
        set git_branch
    end
end

function _my_git_tracker2 --on-event fish_postexec
    if test -n $git_branch
        return
    end
    if test $argv[1] = git; and test $argv[2] = init
    end
end

function fish_vcs_prompt
    if test -z $git_branch
        return
    end
    echo " ($git_branch)"
    return
end
