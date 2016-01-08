import qualified Widgets as W
import Color (Color(..), hexColor)
import WMLog (WMLogConfig(..))
import Utils (colW)

import Graphics.UI.Gtk.General.RcStyle (rcParseString)
import System.Taffybar (defaultTaffybar, defaultTaffybarConfig, barHeight,
                        widgetSpacing, startWidgets, endWidgets)
import System.Taffybar.Battery

import Solarized


main = do
  let cfg = defaultTaffybarConfig { barHeight = 20
                                  , widgetSpacing = 5
                                  }
      font = "Monospace 8"
      fgColor = hexColor $ RGB (0.51, 0.58, 0.59)
      bgColor = hexColor $ RGB (0.0, 0.17, 0.21)
      textColor = hexColor $ RGB (0.58, 0.63, 0.63)

      sep = W.sepW Black 2

      start = [ W.wmLogNew WMLogConfig { titleLength = 30
                                       , wsImageHeight = 20
                                       , titleRows = False
                                       , stackWsTitle = False
                                       , wsBorderColor = RGB (0.6, 0.5, 0.2)
                                       }
              , W.notifyAreaW
              ]
      end = reverse
          [ W.monitorCpuW 50
          , W.monitorMemW 50
          , W.progressBarW
          , W.netStatsW
          , sep
--          , W.netW
--          , sep
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
