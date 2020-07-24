import Debug.Trace
import Control.Monad
import Control.Monad.Random

data TechAnaTree = Empty |
                   Leaf Int |
                   Node Int TechAnaTree TechAnaTree deriving(Show)


insertTechAnaTree :: MonadRandom m => TechAnaTree -> TechAnaTree -> m TechAnaTree
insertTechAnaTree e Empty = return e
insertTechAnaTree e (Leaf x) = do
  die <- getRandomR (0, 1)
  return (Node die e (Leaf x))
insertTechAnaTree e (Node x l r) = do
  die <- getRandomR (True, False)
  if die
    then do l' <- insertTechAnaTree e l
            return (Node x l' r)
    else do r' <- insertTechAnaTree e r
            return (Node x l r')


makeTechAnaTree :: MonadRandom m => m TechAnaTree
makeTechAnaTree = foldl (\acc a -> do die <- getRandomR (True, False)
                                      l <- getRandomR (0, 9)
                                      acc' <- acc
                                      if die
                                        then insertTechAnaTree (Leaf l) acc'
                                        else acc) (pure Empty) [1..20]

evaluateTechAnaTree :: Int -> TechAnaTree -> Bool
evaluateTechAnaTree e Empty = False
evaluateTechAnaTree e (Leaf x) = e == x
evaluateTechAnaTree e (Node x l r) =
  case x of
    0 -> (evaluateTechAnaTree e l) && (evaluateTechAnaTree e r)
    1 -> (evaluateTechAnaTree e l) || (evaluateTechAnaTree e r)

divideTechAnaTree :: MonadRandom m => TechAnaTree -> m (TechAnaTree, TechAnaTree)
divideTechAnaTree Empty = return (Empty, Empty)
divideTechAnaTree (Leaf x) = return (Empty, Leaf x)
divideTechAnaTree (Node x l r) = do
  die <- getRandomR (True, False)
  if die
    then do die <- getRandomR (True, False)
            if die
              then return (r, Node x l Empty)
              else return (l, Node x Empty r)
    else do die <- getRandomR (True, False)
            if die
              then do (o, d) <- divideTechAnaTree l
                      return (Node x r o, d)
              else do (o, d) <- divideTechAnaTree r
                      return (Node x o l, d)

crossoverTechAnaTree :: MonadRandom m => TechAnaTree -> TechAnaTree -> m (TechAnaTree, TechAnaTree)
crossoverTechAnaTree x y = do
  (xo, xd) <- divideTechAnaTree x
  (yo, yd) <- divideTechAnaTree y
  x' <- insertTechAnaTree xo yd
  y' <- insertTechAnaTree yo xd
  return (x', y')

