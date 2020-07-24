
import Control.DeepSeq
import Control.Parallel.Strategies

main = do
  let a = [1..10]
  a <- mapM_ (print) a `using` parList rdeepseq
  return ()
  


