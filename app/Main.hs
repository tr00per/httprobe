module Main where

import           Network.HTTP.Probe (ProbeArgs (EchoProbe, ProbeWithErrors),
                                     startProbe)
import           System.Environment (getArgs)

main :: IO ()
main = do
    pArgs <- extractArgs =<< getArgs
    putStrLn $ "Running " ++ show pArgs
    startProbe pArgs
  where
    extractArgs :: [String] -> IO ProbeArgs
    extractArgs args = case args of
            [port, success] ->
                return $ EchoProbe (read port) (read success)
            [port, successCode, errorCode, ratio] ->
                return $ ProbeWithErrors (read port) (read successCode) (read errorCode) (read ratio)
            _ ->
                error "Pass 2 or 4 arguments: <port> <success code> [<error code> <error ratio>]\n\tport - listen port number\n\tsuccess code, error code - HTTP response codes\n\terror ratio - 0-100 - how often an error should be returned (on avg.)\n"
