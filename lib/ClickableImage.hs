module ClickableImage (main, clickableImage) where
import System.Environment.UTF8 (getArgs)
import System.Process(readProcess)
import ClickAction (clickActions)
import Utils (img)

main = do
 args <- getArgs
 putStr $ uncurry clickableImage $ parseArgs args

clickableImage cmds imgPath = clickActions cmds $ img imgPath

parseArgs args | length args == 4 = (take 3 args, args !! 3)
               | length args == 3 = (take 2 args, args !! 2)
               | length args == 2 = (take 1 args, args !! 1)
               | otherwise = error "Usage: btn1Cmd [btn2Cmd] [btn3Cmd] imgpath"

