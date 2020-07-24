loop :: Int -> Int
loop 0 = 0
loop n = n + loop (n-1)

main = do
  let a = loop 100000000
  print (a)
