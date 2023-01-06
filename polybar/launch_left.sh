#!/usr/bin/env bash
notify-send "launch_left.sh"

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
# polybar -q main -c "$DIR"/config_left.ini &
 polybar -q top -c "$DIR"/config_left.ini &
 polybar -q bottom -c "$DIR"/config_left.ini &
