import Control.Parallel
import Control.Monad
import Text.Printf
 
cutoff = 2
 
fib' :: Int -> Integer
fib' 0 = 0
fib' 1 = 1
fib' n = let l = fib (n-1)
             r = fib (n-2)
         in r `seq` l `par` l + r
 
fib :: Int -> Integer
fib n | n < cutoff = fib' n
      | otherwise  = r `par` l `par` l + r
 where
    l = fib (n-1)
    r = fib (n-2)
 
main = forM_ [0..45] $ \i ->
            printf "n=%d => %d\n" i (fib' i)
