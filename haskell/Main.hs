import Control.Parallel
import Data.List

qsort :: (Ord a) =>  [a] -> [a]
qsort []     = []
qsort (p:xs) = let lt   = qsort [x | x <- xs, x < p]
                   gteq = qsort [x | x <- xs, x >= p]
               in lt `par` gteq `par` lt ++ [p] ++ gteq

main = print . head . sort $ reverse [1..10000000]

