#!/usr/bin/env sh

# Start the gnome keyring daemon
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK SSH_AUTH_SOCK &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway &
xsettingsd &
dex -a -e sway &
solaar -w hide &
mako &

/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
