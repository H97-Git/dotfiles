module MyConfig.NotifyVolumeChange (volumeDown,volumeToggle,volumeUp,notifyVolumeChange) where

import XMonad
import System.IO (hClose,hGetContents)
import System.Process (runInteractiveCommand)
import Data.Bool (bool)
import Control.Monad (join, when, void)
import Text.Printf (printf)

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
    { dunstUrgency = UrgencyNormal
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
    printf "dunstify -a NotifyVolumeChange.hs %s %s %s '%s' '%s'"
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
