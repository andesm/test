import System.IO
import Text.Printf
import Control.Concurrent.Thread.Delay

main = do
  hSetBuffering stdout NoBuffering
  printf "123\r"
  delay $ 1 * 1000 * 1000
  printf "456\r"
  delay $ 1 * 1000 * 1000
  printf "789\r"
  delay $ 1 * 1000 * 1000
  printf "\n"
  printf "%s\n" [1,2,3]
  
  
