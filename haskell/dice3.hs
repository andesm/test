{-
class (Num a, Ord a, Eq a, Random a) => GaEvaluation a where
  
calcEvaluationGa :: (GaEvaluation a, GaData b) => [(a,b)] -> [(a, b)]
calcEvaluationGa x = 
  map (\a -> (calcGa (snd a), snd a)) x

selectionGa :: (GaEvaluation a, GaData b, MonadRandom m) => [(a, b)] -> m (a, b)
selectionGa x = do
  die <-  getRandomR (0, sum $ map fst x)
  let x' =  foldl (\acc y -> (let s = if acc == []
                                      then 0
                                      else let (s, _, _) = head acc
                                           in s
                              in (s + fst y, s , y)):acc) [] $
          sort x
      s = head .
          map (\y -> let (e, s, a) = y in a) $
          filter (\y -> let (e, s, a) = y in s < die && die < e) x'
  return s

selection2Ga :: (GaEvaluation a, GaData b, MonadRandom m) => [(a, b)] -> m ((a, b), (a, b))
selection2Ga x = do
  s1 <- selectionGa x
  s2 <- selectionGa x
  if s1 == s2 
    then selection2Ga x
    else return (s1, s2)

selectAlgorithmGa :: (GaEvaluation a, GaData b, MonadRandom m) => m ([(a, b)] -> m [(a, b)])
selectAlgorithmGa = do
  die <- getRandomR (1, 100)
  let x = if 80 < (die :: Int)
          then (\x -> copyGa x)
          else if die == 1
               then (\x -> mutationGa x)
               else (\x -> crossoverGa x)
  return x

geneticOperatorsGa :: (GaEvaluation a, GaData b, MonadRandom m) => [(a, b)] -> [(a, b)] -> m [(a, b)]
geneticOperatorsGa x y = do
  if length x <= length y
    then return y
    else do (s1, s2) <- selection2Ga x
            algorithmFunftion <- selectAlgorithmGa
            r <- algorithmFunftion [s1, s2]
            let y' = if length y + length r <= length x 
                     then r ++ y
                     else y
            -- traceShow ("b", s1, s2) $ return ()
            geneticOperatorsGa x y'

initGa :: (GaEvaluation a, GaData b, MonadRandom m) => Int -> (m b) -> m [(a, b)]
initGa 0 f = return []
initGa n f = do
  x <- f
  let y = calcGa x
  z <- initGa (n - 1) f
  return ((y, x):z)

-}

