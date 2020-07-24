{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import Text.Printf
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy.Char8 as LC (unpack, pack)

data FxChartData = FxChartData { date :: String, close :: Double } deriving (Show, Generic)
data FxChartDataAll = FxChartDataAll { chart :: [FxChartData] } deriving (Show, Generic)

instance FromJSON FxChartDataAll
instance ToJSON FxChartDataAll
instance FromJSON FxChartData
instance ToJSON FxChartData

main = do
{-
  let x = FxChartDataAll { chart = [ FxChartData { date = "0"
                                                 , close = 0 }
                                   , FxChartData { date = "1" 
                                                 , close = 1 } ] }
  let json = LC.unpack $ encode x
  printf "%s\n" json
-}
  json <- getContents
  case decode $ LC.pack json :: Maybe FxChartDataAll of
    Nothing -> print "Parse error"
    Just x -> do let json' = LC.unpack $ encode x
                 printf "%s\n" json'
