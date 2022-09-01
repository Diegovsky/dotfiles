#!/bin/zsh
for i in `seq 0 9`
do
    swaymsg "bindsym \$mod+KP_$i workspace number $i"
done
