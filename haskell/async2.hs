import Control.Parallel
import Control.Concurrent
import Control.Concurrent.Async
import Debug.Trace
import Text.Printf

fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = let l = fib (n-2)
            r = fib (n-1)
        in l + r

threadA :: Int -> IO (Int)
threadA c = do
  printf "%d\n" c
  return (fib c)

main = do
  let x = [40, 40, 40, 40]
{-      
      x' = map fib x
-}
  x' <- sequenceA . map (\a -> do a' <- a
                                  r <- wait a'
                                  return r) $ map (\c -> do asyncBound (threadA c)) x
  traceShow(x') $ return ()
  return ()
