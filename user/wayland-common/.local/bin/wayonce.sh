#!/usr/bin/env sh

exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK SSH_AUTH_SOCK &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway &
xsettingsd &
dex -a -e sway &
solaar -w hide &
mako &

kanshi &

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

WAYINIT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/wayinit.d/"
export WAYINIT_DIR

source "$WAYINIT_DIR/session.sh"
