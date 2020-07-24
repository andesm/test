import Data.List.Split
import Data.Array
import Data.List
import Text.Printf
import Control.Monad
import Control.Monad.State
import Debug.Trace 

data Island = Island { maxColor :: Int
                     , prevChange :: Bool
                     , matrix :: IslandMatrix }  deriving (Show)

type IslandMatrix = Array (Int, Int) Int

setPrevChange :: Bool -> State Island ()
setPrevChange x = do 
  i <- get
  let i' = i { prevChange = x }
  put i'

maxColorInc :: State Island ()
maxColorInc = do 
  i <- get
  let i' = i { maxColor = (maxColor i) + 1 }
  put i'

setColor :: Int -> Int -> Int -> State Island IslandMatrix
setColor x y c = do
  i <- get
  let m = matrix i
      m' = m // [((x, y), c)]
      i' = i { matrix = m' }
  put i'
  return m'
  
searchIsland :: Int -> Int -> State Island ()
searchIsland maxX maxY = do
  i <- get
  let m = matrix i
  forM (reverse [0..maxY]) $ \y -> do
    forM (reverse [0..maxX]) $ \x -> do
      m <- setColor x y 22
      traceShow (x, y, m) $ return ()
    return ()
  return ()

countIsland :: Island -> Int
countIsland i =
  let m = matrix i
  in length . nub . filter (/=0) $ elems m

main = do 
  contents <- getContents
  let x = map (map (\x -> read x :: Int)) $ map (splitOn " ") (lines contents)
      d = head x
      maxX = (d !! 0) - 1
      maxY = (d !! 1) - 1
      m = array ((0,0), (maxX, maxY)) [((i,j), ((tail x) !! j) !! i) | i <- [0..maxX], j <- [0..maxY]]
  print m
  let i = Island { maxColor = 2
                 , prevChange = False
                 , matrix = m}
      (r, i') = runState (searchIsland maxX maxY) i
--      c = countIsland i'
  print i'
  
