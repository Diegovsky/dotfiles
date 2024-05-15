#!/usr/bin/env zsh

source arch_base.sh

packages+=(sway sway-screenshot grim slurp xdg-desktop-portal-wlr waybar playerctl dex xsettingsd kanshi foot gnome-keyring swayidle)
aur_packages+=(swaync sway-osd)

sudo pacman -Syu $packages
$AUR_HELPER -Syu $packages

