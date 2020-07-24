{-# LANGUAGE BangPatterns #-}

main = do
  let (a, _) = foldl (\(!a, !s) !i -> (a + s * i, -s)) (0, 1) [0..100000000 :: Int]
  print (a)
