import Control.Concurrent
import Control.Concurrent.Async
import Control.Monad
import Control.Monad.Random

randTest :: (MonadRandom m) => m (Int)
randTest = do
  getRandomR (1, 100)

threadA :: IO (Int)
threadA = do
  threadDelay (10 * 1000 * 1000)
  randTest

loop :: Int -> Async Int -> IO (Int)
loop i a = do 
  threadDelay (1 * 1000 * 1000)
  print i
  a' <- poll a
  case a' of
    Nothing -> loop i a 
    Just v  -> do i' <- wait a
                  loop i' =<< async (threadA)
                  
main = do
  loop 0 =<< async (threadA)

