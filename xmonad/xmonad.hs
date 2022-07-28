import XMonad

import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn

import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks  (ToggleStruts(..), manageDocks, docksEventHook , Direction2D (D, L, R, U), docks)
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers (doCenterFloat,doFullFloat,isDialog,isInProperty, isFullscreen,composeOne,(-?>),transience)

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
-- import MyConfig.Help
import MyConfig.StartupHook
import MyConfig.NotifyVolumeChange

myTerminal = "kitty"
myBrowser = "vivaldi-stable"
myModMask = mod4Mask
myAltMask = mod1Mask
myNormalBorderColor = "#302D41"
myFocusedBorderColor = "#7c4dff"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

addNETSupported :: Atom -> X ()
addNETSupported x = withDisplay $ \dpy -> do
  r <- asks theRoot
  a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
  a <- getAtom "ATOM"
  liftIO $ do
    sup <- join . maybeToList <$> getWindowProperty32 dpy a_NET_SUPPORTED r
    when (fromIntegral x `notElem` sup) $
      changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen = do
  wms <- getAtom "_NET_WM_STATE"
  wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
  mapM_ addNETSupported [wms, wfs]

isNotification :: Query Bool
isNotification = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION"

myLogHook = fadeInactiveLogHook fadeAmount
     where fadeAmount = 0.9

myWorkspaces = ["www", "default", "notes","chat","music","video"]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..] -- (,) == \x y -> (x,y)

myManageHook = fullscreenManageHook <+> manageDocks <+> manageSpawn <+> composeAll
      [
        className =? "discord" --> doShift (myWorkspaces !! 3),
        className =? "Ferdium" -->  doShift (myWorkspaces !! 3),
        className =? "Audacious" --> doShift (myWorkspaces !! 4),
        className =? "notion-app-enhanced" --> doShift (myWorkspaces !! 2),
        className =? "obsidian" --> doShift (myWorkspaces !! 2),
        className =? "Vivaldi-stable" --> doShift (head myWorkspaces)
      ]
    <+> composeOne
      [ className =? "Xmessage" -?> doCenterFloat,
        resource =? "desktop_window" -?> doIgnore,
        isDialog -?> doCenterFloat,
        isNotification -?> doFloat,
        isFullscreen -?> doFullFloat,
        transience
      ]

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
          ("M-d", spawn "thunar"),
          -- NamedScratchpad
          ("M-s b", namedScratchpadAction myScratchPads "btop"),
          ("M-s d", namedScratchpadAction myScratchPads "doit"),
          ("M-s t", namedScratchpadAction myScratchPads "terminal"),
          -- Rofi
          ("M-a", spawn "~/.config/rofi/launchers/misc/launcher_column.sh"),
          ("M-S-a", spawn "~/.config/rofi/launchers/misc/launcher_launchpad.sh"),
          ("M-c", spawn "rofi -modi 'clipboard:greenclip print' -show clipboard"),
          -- Audio keys
          ("<XF86AudioStop>", spawn "playerctl stop"),
          ("<XF86AudioPrev>", spawn "playerctl previous"),
          ("<XF86AudioPlay>", spawn "playerctl play-pause"),
          ("<XF86AudioNext>", spawn "playerctl next"),
          ("<XF86AudioMute>", volumeToggle "Master"),
          ("<XF86AudioLowerVolume>", volumeDown "Master"),
          ("<XF86AudioRaiseVolume>", volumeUp "Master"),
          -- Screen Orientation (Script created with arandr)
          ("M-S-<Left>", spawn "~/.screenlayout/Left.sh"),
          ("M-S-<Up>", spawn "~/.screenlayout/Normal.sh"),
          -- XMonad
          ("M-<Left>", prevWS),
          ("M-<Right>", nextWS),
          -- ("M-,", spawn ("echo \""++help++"\" | xmessage -file -")),
          ("C-<Escape>", kill),
          ("M-<Tab>", sendMessage NextLayout),
          ("M-S-q", spawn "xmonad --recompile; xmonad --restart;notify-send 'Xmonad Restart'" ),
            -- Rotate through the available layout algorithms
          ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts),
          ("M-C-g", sendMessage ToggleGaps), -- toggle all gaps
          ("M-S-g", sendMessage $ setGaps [(L, 10), (R, 10), (U, 40), (D, 40)]), -- reset the GapSpec

          ("M-C-t", sendMessage $ IncGap 10 L), -- increment the left-hand gap
          ("M-S-t", sendMessage $ DecGap 10 L), -- decrement the left-hand gap
          ("M-C-y", sendMessage $ IncGap 10 U), -- increment the top gap
          ("M-S-y", sendMessage $ DecGap 10 U), -- decrement the top gap
          ("M-C-u", sendMessage $ IncGap 10 D), -- increment the bottom gap
          ("M-S-u", sendMessage $ DecGap 10 D), -- decrement the bottom gap
          ("M-C-i", sendMessage $ IncGap 10 R), -- increment the right-hand gap
          ("M-S-i", sendMessage $ DecGap 10 R), -- increment the right-hand gap
          
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
  NS "terminal" "kitty --class=scratchterm" (className =? "scratchterm") manageTerm,
  NS "doit" "kitty --class=scrathdoit -e doit" (className =? "scrathdoit") manageTerm,
  NS "btop" "kitty --class=scrathtop -e bpytop" (className =? "scrathtop") manageTerm]
  where
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

main = xmonad $ fullscreenSupport $ docks $ ewmh defaults
defaults = def { 
                  terminal = myTerminal,
                  focusFollowsMouse = False,
                  clickJustFocuses = False,
                  borderWidth = 2,
                  modMask = myModMask,
                  workspaces = myWorkspaces,
                  normalBorderColor = myNormalBorderColor,
                  focusedBorderColor = myFocusedBorderColor,
                  keys = myKeys,
                  mouseBindings = myMouseBindings,
                  manageHook =  myManageHook <+> namedScratchpadManageHook myScratchPads,
                  layoutHook = gaps [(L, 15), (R, 15), (U, 40), (D, 45)] $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ myLayoutHook,
                  logHook = myLogHook,
                  startupHook = myStartupHook >> addEWMHFullscreen
                }`additionalKeysP` myEZKeys
