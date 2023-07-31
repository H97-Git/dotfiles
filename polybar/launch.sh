#!/usr/bin/env bash
notify-send "launch.sh"

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar
echo "killall"

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar

echo "polybar"
polybar -q top-left -c "$DIR"/config.ini &
polybar -q top-center -c "$DIR"/config.ini &
polybar -q top-right -c "$DIR"/config.ini &
polybar -q bottom-left -c "$DIR"/config.ini &
polybar -q bottom-center -c "$DIR"/config.ini &
polybar -q bottom-right -c "$DIR"/config.ini &
echo "end"
