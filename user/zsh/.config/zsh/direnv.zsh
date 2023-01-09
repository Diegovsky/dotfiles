# /* vim: set ft=zsh : */
if which direnv >> /dev/null; then
    eval "$(direnv hook zsh)"
else
    echo "Direnv isn't installed"
fi
