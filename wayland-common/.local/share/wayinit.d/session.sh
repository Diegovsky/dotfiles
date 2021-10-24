#!/usr/bin/zsh

if [[ -z "$WAYINIT_DIR" ]]
then
    echo 'WAYINIT_DIR not set.'

else
	for entry in $(ls $WAYINIT_DIR)
	do
		entry="$WAYINIT_DIR/$entry"
		if [[ -d "$entry" ]] && [[ $DESKTOP_SESSION == $(basename "$entry") ]]
		then
			for script in $(ls $entry)
			do
				source "$entry/$script"
			done
		fi
	done
fi
