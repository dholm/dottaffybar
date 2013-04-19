module NotifyArea (notifyAreaW) where

import System.Taffybar.FreedesktopNotifications (notifyAreaNew,
                                                 defaultNotificationConfig)

notifyAreaW = notifyAreaNew defaultNotificationConfig
