module MyConfig.StartupHook where

import XMonad
import XMonad.Util.SpawnOnce (spawnOnce,spawnOnOnce)

myStartupHook = do
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  spawnOnce "xrandr --output HDMI-0 --mode 1920x1080 --right-of DP-0 --rotate normal --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "feh --recursive --bg-fill --randomize ~/Wallpapers/"
  spawnOnce "picom -b"
  spawnOnce "greenclip daemon"
  spawnOnce "emacs --daemon"
  spawnOnce "setxkbmap -option 'caps:swapescape'"
  spawnOnce "dunst"
  spawnOnce "~/.config/polybar/launch.sh"
  spawnOnce "notion-app-enhanced"
  spawnOnce "obsidian"
  spawnOnce "ferdium"
  spawnOnce "discocss"
