{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import qualified FxOandaAPI   as Foa

main = do
  print =<< Foa.getOandaPosition
  print =<< Foa.setOandaOrders 10 "sell"
  print =<< Foa.getOandaPosition
  print =<< Foa.setOandaOrders 20 "buy"
  print =<< Foa.getOandaPosition
  print =<< Foa.setOandaOrders 40 "sell"
  print =<< Foa.getOandaPosition


