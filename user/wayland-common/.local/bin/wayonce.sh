#!/usr/bin/env sh

COMPOSITOR=${1:-sway}

echo $COMPOSITOR > /tmp/wayinit.log
echo $DESKTOP_SESSION >> /tmp/wayinit.log

dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK SSH_AUTH_SOCK DBUS_SESSION_BUS_ADDRESS XAUTHORITY XDG_CURRENT_DESKTOP=$COMPOSITOR &
xsettingsd &
dex -a -e $COMPOSITOR &
solaar -w hide &
mako &

kanshi &

/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

WAYINIT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/wayinit.d/"
export WAYINIT_DIR

source "$WAYINIT_DIR/session.sh"
