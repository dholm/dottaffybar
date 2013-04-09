module Widgets(
  clickableActions, clickableAsync, clickableLeftAsync,
  clickable, clickableLeft,
  label, image, pollingImageNew
) where
import Utils (defaultDelay)

import System.Taffybar.Widgets.PollingLabel (pollingLabelNew)
import Graphics.UI.Gtk (
  imageNew, imageNewFromFile, imageSetFromFile,
  eventBoxNew, eventBoxSetVisibleWindow, onButtonPress,
  containerAdd, toWidget, on, realize, widgetShowAll, postGUIAsync)
import Graphics.UI.Gtk.Gdk.Events (
  eventButton, MouseButton(LeftButton, MiddleButton, RightButton))
import System.Process (system)
import Control.Monad.Trans (liftIO)
import Control.Monad (forever, void)
import Control.Concurrent (forkIO, threadDelay)
import Control.Exception as E (catch, IOException)

maybeRun Nothing = return ()
maybeRun (Just cmd) = void $ forkIO $ void $ system cmd

handleClickAction lAction mAction rAction evt = do
  case (eventButton evt) of
    LeftButton -> lAction
    MiddleButton -> mAction
    RightButton -> rAction
  return False

clickableActions lAction mAction rAction w = do
  ebox <- eventBoxNew
  onButtonPress ebox $ handleClickAction lAction mAction rAction
  eventBoxSetVisibleWindow ebox False
  containerAdd ebox w
  widgetShowAll ebox
  return $ toWidget ebox

clickableAsync lCmdA mCmdA rCmdA w = clickableActions l m r w
  where (l,m,r) = (maybeRun =<< lCmdA, maybeRun =<< mCmdA, maybeRun =<< rCmdA)

clickableLeftAsync cmdAsync w = clickableAsync l m r w
  where (l,m,r) = (cmdAsync, return Nothing, return Nothing)
clickable lCmd mCmd rCmd w = clickableAsync l m r w
  where (l,m,r) = (return lCmd, return mCmd, return rCmd)
clickableLeft cmd w = clickableAsync l m r w
  where (l,m,r) = (return $ Just cmd, return Nothing, return Nothing)

image file = do
  img <- imageNewFromFile file
  return $ toWidget img


pollingImageNew cmd = do
  img <- imageNew
  on img realize $ do
    forkIO $ forever $ do
      let tryUpdate = do
            file <- cmd
            postGUIAsync $ imageSetFromFile img file
      E.catch tryUpdate ignoreIOException
      threadDelay $ floor (defaultDelay * 1000000)
    return ()
  return img

ignoreIOException :: IOException -> IO ()
ignoreIOException _ = return ()

label printer = do
  w <- pollingLabelNew "---" defaultDelay printer
  widgetShowAll w
  return w
