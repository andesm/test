import Data.List
import Control.Monad
import Control.Monad.State
import Control.Monad.Random
import Debug.Trace 

data FxSetting = FxSetting { fsMinProfit :: Double
                           , fsRciShort  :: Int
                           , fsRciMiddle :: Int
                           , fsRciLong   :: Int
                           , fsSmaShort  :: Int
                           , fsSmaMiddle :: Int
                           , fsSmaLong   :: Int
                           , fsSimChart  :: Int } deriving (Show)

crossoverFxSetting :: (MonadRandom m) => [(Double, FxSetting)] -> m [(Double, FxSetting)]
crossoverFxSetting x = do
  die <- replicateM 8 $ getRandomR (True, False)
  let x' = map snd $ take 2 x
      a = (x' !! 0)
      b = (x' !! 1)
  return ([(0, FxSetting { fsMinProfit = choice1 die 0 (fsMinProfit a) (fsMinProfit b)
                    , fsRciShort  = choice1 die 1 (fsRciShort  a) (fsRciShort  b)
                    , fsRciMiddle = choice1 die 2 (fsRciMiddle a) (fsRciMiddle b)
                    , fsRciLong   = choice1 die 3 (fsRciLong   a) (fsRciLong   b)
                    , fsSmaShort  = choice1 die 4 (fsSmaShort  a) (fsSmaShort  b)
                    , fsSmaMiddle = choice1 die 5 (fsSmaMiddle a) (fsSmaMiddle b)
                    , fsSmaLong   = choice1 die 6 (fsSmaLong   a) (fsSmaLong   b)
                    , fsSimChart  = choice1 die 7 (fsSimChart  a) (fsSimChart  b) }),
           (0, FxSetting { fsMinProfit = choice2 die 0 (fsMinProfit a) (fsMinProfit b)
                     , fsRciShort  = choice2 die 1 (fsRciShort  a) (fsRciShort  b)
                     , fsRciMiddle = choice2 die 2 (fsRciMiddle a) (fsRciMiddle b)
                     , fsRciLong   = choice2 die 3 (fsRciLong   a) (fsRciLong   b)
                     , fsSmaShort  = choice2 die 4 (fsSmaShort  a) (fsSmaShort  b)
                     , fsSmaMiddle = choice2 die 5 (fsSmaMiddle a) (fsSmaMiddle b)
                     , fsSmaLong   = choice2 die 6 (fsSmaLong   a) (fsSmaLong   b)
                     , fsSimChart  = choice2 die 7 (fsSimChart  a) (fsSimChart  b)})])
        where choice1 die d a b = if die !! d then a else b
              choice2 die d a b = if die !! d then b else a

class Ga a where
  copyGa :: MonadRandom m => [(Double, a)] -> m [(Double, a)]
  mutationGa :: MonadRandom m => [(Double, a)] -> m [(Double, a)]
  crossoverGa :: MonadRandom m => [(Double, a)] -> m [(Double, a)]

instance Ga FxSetting where
  crossoverGa a = crossoverFxSetting  a

