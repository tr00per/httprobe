{-# LANGUAGE OverloadedStrings #-}
module Network.HTTP.Probe (
    startProbe
) where

import           Data.ByteString.Char8    (unpack)
import           Data.CaseInsensitive     (original)
import           Data.Tuple.Extra         ((***))
import           Network.HTTP.Types       (Status)
import           Network.Wai              (Application, rawPathInfo,
                                           requestBody, requestHeaders,
                                           responseLBS)
import           Network.Wai.Handler.Warp (run)

startProbe :: Int -> Int -> IO ()
startProbe port = run port . app

app :: Int -> Application
app status request sendResponse = do
    let headers = requestHeaders request
    body <- requestBody request
    putStrLn $ "---- endpoint: " ++ unpack (rawPathInfo request)
    mapM_ (print . (original *** unpack)) headers
    putStrLn $ unpack body
    putStrLn "^^^^^^^^^^^^\n"
    sendResponse $ responseLBS (toEnum status) [] ""
