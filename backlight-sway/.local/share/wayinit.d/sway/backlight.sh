#!/bin/zsh

function keybind() {
	swaymsg "bindsym $@"
}

keybind 'XF86MonBrightnessUp' exec 'brightnessctl set +5%'
keybind 'XF86MonBrightnessDown' exec 'brightnessctl set 5%-'
