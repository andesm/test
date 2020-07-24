{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module OandaOrders
  ( TradeOpened (..)
  , OrdersBody (..)
  , getOandaOrders
  ) where 

import GHC.Generics (Generic)
import Network.Wreq
import Control.Lens
import Data.Aeson.Lens
import Data.Map as Map
import Data.Aeson
import Data.Aeson.TH
  

