#!/usr/bin/env bash

filename=`mktemp`
swaymsg "exec echo \$_accel_toggle > $filename"
current_value=`cat $filename`
rm $filename

echo $current_value $filename `cat $filename`

if [[ $current_value == adaptive ]]; then
    next_value=flat
else
    next_value=adaptive
fi

swaymsg "set \$_accel_toggle $next_value"
swaymsg 'input $mouse accel_profile $_accel_toggle'
