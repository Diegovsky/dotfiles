#!/usr/bin/env zsh

packages=(nvim luajit)
rehash

hasprog() {
    return [[ -n $commands[$1] ]]
}

for helper in (yay paru); do
    hasprog $helper && AUR_HELPER=$helper
done

if [[ -z $AUR_HELPER ]]; then
    echo 'No aur helper installed.'
    echo 'Installing paru ...'
    curl -sSOL 'https://github.com/Morganamilo/paru/releases/download/v2.0.3/paru-v2.0.3-1-x86_64.tar.zst'
fi
