module Main where

import           Network.HTTP.Probe (startProbe)
import           System.Environment (getArgs)

main :: IO ()
main = do
    (port, status) <- extractArgs =<< getArgs
    putStrLn ("Running on " ++ port ++ ", will return HTTP " ++ status)
    startProbe (read port) (read status)
  where
    extractArgs :: [String] -> IO (String, String)
    extractArgs args = if length args /= 2
        then error "Give 2 arguments: port and code. For example: 8080 200"
        else let port:status:_ = args in return (port, status)
