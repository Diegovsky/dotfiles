
import interactive dir

if ! set -q
    set -U NOTIFY_CMD_LEN 30
end

# Enable zoxide integration
zoxide init fish | source
# Enable direnv integration
direnv hook fish | source

# Disables receiving Focus In/Out sequences
function disable_fio
    echo -en '\e[?1004l'
end

# Enables receiving Focus In/Out sequences
function enable_fio
    echo -en '\e[?1004h'
end

set -g TERM_FOCUSED no
bind \e\[I 'set -g TERM_FOCUSED yes'
bind \e\[O 'set -g TERM_FOCUSED no'

