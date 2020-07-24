import Control.Monad
import Control.Monad.Random

randtest :: MonadRandom m => [Int] -> m [Int]
randtest x = do
  y <- getRandomRs (0, last x)
  return y

ptest :: [Int] -> IO [Int]
ptest x = do
  let x' = take 5 x
  print x'
  return (map (+1) x')

test :: MonadRandom m => [Int] -> m (IO [Int])
test x = do
  y <- randtest x
  return $ do z <- ptest y
              return z

type GaData a = (Double, a)
type GaResultPrint a = ([GaData a] -> IO ())
type ProgressPrint a = (Int -> Double -> IO ())

class (Show a, Ord a) => Ga a where
  initializeWithProgress :: MonadRandom m => Int -> (a -> m a) -> a -> ProgressPrint a-> m (IO [GaData a])
  initializeWithProgress n f ifs ppf = do
    gx <- createInitialData n f ifs
    return $ do gx' <- evaluateAllwithProgress gx [] ppf n
                return gx'
    
  createInitialData :: MonadRandom m => Int -> (a -> m a) -> a -> m [GaData a]
  createInitialData n f ifs = do
    x <- f ifs
    return ([(0, x)])

  evaluateAllwithProgress :: [GaData a] -> [GaData a] -> ProgressPrint a -> Int -> IO [GaData a]
  evaluateAllwithProgress (x:xs) r ppf n = do
    ppf n 0
    evaluateAllwithProgress xs r ppf n

