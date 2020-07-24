import Data.Vector as V (fromList, toList, modify) 
import qualified Data.Vector.Algorithms.Intro as Intro (sortBy)
import qualified Data.Vector.Algorithms.Heap as Heap (sortBy)
import Data.List
import Control.Monad
import System.Random
import Control.Parallel

introsort :: (Ord a) => [a] -> [a]
introsort = introsortBy compare

introsortBy :: (a -> a -> Ordering) -> [a] -> [a]
introsortBy cmp = V.toList . V.modify (Intro.sortBy cmp) . V.fromList

heapsort :: (Ord a) => [a] -> [a]
heapsort = heapsortBy compare

heapsortBy :: (a -> a -> Ordering) -> [a] -> [a]
heapsortBy cmp = V.toList . V.modify (Heap.sortBy cmp) . V.fromList

qsort :: (Ord a ) => [a] -> [a]
qsort []     = []
qsort (p:xs) = smaller `par` larger `par` larger ++ [p] ++ smaller 
  where
    smaller = qsort [x | x <- xs, x < p]
    larger  = qsort [x | x <- xs, x >= p]


rci4 :: Int -> [Double] -> Double
rci4 n x  =
  let r = [1 .. ]
      d = sum . map (\(a, b) -> (a - b) ^ 2) . zipWith (\a (a', b') -> (a, b')) r . qsort $ zip x r 
  in (1.0 - (6.0 * fromIntegral d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

rci3 :: Int -> [Double] -> Double
rci3 n x  =
  let r  = [1..n]
      r' = reverse [1..n]
      d = sum . map (\(a, b) -> (a - b) ^ 2) . zipWith (\a (a', b') -> (a, b')) r' . sort $ zip x r 
  in (1 - (6 * fromIntegral d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1))) * 100

rci2 :: Int -> [Double] -> Double
rci2 n x  =
  let r = [1 .. ] :: [Integer]
      d = sum . map (\(a, b) -> (a - b) ^ 2) . zipWith (\(a, b) (a', b') -> (b, b')) (zip  r r) . sortBy (\(a, b) (a', b') -> compare b' b) $ zip x r 
  in (1.0 - (6.0 * fromIntegral d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

rci1 :: Int -> [Double] -> Double
rci1 n x  =
  let r = [1..]
      d = sum . map (\a -> ((a !! 0) - (a !! 1)) ^ 2) . zipWith (:) r . sortBy (\xs ys -> compare (ys !! 1) (xs !! 1)) . zipWith (:) r $ map (\a ->  a:[]) x
  in (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

{-
rcin :: Int -> Double
rcin 0 = 0
rcin n = 
  let r = rci' 100 [(fromIntegral  n) .. 150 + (fromIntegral n)]
  in r + rcin (n - 1)
  
main = do
  let r = rcin 1000000
  print(r)
-}


rcin :: Int -> Double
rcin 0 = 0
rcin n = do
  rci1 1000 [(fromIntegral n)..(fromIntegral n) + 1000] + rcin (n - 1)
  
main = print $ rcin 100000

