import qualified Widgets as W
import Color (Color(..), hexColor)
import WMLog (WMLogConfig(..))
import Utils (colW)

import Graphics.UI.Gtk.General.RcStyle (rcParseString)
import System.Taffybar (defaultTaffybar, defaultTaffybarConfig,
                        barHeight, barPosition, widgetSpacing, startWidgets,
                        endWidgets, Position(Top, Bottom))
import System.Taffybar.Battery

import Data.Functor ((<$>))
import System.Environment (getArgs)

import Solarized

profile = profileHDPlus

profileHDPlus = P { height = 20
                  , spacing = 4
                  , titleLen = 30
                  , typeface = "Monospace"
                  , fontSizePt = 8.0
                  , graphWidth = 30
                  , workspaceImageHeight = 16
                  }

main = do
  isBot <- elem "--bottom" <$> getArgs
  let cfg = defaultTaffybarConfig { barHeight = height profile
                                  , widgetSpacing = spacing profile
                                  , barPosition = if isBot then Bottom else Top
                                  }
      font = (typeface profile) ++ " " ++ show (fontSizePt profile)
      fgColor = hexColor $ RGB (0.51, 0.58, 0.59)
      bgColor = hexColor $ RGB (0.0, 0.17, 0.21)
      textColor = hexColor $ RGB (0.58, 0.63, 0.63)

      sep = W.sepW Black 2
      klompChars = 32

      start = [ W.wmLogNew WMLogConfig { titleLength = titleLen profile
                                       , wsImageHeight = workspaceImageHeight profile
                                       , titleRows = False
                                       , stackWsTitle = False
                                       , wsBorderColor = RGB (0.6, 0.5, 0.2)
                                       }
              , W.notifyAreaW
              ]
      end = reverse
          [ W.monitorCpuW $ graphWidth profile
          , W.monitorMemW $ graphWidth profile
          , W.progressBarW
          , W.netStatsW
          , sep
--          , W.netW
--          , sep
--          , W.widthScreenWrapW 0.159375 =<< W.klompW klompChars
--          , W.volumeW
--          , W.micW
          , W.pidginPipeW $ barHeight cfg
          , W.thunderbirdW (barHeight cfg) Green Black
--          , W.cpuScalingW
--          , W.cpuFreqsW
--          , W.fanW
          , W.brightnessW
--          , W.pingMonitorW "www.google.com" "G"
--          , W.openvpnW "somevpn" "svpn"
--          , W.tpBattStatW $ barHeight cfg
          , batteryBarNew defaultBatteryConfig 10
          , sep
          , W.clockW
          , sep
          , W.systrayW
          ]

  rcParseString $ ""
        ++ "style \"default\" {"
        ++ "  font_name = \"" ++ font ++ "\""
        ++ "  bg[NORMAL] = \"" ++ bgColor ++ "\""
        ++ "  fg[NORMAL] = \"" ++ fgColor ++ "\""
        ++ "  text[NORMAL] = \"" ++ textColor ++ "\""
        ++ "}"
  defaultTaffybar cfg { startWidgets = start
                      , endWidgets = end
                      }

data Profile = P { height :: Int
                 , spacing :: Int
                 , titleLen :: Int
                 , typeface :: String
                 , fontSizePt :: Double
                 , graphWidth :: Int
                 , workspaceImageHeight :: Int
                 }
