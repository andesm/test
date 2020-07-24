{-# LANGUAGE BangPatterns #-}

main = do
  let a = sum [1..100000000]
  print (a)
