import Data.List
import Control.Monad
import Control.Monad.State
import Control.Monad.Random
import Debug.Trace 

class (Ord a) => GaData a where
  copyGa :: (GaEvaluation b, MonadRandom m) => [(b, a)] -> m [(b, a)]
  mutationGa :: (GaEvaluation b, MonadRandom m) => [(b, a)] -> m [(b, a)]
  crossoverGa :: (GaEvaluation b, MonadRandom m) => [(b, a)] -> m [(b, a)]
  calcGa :: GaEvaluation b => a -> b

class (Num a, Ord a, Eq a, Random a) => GaEvaluation a where
  calcEvaluationGa :: (GaData b) => [(a,b)] -> [(a, b)]
  selectionGa :: (GaData b, MonadRandom m) => [(a, b)] -> m (a, b)
  selection2Ga :: (GaData b, MonadRandom m) => [(a, b)] -> m ((a, b), (a, b))
  selectAlgorithmGa :: (GaData b, MonadRandom m) => m ([(a, b)] -> m [(a, b)])
  geneticOperatorsGa :: (GaData b, MonadRandom m) => [(a, b)] -> [(a, b)] -> m [(a, b)]
  initGa :: (GaData b, MonadRandom m) => Int -> (m b) -> m [(a, b)]

instance GaEvaluation Double where
  calcEvaluationGa x = 
    map (\a -> (calcGa (snd a), snd a)) x

  selectionGa x = do
    die <-  getRandomR (0, sum $ map fst x)
    let x' = foldl (\acc y -> (let s = if acc == []
                                       then 0
                                       else let (s, _, _) = head acc
                                            in s
                                in (s + fst y, s , y)):acc) [] $
             sort x
        s = head .
            map (\y -> let (e, s, a) = y in a) $
            filter (\y -> let (e, s, a) = y in s < die && die < e) x'
    return s

  selection2Ga x = do
    s1 <- selectionGa x
    s2 <- selectionGa x
    if s1 == s2 
      then selection2Ga x
      else return (s1, s2)

  selectAlgorithmGa = do
    die <- getRandomR (1, 100)
    let x = if 80 < (die :: Int)
            then (\x -> copyGa x)
            else if die == 1
                 then (\x -> mutationGa x)
                 else (\x -> crossoverGa x)
    return x

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

  initGa 0 f = return []
  initGa n f = do
    x <- f
    let y = calcGa x
    z <- initGa (n - 1) f
    return ((y, x):z)

---

minProfit = [0.1]
rciShort  = (1, 58)
rciMiddle = 59
rciLong   = 60
smaShort  = (1, 60)
smaMiddle = 60
smaLong   = 60
simChart  = [1, 2, 3, 4, 5, 10, 15, 20, 30, 60, 120]

data FxSetting = FxSetting { fsMinProfit :: Double
                           , fsRciShort  :: Int
                           , fsRciMiddle :: Int
                           , fsRciLong   :: Int
                           , fsSmaShort  :: Int
                           , fsSmaMiddle :: Int
                           , fsSmaLong   :: Int
                           , fsSimChart  :: Int } deriving (Show, Ord, Eq)

instance GaData FxSetting where
  copyGa x = copyFxSetting x
  mutationGa x = mutationFxSetting x
  crossoverGa x = crossoverFxSetting x
  calcGa x = fx x
  
--- 

createRandomFxSetting :: MonadRandom m => m FxSetting
createRandomFxSetting = do
  fsRciShort'  <- getRandomR rciShort                      
  fsRciMiddle' <- getRandomR (fsRciShort'  + 1, rciMiddle) 
  fsRciLong'   <- getRandomR (fsRciMiddle' + 1, rciLong)                              
  fsSmaShort'  <- getRandomR smaShort                     
  fsSmaMiddle' <- getRandomR (fsSmaShort'  + 1, smaMiddle)
  fsSmaLong'   <- getRandomR (fsSmaMiddle' + 1, smaLong)
  i <- getRandomR (0, (length simChart) - 1)
  let fsSimChart' = simChart !! i
  return FxSetting { fsMinProfit = head minProfit
                   , fsRciShort  = fsRciShort' 
                   , fsRciMiddle = fsRciMiddle'
                   , fsRciLong   = fsRciLong'  
                   , fsSmaShort  = fsSmaShort' 
                   , fsSmaMiddle = fsSmaMiddle'
                   , fsSmaLong   = fsSmaLong'  
                   , fsSimChart  = fsSimChart'}

copyFxSetting :: (GaEvaluation a, MonadRandom m) => [(a, FxSetting)] -> m [(a, FxSetting)]
copyFxSetting x = do
  return ([head x])

mutationFxSetting :: (GaEvaluation a, MonadRandom m) => [(a, FxSetting)] -> m [(a, FxSetting)]
mutationFxSetting x = do
  f <- createRandomFxSetting
  let x' = calcEvaluationGa [(0, f)]
  return x'

crossoverFxSetting :: (GaEvaluation a, MonadRandom m) => [(a, FxSetting)] -> m [(a, FxSetting)]
crossoverFxSetting x = do
  die <- replicateM 8 $ getRandomR (True, False)
  let x' = map snd $ take 2 x
      a = (x' !! 0)
      b = (x' !! 1)
  return (calcEvaluationGa [(0, FxSetting { fsMinProfit = choice1 die 0 (fsMinProfit a) (fsMinProfit b)
                                , fsRciShort  = choice1 die 1 (fsRciShort  a) (fsRciShort  b)
                                , fsRciMiddle = choice1 die 2 (fsRciMiddle a) (fsRciMiddle b)
                                , fsRciLong   = choice1 die 3 (fsRciLong   a) (fsRciLong   b)
                                , fsSmaShort  = choice1 die 4 (fsSmaShort  a) (fsSmaShort  b)
                                , fsSmaMiddle = choice1 die 5 (fsSmaMiddle a) (fsSmaMiddle b)
                                , fsSmaLong   = choice1 die 6 (fsSmaLong   a) (fsSmaLong   b)
                                , fsSimChart  = choice1 die 7 (fsSimChart  a) (fsSimChart  b) }),
                   (0, FxSetting { fsMinProfit = choice2 die 0 (fsMinProfit a) (fsMinProfit b)
                                 , fsRciShort  = choice2 die 1 (fsRciShort  a) (fsRciShort  b)
                                 , fsRciMiddle = choice2 die 2 (fsRciMiddle a) (fsRciMiddle b)
                                 , fsRciLong   = choice2 die 3 (fsRciLong   a) (fsRciLong   b)
                                 , fsSmaShort  = choice2 die 4 (fsSmaShort  a) (fsSmaShort  b)
                                 , fsSmaMiddle = choice2 die 5 (fsSmaMiddle a) (fsSmaMiddle b)
                                 , fsSmaLong   = choice2 die 6 (fsSmaLong   a) (fsSmaLong   b)
                                 , fsSimChart  = choice2 die 7 (fsSimChart  a) (fsSimChart  b)})])
    where choice1 die d a b = if die !! d then a else b
          choice2 die d a b = if die !! d then b else a
        

fx :: FxSetting -> Double
fx s = fromIntegral $ (fsRciShort s) + (fsRciMiddle s) + (fsRciLong s) + (fsSmaShort s) + (fsSmaMiddle s) + (fsSmaLong s) + (fsSimChart s)


---
{-
main = do
  a <- initGa 3 createRandomFxSetting
  print a
-}
