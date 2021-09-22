#!/usr/bin/env sh
exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway &
xsettingsd &
dex -a -e sway &
solaar -w hide &
mako &

/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
