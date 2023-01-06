import XMonad

import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn

import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks  (ToggleStruts(..), manageDocks, docksEventHook , Direction2D (D, L, R, U), docks)
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers (doHideIgnore,doCenterFloat,doFullFloat,isDialog,isInProperty, isFullscreen,composeOne,(-?>),transience)

import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad 

import XMonad.Layout.Fullscreen  (fullscreenSupport,fullscreenManageHook )
import XMonad.Layout.Gaps  (gaps, Direction2D (D, L, R, U), GapMessage (DecGap, IncGap, ToggleGaps), gaps, setGaps)
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing (Border (Border), spacingRaw)
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))

import Data.Bool (bool)
import Data.Maybe (maybeToList, fromJust)
import Control.Monad (join, when, void)
import Graphics.X11.ExtraTypes.XF86 (xF86XK_AudioLowerVolume, xF86XK_AudioMute, xF86XK_AudioNext, xF86XK_AudioPlay, xF86XK_AudioPrev, xF86XK_AudioRaiseVolume, xF86XK_AudioStop)
import qualified Data.Map as M
import qualified XMonad.StackSet as W

import MyConfig.Colors
import MyConfig.Layouts
import MyConfig.Help
import MyConfig.StartupHook
import MyConfig.NotifyVolumeChange

myTerminal = "kitty"
myBrowser = "vivaldi-stable"
myModMask = mod4Mask
myAltMask = mod1Mask
myNormalBorderColor = "#302D41"
myFocusedBorderColor = "#7c4dff"
myGaps = [(L, 10), (R, 10), (U, 40), (D, 40)]


isNotification :: Query Bool
isNotification = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION"
isJetBrainDialog = isInProperty "WM_CLASS" "jetbrains-rider"
myLogHook = fadeInactiveLogHook fadeAmount
     where fadeAmount = 1

myWorkspaces = ["www","dev","default","notes","chat","media"]

myManageHook = fullscreenManageHook <+> manageDocks <+> manageSpawn <+> composeAll
      [
        className =? "Vivaldi-stable" --> doShift (head myWorkspaces),
        className =? "Chromium" --> doShift (head myWorkspaces),
        className =? "jetbrains-rider" --> doShift (myWorkspaces !! 1),
        className =? "notion-app-enhanced" --> doShift (myWorkspaces !! 3),
        className =? "obsidian" --> doShift (myWorkspaces !! 3),
        className =? "discord" --> doShift (myWorkspaces !! 4),
        className =? "Ferdium" -->  doShift (myWorkspaces !! 4),
        className =? "vlc" --> doShift (myWorkspaces !! 5),
        className =? "QMPlay2" --> doShift (myWorkspaces !! 5),
        className =? "Xmessage" --> doCenterFloat,
        className =? "explore.exe" --> doHideIgnore,
        resource =? "desktop_window" --> doIgnore,
        name =? "splash" --> doIgnore,
        isDialog --> doCenterFloat,
        isNotification --> doFloat,
        isFullscreen --> doFullFloat
      ]
      where name = stringProperty "WM_NAME"

myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{z,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{z,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myEZKeys =
        [
          -- Programs
          ("M-S-<Return>", spawn myTerminal),
          ("<Print>", spawn "flameshot gui"),
          ("M-v", spawn myBrowser),
          ("M-S-e", spawn "emacs"),
          ("M-d", spawn "kitty -e xplr"),
          ("M-S-d", spawn "thunar"),
          ("M-S-s",spawn "xprop | xmessage -file -"),
          -- NamedScratchpad
          -- ("M-s d", namedScratchpadAction myScratchPads "files"),
          ("M-s p", namedScratchpadAction myScratchPads "btop"),
          ("M-s t", namedScratchpadAction myScratchPads "terminal"),
          ("M-s m", namedScratchpadAction myScratchPads "ncmpcpp"),
          -- Rofi
          ("M-a", spawn "rofi -show drun"),
          ("M-S-a", spawn "~/.config/rofi/launchers/misc/launchpads/launcher_launchpad.sh"),
          ("M-c", spawn "rofi -modi 'clipboard:greenclip print' -show clipboard"),
          -- Audio keys
          ("<XF86AudioStop>", spawn "mpc stop"),
          ("<XF86AudioPrev>", spawn "mpc prev"),
          ("<XF86AudioPlay>", spawn "mpc toggle"),
          ("<XF86AudioNext>", spawn "mpc next"),
          ("<XF86AudioMute>", volumeToggle "Master"),
          ("<XF86AudioLowerVolume>", volumeDown "Master"),
          ("<XF86AudioRaiseVolume>", volumeUp "Master"),
          -- Screen Orientation (Script created with arandr)
          ("M-S-<Left>", spawn "~/.screenlayout/Left.sh"),
          ("M-S-<Up>", spawn "~/.screenlayout/Normal.sh"),
          -- XMonad
          ("M-<Left>", prevWS),
          ("M-<Right>", nextWS),
          ("M-,", spawn ("echo \""++help++"\" | xmessage -file -")),
          ("M-<Escape>", kill),
          ("M-<Tab>", sendMessage NextLayout),
          ("M-S-x", spawn "xmonad --recompile; xmonad --restart;notify-send 'Xmonad Restart'" ),
          ("M-S-q", spawn "~/.config/rofi/powermenu/powermenu.sh"),
          -- Rotate through the available layout algorithms
          ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts),
          ("M-C-g", sendMessage ToggleGaps), -- toggle all gaps
          ("M-S-g", sendMessage $ setGaps myGaps), -- reset the GapSpec

          ("M-C-t", sendMessage $ IncGap 5 L), -- increment the left-hand gap
          ("M-S-t", sendMessage $ DecGap 5 L), -- decrement the left-hand gap
          ("M-C-y", sendMessage $ IncGap 5 U), -- increment the top gap
          ("M-S-y", sendMessage $ DecGap 5 U), -- decrement the top gap
          ("M-C-u", sendMessage $ IncGap 5 D), -- increment the bottom gap
          ("M-S-u", sendMessage $ DecGap 5 D), -- decrement the bottom gap
          ("M-C-i", sendMessage $ IncGap 5 R), -- increment the right-hand gap
          ("M-S-i", sendMessage $ DecGap 5 R), -- increment the right-hand gap
          
          ("M-<Return>", windows W.swapMaster),
          -- Move focus to the next window
          ("M-j", windows W.focusDown),
          -- Move focus to the previous window
          ("M-k", windows W.focusUp),
          -- Move focus to the master window
          ("M-m", windows W.focusMaster),
          -- Swap the focused window with the next window
          ("M-S-j", windows W.swapDown),
          -- Swap the focused window with the previous window
          ("M-S-k", windows W.swapUp),
          -- Shrink the master area
          ("M-h", sendMessage Shrink),
          -- Expand the master area
          ("M-l", sendMessage Expand),
          -- Push window back into tiling
          ("M-t", withFocused $ windows . W.sink)
       ]

myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
    ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [
  -- NS "files" "thunar" (className =? "thunar") manageTerm,
  NS "terminal" "kitty --class=scratchpad" (className =? "scratchpad") manageTerm,
  NS "ncmpcpp" "kitty --class=ncmpcpp -e ncmpcpp" (className =? "ncmpcpp") manageTerm,
  NS "btop" "kitty --class=bpytop -e bpytop" (className =? "bpytop") manageTerm]
  where
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.8
                 w = 0.8
                 t = 0.1
                 l = 0.1

main = xmonad $ fullscreenSupport $ docks $ ewmh defaults
defaults = def { 
                  terminal = myTerminal,
                  focusFollowsMouse = False,
                  clickJustFocuses = False,
                  borderWidth = 1,
                  modMask = myModMask,
                  workspaces = myWorkspaces,
                  normalBorderColor = myNormalBorderColor,
                  focusedBorderColor = myFocusedBorderColor,
                  keys = myKeys,
                  mouseBindings = myMouseBindings,
                  manageHook =  myManageHook <+> namedScratchpadManageHook myScratchPads,
                  layoutHook = gaps myGaps $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ myLayoutHook,
                  logHook = myLogHook,
                  startupHook = myStartupHook
                }`additionalKeysP` myEZKeys
