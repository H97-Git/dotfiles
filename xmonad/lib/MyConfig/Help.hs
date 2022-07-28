module MyConfig.Help where

import XMonad

help :: String
help = unlines ["The default modifier key is 'super'. Default keybindings:",
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
          ("M-,", spawn ("echo \""++help++"\" | xmessage -file -")),
          ("C-<Escape>", kill),
          -- Screen Orientation (Script created with arandr)
          ("M-S-<Left>", spawn "~/.screenlayout/Left.sh"),
          ("M-S-<Up>", spawn "~/.screenlayout/Normal.sh"),
          -- XMonad
          ("M-<Left>", prevWS),
          ("M-<Right>", nextWS),
 
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