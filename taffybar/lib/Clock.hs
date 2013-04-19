module Clock(clockW) where
import Solarized (solarizedOrange)
import System.Taffybar.SimpleClock (textClockNew)
import Utils (defaultDelay)

clockFace :: String
clockFace = "<span fgcolor='" ++ solarizedOrange ++ "'>%a %b %_d %Y %H:%M:%S</span>"

clockW = textClockNew Nothing clockFace defaultDelay
