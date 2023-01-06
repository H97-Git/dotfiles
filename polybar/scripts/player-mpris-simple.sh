#!/bin/sh

playing_status=$(mpc | grep "] #" | awk '{print $1}')
paused_status=$(mpc | grep "]  #" | awk '{print $1}')

if [ "$playing_status" = "[playing]" ]; then
    echo "▶ $(mpc | grep -m1 "") - $(mpc | grep "#" | awk '{print $3}')"
elif [ "$paused_status" = "[paused]" ]; then
    echo "$(mpc | grep -m1 "") - Paused"
else
    echo "Error in script"
fi
