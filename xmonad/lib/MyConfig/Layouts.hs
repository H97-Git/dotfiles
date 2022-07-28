module MyConfig.Layouts where

import XMonad
import XMonad.Hooks.ManageDocks  ( avoidStruts)
import XMonad.Layout.NoBorders

-- import XMonad.Layout.Accordion
-- import XMonad.Layout.LayoutModifier
-- import XMonad.Layout.Magnifier
-- import XMonad.Layout.Renamed
-- import XMonad.Layout.ShowWName
-- import XMonad.Layout.Simplest
-- import XMonad.Layout.SimplestFloat
import XMonad.Layout.Grid
-- import XMonad.Layout.GridVariants (Grid (Grid))
-- import XMonad.Layout.LimitWindows (decreaseLimit, increaseLimit, limitWindows)
-- import XMonad.Layout.ResizableTile
import XMonad.Layout.Spiral
-- import XMonad.Layout.SubLayouts
-- import XMonad.Layout.Tabbed
-- import XMonad.Layout.ThreeColumns
-- import XMonad.Layout.WindowNavigation
import XMonad.Layout.MultiToggle (EOT (EOT),mkToggle,single, (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
-- import qualified XMonad.Layout.ToggleLayouts as T (ToggleLayout (Toggle), toggleLayouts)
-- import XMonad.Layout.WindowArranger (WindowArrangerMsg (..), windowArrange)

-- --Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
-- mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
-- mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- -- Below is a variation of the above except no borders are applied
-- -- if fewer than two windows. So a single window has no gaps.
-- mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
-- mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- -- Defining a bunch of layouts, many that I don't use.
-- -- limitWindows n sets maximum number of windows displayed for layout.
-- -- mySpacing n sets the gap size around the windows.
-- tall     = renamed [Replace "tall"]
--            $ smartBorders
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 12
--            $ mySpacing 8
--            $ ResizableTall 1 (3/100) (1/2) []
-- magnify  = renamed [Replace "magnify"]
--            $ smartBorders
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ magnifier
--            $ limitWindows 12
--            $ mySpacing 8
--            $ ResizableTall 1 (3/100) (1/2) []
-- monocle  = renamed [Replace "monocle"]
--            $ smartBorders
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 20 Full
-- floats   = renamed [Replace "floats"]
--            $ smartBorders
--            $ limitWindows 20 simplestFloat
-- grid     = renamed [Replace "grid"]
--            $ smartBorders
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 12
--            $ mySpacing 8
--            $ mkToggle (single MIRROR)
--            $ Grid (16/10)
-- spirals  = renamed [Replace "spirals"]
--            $ smartBorders
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ mySpacing' 8
--            $ spiral (6/7)
-- threeCol = renamed [Replace "threeCol"]
--            $ smartBorders
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 7
--            $ ThreeCol 1 (3/100) (1/2)
-- threeRow = renamed [Replace "threeRow"]
--            $ smartBorders
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 7
--            -- Mirror takes a layout and rotates it by 90 degrees.
--            -- So we are applying Mirror to the ThreeCol layout.
--            $ Mirror
--            $ ThreeCol 1 (3/100) (1/2)
-- tabs     = renamed [Replace "tabs"]
--            -- I cannot add spacing to this layout because it will
--            -- add spacing between window and tabs which looks bad.
--            $ tabbed shrinkText myTabTheme
-- tallAccordion  = renamed [Replace "tallAccordion"]
--            $ Accordion
-- wideAccordion  = renamed [Replace "wideAccordion"]
--            $ Mirror Accordion

-- -- setting colors for tabs layout and tabs sublayout.
-- myTabTheme = def { 
--                    activeColor         = color15
--                  , inactiveColor       = color08
--                  , activeBorderColor   = color15
--                  , inactiveBorderColor = colorBack
--                  , activeTextColor     = colorBack
--                  , inactiveTextColor   = color16
--                  }
-- mkToggle (NBFULL ?? NOBORDERS ?? EOT)
myLayoutHook = avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) ( tiled ||| layoutSpiral  ||| Mirror tiled ||| layoutGrid ||| noBorders Full )
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2
    -- Percent of screen to increment by when resizing panes
    delta = 1 / 100
    layoutSpiral = spiral (6 / 7)
    layoutGrid = Grid
