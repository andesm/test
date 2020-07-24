import Control.Monad
import Control.Monad.Random
import Data.List

sumDice :: (MonadRandom m) => Int -> m Int
sumDice n = liftM sum $ replicateM n $ getRandomR (1,6)

statDice :: (MonadRandom m) => Int -> m [(Int,Int)]
statDice n = do
  liftM histogram $ replicateM n $ sumDice 2
  where
    histogram :: (Ord x) => [x] -> [(x,Int)]
    histogram = map (\xs -> (head xs, length xs)) . group . sort

pureStat :: [(Int, Int)]  
pureStat = evalRand (statDice 360000) (mkStdGen 890135)

main :: IO ()
main = do
  print pureStat
  statDice 360000 >>= print
