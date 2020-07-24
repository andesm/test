import qualified Data.Vector as V
import qualified Data.Vector.Algorithms.Radix as V
import Control.Monad.ST as ST
import Data.List

main = print . head . V.toList . sortVec . V.fromList $ [1..40000000]
--main = print . head $ sort [1..40000000]

sortVec :: Ord a => V.Vector a -> V.Vector a
sortVec vec = ST.runST $ do
    mvec <- V.thaw vec
    V.sort mvec
    V.freeze mvec
    
