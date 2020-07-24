import Data.List

rSort :: (Ord a) => [a] -> [a]
rSort = sortBy (flip compare)

rci' :: Int -> [Double] -> Double
rci' n x  =
  let r = map (\y -> (fromIntegral y):[]) [1..n]
      --- [[1,5,5],[2,4,4],[3,3,3],[4,2,2],[5,1,1]]
      d = sum . map (\a -> ((a !! 1) - (a !! 2)) ^ 2) . flip (zipWith (++)) r . rSort . flip (zipWith (++)) r $ map (\a -> a:[]) x 
  in (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

rci :: Int -> [Double] -> Double
rci n x  =
  let r = [1.0 .. (fromIntegral n)]
      --- [[1,5,5],[2,4,4],[3,3,3],[4,2,2],[5,1,1]]
      d = sum . map (\a -> ((a !! 0) - (a !! 1)) ^ 2) . zipWith (:) r . sortBy (\xs ys -> compare (ys !! 1) (xs !! 1)) . zipWith (:) r $ map (\a -> a:[]) x
  in (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

rcin :: Int -> Double
rcin 0 = 0
rcin n =
  let r = rci' 500 [(fromIntegral n) .. ((fromIntegral n) + 10000)]
  in r + rcin (n - 1) 
  
main = do
  let r = rcin 100000
  print(r)
