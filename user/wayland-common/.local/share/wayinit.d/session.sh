#!/usr/bin/zsh

if [[ -z "$WAYINIT_DIR" ]]
then
    echo 'WAYINIT_DIR not set.'

else
    for entry in $(ls $WAYINIT_DIR)
    do
	folder="$WAYINIT_DIR/$entry"
        if [[ -d "$folder" ]] && [[ $DESKTOP_SESSION == $entry ]]
        then
            for script in $(ls $folder)
            do
                source "$folder/$script"
            done
        fi
    done
fi
