#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# blurry	
# appdrawer		appdrawer_alt
# column	row		row_center	screen	row_dock		row_dropdown

theme="screen"
dir="$HOME/.config/rofi/launchers/misc"

# comment these lines to disable random style
themes=($(ls -p --hide="launcher_column.sh" $dir))
theme="${themes[$(( $RANDOM % 8 ))]}"

# rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
rofi -no-lazy-grab -show drun -modi drun -theme $dir/"appdrawer_alt"
