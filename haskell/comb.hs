module Main where

comb :: Int -> [Int] -> [[Int]]
comb _ [] = []
comb 1 xs = [[x] | x <- xs]
comb n (x:xs) = [x:y | y <- comb (n-1) xs] ++ comb n xs

main::IO()
main = print (comb 3 ([1..5]::[Int]))

