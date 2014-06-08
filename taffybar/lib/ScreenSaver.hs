module ScreenSaver(screenSaverW) where
import Label (labelW)
import Utils(chompFile, padL, readInt, readProc, millisTime)

import Control.Concurrent (forkIO, threadDelay, readChan, writeChan, newChan)
import Control.Monad (void)
import Data.Maybe (fromMaybe)
import System.Process (system)

screenSaverBrightness = 5

overrideFile = "/tmp/screen-saver-override"

checkDelayMillis = 1 * 1000
idleTimeoutMillis = 10 * 60 * 1000

screenSaverW = do
  chan <- newChan
  writeChan chan $ "????"
  forkIO $ checkScreenSaver chan False 0 Nothing
  labelW $ readChan chan

checkScreenSaver chan prevState prevXidle prevStartTimeMillis = do
  xidle <- getXidle
  override <- getOverride
  nowMillis <- millisTime
  let runningMillis = nowMillis - fromMaybe nowMillis prevStartTimeMillis

  let state = case override of
                "off" -> False
                "on"  -> runningMillis < 3000 || xidle > prevXidle
                _     -> xidle > idleTimeoutMillis
  let startTime = if state
                  then Just $ fromMaybe nowMillis prevStartTimeMillis
                  else Nothing

  let timeoutS = (idleTimeoutMillis - xidle) `div` 1000
  let msg = padL ' ' 4 $ case override of
                            "off" -> "off"
                            "on"  -> "on"
                            _     -> if state then "SCRN" else show timeoutS

  writeChan chan $ msg ++ "\nidle"
  if state && not prevState then screenSaverOn else return ()
  if not state && prevState then screenSaverOff else return ()

  if override == "on" && not state then writeOverride "" else return ()

  threadDelay $ checkDelayMillis * 10^3
  checkScreenSaver chan state xidle startTime


getOverride = chompFile overrideFile

writeOverride state = writeFile overrideFile $ state ++ "\n"

screenSaverOn = void $ system $ "brightness " ++ show screenSaverBrightness
screenSaverOff = void $ system "brightness 100"

getXidle :: IO Integer
getXidle = fmap (fromMaybe 0 . readInt) $ readProc ["xprintidle"]
