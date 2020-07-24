import Data.Function.Memoize

fib' :: Int -> Int
fib' n = memoize fib2 n

fib2 :: Int -> Int
fib2 0 = 0
fib2 1 = 1
fib2 n = fib2 (n-1) + fib2 (n-2)

test1 :: Int -> Int
test1 x = fib2 x

main = do
  let a = test1 43
  print (a)
  let a = test1 43
  print (a)
  let a = test1 43
  print (a)
  let a = test1 43
  print (a)
