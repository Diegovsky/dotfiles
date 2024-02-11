#!/usr/bin/zsh

# enable vcs_info
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' max-exports 3
zstyle ':vcs_info:git:*' check-for-changes true
add-zsh-hook -Uz precmd vcs_info # always load before displaying the prompt

setopt prompt_subst

function sed() {
	cat
}

clear='%f'

function theme() {
    local theme_name="$1"
    if [[ -z "$theme_name" ]]; then
        echo "Current theme: ${_prompt_theme_name:-None}" 1>&2
        return
    fi
    prompt-theme-"$theme_name"
    _prompt_theme_name="$1"
}

function list-themes() {
    echo "${(k)functions}" |
        sed -s 's/ /\n/g' |
        grep '^prompt-theme-' |
        sed -s 's/prompt-theme-//'
}
alias themes=list-themes

function prompt-make-color() {
    echo "%F{#$1}"
}

function prompt-default-pallete() {
    red=$(prompt-make-color ff0055)
    yellow=$(prompt-make-color dd6)
    green=$(prompt-make-color 00dd00)
    dark_red=$(prompt-make-color aa0000)
    white=$(prompt-make-color ff)
}

function unpallete() {
    unset red green yellow dark_red white
}

function prompt-reload() {
    local n="$clear"
    local a="$name_color"
    local b="$sep_color"
    local c="$host_color"
    local d="$ok_color"
    local e="$error_color"
    local f="$path_color"
    local g="${branch_color:-$name_color}"
    prompt-path-part() {
        if [[ -n $vcs_info_msg_0_ ]] ; then
            # Remove trailing /. from path
            echo "$vcs_info_msg_0_" | sed -s 's;/.$;;'
        else
            echo "$path_color%~"
        fi
    }

    zstyle ':vcs_info:git:*' stagedstr "$ok_color "
    zstyle ':vcs_info:git:*' unstagedstr "$error_color "
    zstyle ':vcs_info:git*' formats "($g%c%u%b$n):$f%r/%S"

    export PROMPT="$a%n$b@$c%m %(?.$d$n.$e%?)%  \$(prompt-path-part)$n> "
    unpallete
}

# My theme
function prompt-theme-yellow() {
    prompt-default-pallete

    name_color=$red
    host_color=$yellow
    ok_color=$green
    error_color=$dark_red
    sep_color=$white
    path_color=$white

    prompt-reload
}

function prompt-theme-blue() {
    prompt-default-pallete

    name_color=$(prompt-make-color f0088a)
    host_color=$(prompt-make-color 0100f1)
    ok_color=$green
    error_color=$dark_red
    sep_color=$(prompt-make-color 9010f5)
    path_color=$(prompt-make-color 49b2c8)

    prompt-reload
}

if [[ -n "$SSH_CLIENT" ]]; then
    theme yellow
else
    theme blue
fi
