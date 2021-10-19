#!/usr/bin/zsh


for entry in $(ls $WAYINIT_DIR)
do
	entry="$PWD/$entry"
	if [[ -d "$entry" ]] && [[ $DESKTOP_SESSION == $(basename "$entry") ]]
	then
		source "$entry/"*
	fi
done
