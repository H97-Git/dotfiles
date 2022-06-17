import System.IO (hClose,hGetContents)
import System.Process (runInteractiveCommand)
import XMonad
import XMonad.Config.Kde
import XMonad.Config.Azerty

import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn

import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks  (ToggleStruts(..), manageDocks, docksEventHook , Direction2D (D, L, R, U), docks)
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers (doCenterFloat,doFullFloat,isDialog, isKDETrayWindow,isInProperty, isFullscreen,composeOne,(-?>),transience)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce (spawnOnce,spawnOnOnce)

import XMonad.Layout.Fullscreen  (fullscreenSupport,fullscreenManageHook )
import XMonad.Layout.Gaps  (gaps, Direction2D (D, L, R, U), GapMessage (DecGap, IncGap, ToggleGaps), gaps, setGaps)
import XMonad.Layout.NoBorders (smartBorders,hasBorder)
import XMonad.Layout.Spacing (Border (Border), spacingRaw)
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))


import Data.Bool (bool)
import Data.Maybe (maybeToList, fromJust)
import Control.Monad (join, when, void)
import Graphics.X11.ExtraTypes.XF86 (xF86XK_AudioLowerVolume, xF86XK_AudioMute, xF86XK_AudioNext, xF86XK_AudioPlay, xF86XK_AudioPrev, xF86XK_AudioRaiseVolume, xF86XK_AudioStop)
import Graphics.X11.ExtraTypes.XorgDefault
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Text.Printf (printf)

import Colors.MyColors
import Layouts.MyLayouts

myTerminal :: String
myTerminal = "kitty"

myBrowser :: String
myBrowser = "vivaldi-stable"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth = 1

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

isOverride :: Query Bool
isOverride = isInProperty "_NET_WM_WINDOW_TYPE" "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE"

isPlasmaNotify :: Query Bool
isPlasmaNotify = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DESKTOP"

-- https://github.com/tjnt/my-xmonad/blob/main/src/xmonad.hs
spawnWithOutput :: String -> X String
spawnWithOutput cmd = io $ do
    (hin, hout, herr, _) <- runInteractiveCommand cmd
    out <- hGetContents hout
    when (out == out) $ return () -- wait for exit
    hClose hin >> hClose hout >> hClose herr
    return out

spawnAndWait :: String -> X ()
spawnAndWait cmd = void $ spawnWithOutput cmd

data Urgency = UrgencyLow
             | UrgencyNormal
             | UrgencyCritical
  deriving (Show,Eq)

data DunstOption = DunstOption
    { dunstUrgency      :: Urgency
    , dunstTransient    :: Bool
    , dunstOtherOptions :: String
    }
  deriving (Show,Eq)

dunstDefaultOption :: DunstOption
dunstDefaultOption = DunstOption
    { dunstUrgency = UrgencyLow
    , dunstTransient = False
    , dunstOtherOptions = ""
    }

dunstifyIndicator :: String -> String -> String -> X ()
dunstifyIndicator val = dunstify
    dunstDefaultOption
        { dunstUrgency = UrgencyLow
        , dunstTransient = True
        , dunstOtherOptions = printf "-h int:value:%s" val
        }

dunstify :: DunstOption -> String -> String -> X ()
dunstify opt summary body = spawn $
    printf "dunstify -a xmonad %s %s %s '%s' '%s'"
        urgency transient options summary body
  where
    urgency = "-u " <> case dunstUrgency opt of
        UrgencyLow      -> "low"
        UrgencyNormal   -> "normal"
        UrgencyCritical -> "normal"
    transient = if dunstTransient opt then "-h int:transient:1" else ""
    options = dunstOtherOptions opt

volumeToggle, volumeUp, volumeDown :: String -> X ()
volumeToggle target =
    spawnAndWait (printf "amixer -q set %s toggle" target) >>
    notifyVolumeChange target
volumeUp target =
    spawnAndWait (printf "amixer -q set %s 2%%+ unmute" target) >>
    notifyVolumeChange target
volumeDown target =
    spawnAndWait (printf "amixer -q set %s 2%%- unmute" target) >>
    notifyVolumeChange target

notifyVolumeChange :: String -> X ()
notifyVolumeChange target = do
    w <- words . last . lines
        <$> spawnWithOutput (printf "amixer get %s" target)
    when (length w == 6) $
        let (v, t) = (trimVol (w!!4), trimMut (w!!5))
            msg = printf "%s volume%s" target (bool " [mute]" "" (t=="on"))
         in dunstifyIndicator v msg ""
  where
    trimVol = takeWhile (/='%') . tail
    trimMut = takeWhile (/=']') . tail
--------------------------------------------------------------------------
myLogHook = fadeInactiveLogHook fadeAmount
     where fadeAmount = 0.9

myWorkspaces = ["www", "default", "notes", "sys","other_0","other_1", "chat","music"]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..] -- (,) == \x y -> (x,y)

