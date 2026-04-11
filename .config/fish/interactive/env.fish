# USER VARIABLES

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache
if test $IS_MAC != 0
    set -gx XDG_DATA_DIRS $XDG_DATA_DIRS:$HOME/.local/share
end

set -gx EDITOR $HELIX
set -gx VISUAL $HELIX

# Stuff to prevent $HOME cluttering
set -gx ATOM_HOME $XDG_DATA_HOME/atom
set -gx CABAL_CONFIG $XDG_CONFIG_HOME/cabal/config
set -gx CABAL_DIR $XDG_CACHE_HOME/cabal
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx GNUPGHOME $XDG_DATA_HOME/gnupg
set -gx GOPATH $XDG_DATA_HOME/go
set -gx GRADLE_USER_HOME $XDG_DATA_HOME/gradle
set -gx GTK2_RC_FILES $XDG_CONFIG_HOME/gtk-2.0/gtkrc
set -gx KDEHOME $XDG_CONFIG_HOME/kde
set -gx ICEAUTHORITY $XDG_CACHE_HOME/ICEauthority
set -gx NUGET_PACKAGES $XDG_CACHE_HOME/NuGetPackages
set -gx _JAVA_OPTIONS -Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
