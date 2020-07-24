import Data.Vector as V (fromList, toList, modify) 
import qualified Data.Vector.Algorithms.Intro as Intro (sortBy)
import qualified Data.Vector.Algorithms.Heap as Heap (sortBy)
import Control.Monad
import Control.Monad.Random

introsort :: (Ord a) => [a] -> [a]
introsort = introsortBy compare

introsortBy :: (a -> a -> Ordering) -> [a] -> [a]
introsortBy cmp = V.toList . V.modify (Intro.sortBy cmp) . V.fromList

heapsort :: (Ord a) => [a] -> [a]
heapsort = heapsortBy compare

heapsortBy :: (a -> a -> Ordering) -> [a] -> [a]
heapsortBy cmp = V.toList . V.modify (Heap.sortBy cmp) . V.fromList


sortTest :: MonadRandom m => m Int
sortTest = do
  x <- replicateM 13 $ getRandomR (1, 10000000000)
  let x' = introsort x
  return $ sum x'

rci :: Int -> [Double] -> Double
rci n x  =
  let r = [1.0 .. ]
      d = sum . map (\a -> ((a !! 0) - (a !! 1)) ^ 2) . zipWith (:) r . sortBy (\xs ys -> compare (ys !! 1) (xs !! 1)) . zipWith (:) r $ map (\a -> a:[]) x
  in (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

rcin :: MonadRandom m => Int -> m  Double
rcin 0 = 0
rcin n = do
  x <- replicateM 13 $ getRandomR (50, 150)
  let r = rci' 100 x
  in r + rcin (n - 1) 
  
main = do
  let r = rcin 100000
  print(r)