myManageHook = fullscreenManageHook <+> manageDocks <+> manageSpawn <+> composeAll
      [
        className =? "plasmashell" --> doIgnore <+> hasBorder False >> doFloat,
        className =? "krunner" --> doIgnore,
        className =? "discord" --> doShift (myWorkspaces !! 6),
        className =? "Ferdium" -->  doShift (myWorkspaces !! 6),
        className =? "Audacious" --> doShift (myWorkspaces !! 7),
        className =? "notion-app-enhanced" --> doShift (myWorkspaces !! 2),
        className =? "obsidian" --> doShift (myWorkspaces !! 2),
        className =? "Vivaldi-stable" --> doShift (head myWorkspaces)
      ]
    <+> composeOne
      [ className =? "Xmessage" -?> doCenterFloat,
        className =? "kruler" -?> doIgnore,
        className =? "lattedock" -?> doIgnore,
        className =? "latte-dock" -?> doIgnore,
        className =? "plasma.emojier" -?> doFloat,
        resource =? "desktop_window" -?> doIgnore,
        resource =? "kdesktop" -?> doIgnore,
        isDialog -?> doCenterFloat,
        isKDETrayWindow -?> doIgnore,
        isNotification -?> doFloat,
        isPlasmaNotify -?> doFloat,
        isFullscreen -?> doFullFloat,
        transience
      ]

myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    [
      ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
      -- Restart xmonad
      ((modm .|. shiftMask, xK_q), spawn "xmonad --recompile; xmonad --restart;notify-send 'Xmonad Restart'"),
      ((modm, xK_Tab), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_Tab ), setLayout $ XMonad.layoutHook conf),
      -- Swap the focused window and the master window
      ((modm, xK_Return), windows W.swapMaster),
      ((controlMask .|. myAltMask, xK_Escape  ), spawn "xkill"),
      ((controlMask , xK_Escape  ), kill),
      ((modm .|. shiftMask, xK_h ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myEZKeys =
        [
          ("M-a", spawn "~/.config/rofi/launchers/misc/launcher_column.sh"),
          ("M-S-a", spawn "~/.config/rofi/launchers/misc/launcher_launchpad.sh"),
          -- ("M-S-a", spawn (xmessage myFerdiSleep)),
          ("M-b", namedScratchpadAction scratchpads "htop"),
          ("<Print>", spawn "flameshot gui"),
          -- Audio keys
          ("<XF86AudioStop>", spawn "playerctl stop"),
          ("<XF86AudioPrev>", spawn "playerctl previous"),
          ("<XF86AudioPlay>", spawn "playerctl play-pause"),
          ("<XF86AudioNext>", spawn "playerctl next"),
          ("<XF86AudioMute>", volumeToggle "Master"),
          ("<XF86AudioLowerVolume>", volumeDown "Master"),
          ("<XF86AudioRaiseVolume>", volumeUp "Master"),
          -- ("<XF86AudioMute>", spawn "amixer -D pulse set Master toggle"),
          -- ("<XF86AudioLowerVolume>", spawn "amixer -D pulse set Master 2%- unmute"),
          -- ("<XF86AudioRaiseVolume>", spawn "amixer -D pulse set Master 2%+ unmute"),
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
          ("M-n", sendMessage $ DecGap 10 R), -- decrement the right-hand gap
          -- Resize viewed windows to the correct size
          ("M-n", refresh),
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
          ("M-t", withFocused $ windows . W.sink),
          ("M-S-s", spawn(myTerminal ++ " -e bash -c 'xprop & sleep 60'")),
          ("M-<Left>", prevWS),
          ("M-<Right>", nextWS)
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


scratchpads = [
  -- run htop in xterm, find it by title, use default floating window placement
    NS "htop" "kitty -e htop" (title =? "htop") defaultFloating ,
-- run stardict, find it by class name, place it in the floating window
-- 1/6 of screen width from the left, 1/6 of screen height
-- from the top, 2/3 of screen width by 2/3 of screen height
    NS "stardict" "stardict" (className =? "Stardict")
        (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) ,
-- run gvim, find by role, don't float
    NS "notes" "gvim --role notes ~/notes.txt" (role =? "notes") nonFloating ] where role = stringProperty "WM_WINDOW_ROLE"
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

ws id = myWorkspaces !! (id - 1)

myStartupHook = do
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  spawnOnce "xrandr --output DP-4 --primary --rate 144"
  spawnOnce "xrandr --output DP-3 --auto --right-of DP-4"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "picom --experimental-backends -b"
  spawnOnce "dunst"
  spawnOnce "~/Documents/Scripts/setIconsThemes.sh"
  spawnOnce "sleep 10 && ~/.config/polybar/launch.sh"
  spawnOnce "pamac-tray-plasma"
  spawnOnce "sleep 10 && audacious"
  spawnOnOnce (ws 3) "notion-app-enhanced"
  spawnOnOnce (ws 3) "obsidian"
  spawnOnOnce (ws 7) "discocss"
  spawnOnOnce (ws 7) "sleep 10 && Ferdium"
main = do
  xmonad $
    fullscreenSupport $
      docks $
        ewmh $
          kde4Config
            { terminal = myTerminal,
              focusFollowsMouse = myFocusFollowsMouse,
              clickJustFocuses = myClickJustFocuses,
              borderWidth = myBorderWidth,
              modMask = myModMask,
              workspaces = myWorkspaces,
              normalBorderColor = myNormalBorderColor,
              focusedBorderColor = myFocusedBorderColor,

              keys = myKeys,
              mouseBindings = myMouseBindings,

              manageHook = (myManageHook <+> manageHook kde4Config) <+> namedScratchpadManageHook scratchpads,
              layoutHook = gaps [(L, 10), (R, 10), (U, 40), (D, 40)] $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ smartBorders myLayoutHook,
              logHook = myLogHook,
              startupHook = myStartupHook >> addEWMHFullscreen
            }`additionalKeysP` myEZKeys

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'super'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch Kitty",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
