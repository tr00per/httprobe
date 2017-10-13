module Main where

import           Network.HTTP.Probe (startProbe)
import           System.Environment (getArgs)

main :: IO ()
main = do
    port:_ <- getArgs
    putStrLn ("Running on " ++ port)
    startProbe (read port )
