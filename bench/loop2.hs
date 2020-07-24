main = do
  let a = foldl (+) 0 [0..100000000 :: Int]
  print (a)
