
import Control.Parallel.Strategies

data TestData = TestData
  { testData :: Int }

fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = let l = fib (n-1)
            r = fib (n-2)
         in l + r

main = do
  let a = map (\x -> TestData { testData = x}) [35..44]
      b = maximum $ (map (\x -> fib $ testData x) a `using` parList rpar)
  print(b)
  return ()
  


