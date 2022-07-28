module MyConfig.StartupHook where

import XMonad
import XMonad.Util.SpawnOnce (spawnOnce,spawnOnOnce)

myStartupHook = do
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  spawnOnce "xrandr --output DP-4 --primary --rate 144"
  spawnOnce "xrandr --output DP-3 --auto --right-of DP-4"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "picom --experimental-backends -b"
  spawnOnce "greenclip daemon &"
  spawnOnce "setxkbmap -option 'caps:swapescape'"
  spawnOnce "dunst"
  spawnOnce "~/.config/polybar/launch.sh"
  spawnOnce "audacious"
  spawnOnce "notion-app-enhanced"
  spawnOnce "obsidian"
  spawnOnce "ferdium"
  spawnOnce "discocss"
