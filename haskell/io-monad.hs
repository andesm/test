import Control.Monad
import Control.Monad.Random
import Text.Printf

aaa :: MonadRandom m => m Int
aaa = do
  getRandomR (1, 10)

ttt :: MonadRandom m => IO (m Int)
ttt = do
  printf "a\n"
  return aaa

main = do
  a <- ttt
  b <- a
  print b

