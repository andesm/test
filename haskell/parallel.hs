
import Control.Parallel.Strategies

test2 :: [Int] -> IO [Int]
test2 x = return x

test :: Int -> [Int] -> IO [Int] -> IO [Int]
test 0 r s = return r
test n r s = do
  (x:xs) <- s
  let x' = x + 6
  print(x')
  test (n - 1) (x':r) (test2 xs)

main = do
  let b = [1..10]
      b' = test2 b
  a <- test (length b) [] b' `using` parList rseq   
  print(a)


