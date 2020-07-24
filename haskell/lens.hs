{-# LANGUAGE TemplateHaskell #-}

import Control.Lens

data Point = Point { 
    _x :: Double
  , _y :: Double
  } deriving Show

data Circle = Circle { 
    _center :: Point
  , _radius :: Double 
  } deriving Show

makeLenses ''Point
makeLenses ''Circle
