#!/usr/bin/env bash
notify-send "launch-left.sh"

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -q top-left -c "$DIR"/config_left.ini &
polybar -q top-center -c "$DIR"/config_left.ini &
polybar -q top-right -c "$DIR"/config_left.ini &
polybar -q bottom-left -c "$DIR"/config_left.ini &
polybar -q bottom-center -c "$DIR"/config_left.ini &
polybar -q bottom-right -c "$DIR"/config_left.ini &
#
# polybar -c $DIR main-left &
# polybar -c $DIR main-left-extended &
# polybar -c $DIR main-left-links &
# polybar -c $DIR main-middle &
# polybar -c $DIR main-right &
# polybar -c $DIR main-right-extended &
# polybar -c $DIR main-tray &
# polybar -c $DIR left &
# polybar -c $DIR main-profile &
