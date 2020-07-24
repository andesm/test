{-# LANGUAGE OverloadedStrings #-}

import Network.Wreq

getOandaOrders :: [FormParam]
getOandaOrders = 
  ["num" := 3 :: Int, "str" := "wat" :: String]
