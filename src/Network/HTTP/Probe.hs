{-# LANGUAGE OverloadedStrings #-}
module Network.HTTP.Probe (
    ProbeArgs (..), startProbe
) where

import           Data.ByteString.Char8    (unpack)
import           Data.CaseInsensitive     (original)
import           Data.Tuple.Extra         ((***))
import           Network.Wai              (Application, rawPathInfo,
                                           requestBody, requestHeaders,
                                           responseLBS)
import           Network.Wai.Handler.Warp (run)
import           System.Random

data ProbeArgs = EchoProbe { port        :: Int
                           , successCode :: Int
                           }
               | ProbeWithErrors { port        :: Int
                                 , successCode :: Int
                                 , errorCode   :: Int
                                 , ratio       :: Int
                                 }
               deriving Show

startProbe :: ProbeArgs -> IO ()
startProbe args = run (port args) . app $ args

app :: ProbeArgs -> Application
app args request sendResponse = do
    let headers = requestHeaders request
    body <- requestBody request
    putStrLn $ "> Request at " ++ unpack (rawPathInfo request)
    mapM_ (print . (original *** unpack)) headers
    putStrLn $ unpack body
    putStrLn "^^^^^^^^^^^^"
    status <- determineStatus args
    putStrLn $ "< Response code: " ++ show status ++ "\n"
    sendResponse $ responseLBS (toEnum status) [] ""

determineStatus :: ProbeArgs -> IO Int
determineStatus pArgs@EchoProbe {} =
    return $ successCode pArgs
determineStatus pArgs@ProbeWithErrors {} = do
    rand <- getStdRandom $ randomR (0, 99)
    return $ if rand < ratio pArgs then errorCode pArgs else successCode pArgs
