import Data.List
import Control.Monad
import Control.Monad.State
import Control.Monad.Random
import Debug.Trace 

data FxSetting = FxSetting { a :: Int } deriving (Show, Ord, Eq)

class GaData a where
  createGaData :: a -> a

instance GaData FxSetting where
  createGaData _ = FxSetting { a = 0 }
  

