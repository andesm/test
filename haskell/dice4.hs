import qualified Ga 
import Control.Monad
import Control.Monad.Random
import Debug.Trace 

---

minProfit = [0.1]
rciShort  = (1, 58)
rciMiddle = 59
rciLong   = 60
smaShort  = (1, 58)
smaMiddle = 59
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

instance Ga.Ga FxSetting where
  copy x = copyFxSetting x
  mutation x = mutationFxSetting x
  crossover x = crossoverFxSetting x
  evaluation x = fx x
  
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

copyFxSetting :: MonadRandom m => [(Double, FxSetting)] -> m [(Double, FxSetting)]
copyFxSetting x = do
  return ([head x])

mutationFxSetting :: MonadRandom m => [(Double, FxSetting)] -> m [(Double, FxSetting)]
mutationFxSetting x = do
  f <- createRandomFxSetting
  let x' = Ga.evaluationAll [(0, f)]
  return x'

crossoverOrdCalc ::  MonadRandom m => Int -> [Double] -> [Double] -> m ([Double], [Double])
crossoverOrdCalc n x y = do
  die <- getRandomR (True, False)
  let (x' , y') = if die && x !! n < y !! (n + 1) && y !! n < x !! (n + 1)
                  then ((take (n + 1) y) ++ (drop (n + 1) x) , (take (n + 1) x) ++ (drop (n + 1) y))
                  else (x , y)
  if length x - 1 == n
    then return (x , y)
    else crossoverOrdCalc (n + 1) x' y'

crossoverOrd ::  MonadRandom m => [Double] -> [Double] -> m ([Double], [Double])
crossoverOrd x y = do
  let n = length x
      x' = x ++ [(max (maximum x) (maximum y)) + 1]
      y' = y ++ [(max (maximum x) (maximum y)) + 1]
  r <- crossoverOrdCalc 0 x' y'
  return (take n (fst r), take n (snd r))

crossoverFxSetting :: MonadRandom m => [(Double, FxSetting)] -> m [(Double, FxSetting)]
crossoverFxSetting x = do
  die <- replicateM 2 $ getRandomR (True, False)
  let x' = map snd $ take 2 x
      a = (x' !! 0)
      b = (x' !! 1)
  (rci1, rci2) <- crossoverOrd([(fsRciShort  a), (fsRciMiddle a), (fsRciLong a)], [(fsRciShort  b), (fsRciMiddle b), (fsRciLong b)])
  (sma1, sma2) <- crossoverOrd([(fsSmaShort  a), (fsSmaMiddle a), (fsSmaLong a)], [(fsSmaShort  b), (fsSmaMiddle b), (fsSmaLong b)])
  return (Ga.evaluationAll
           [(0, FxSetting { fsMinProfit = choice1 die 0 (fsMinProfit a) (fsMinProfit b)
                          , fsRciShort  = rci1 !! 0
                          , fsRciMiddle = rci1 !! 1
                          , fsRciLong   = rci1 !! 2
                          , fsSmaShort  = sma1 !! 0
                          , fsSmaMiddle = sma2 !! 1
                          , fsSmaLong   = sma3 !! 2
                          , fsSimChart  = choice1  die 1 (fsSimChart  a) (fsSimChart  b) }),
             (0, FxSetting { fsMinProfit = choice2  die 0 (fsMinProfit a) (fsMinProfit b)
                           , fsRciShort  = rci1 !! 0
                           , fsRciMiddle = rci1 !! 1
                           , fsRciLong   = rci1 !! 2
                           , fsSmaShort  = sma1 !! 0
                           , fsSmaMiddle = sma2 !! 1
                           , fsSmaLong   = sma3 !! 2
                           , fsSimChart  = choice2  die 1 (fsSimChart  a) (fsSimChart  b)})])
    where choice1  die n a b = if die !! n then b else a
          choice2  die n a b = if die !! n then a else b

fx :: FxSetting -> Double
fx s = fromIntegral $ (fsRciShort s) + (fsRciMiddle s) + (fsRciLong s) + (fsSmaShort s) + (fsSmaMiddle s) + (fsSmaLong s) + (fsSimChart s)


---

main = do
  x <- Ga.initialize 200 createRandomFxSetting
  r <- Ga.calc 1000 x
  print r

