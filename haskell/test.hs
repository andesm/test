import Data.List
import Data.List.Split
import Text.Printf
import Debug.Trace 

min_profit = 0
max_position_time = 60
rci_short = 9
rci_middle = 26
rci_long = 52
sim_chart = [1, 2, 3, 4, 5, 10, 15, 20, 30, 60, 120]
sim_n = [2..5]

-- - -

data LinerList a = EmptyListData |
                   DataNode a (LinerList a)  deriving (Show)
 
data LinerMatrix a b = EmptyMatrixData |
                       MatrixNode (LinerList a) (LinerMatrix a b)  deriving (Show)

{-
insertElement :: LinerList a -> a -> LinerList a
insertElement EmptyListData x = DataNode x EmptyListData
insertElement (DataNode a next) x = DataNode a (insertElement next x)
-}

insertElement :: LinerList a -> a -> LinerList a
insertElement next x = DataNode x next

reverseList :: LinerList a -> LinerList a
reverseList EmptyListData = EmptyListData
reverseList x = insertElement (reverseList $ initList x) (lastElement x)

takeElement :: (a -> b) -> Int -> LinerList a -> [b]
takeElement f 0 _ = []
takeElement f _ EmptyListData = []
takeElement f n (DataNode a next) = f a : takeElement f (n - 1) next

putElement :: (a -> b -> a) -> b -> Int -> LinerList a -> LinerList a
putElement f x 0 (DataNode a next) = DataNode (f a x) next
putElement f x _ EmptyListData = EmptyListData
putElement f x n (DataNode a next) = DataNode a (putElement f x (n - 1) next)

headElement :: LinerList a -> a
headElement (DataNode a next) = a

lastElement :: LinerList a -> a
lastElement (DataNode a EmptyListData) = a
lastElement (DataNode a next) = lastElement next

initList :: LinerList a -> LinerList a
initList (DataNode a EmptyListData) = EmptyListData
initList (DataNode a next) = DataNode a (initList next)

lengthElementList :: LinerList a -> Int -> Int
lengthElementList EmptyListData n = n
lengthElementList (DataNode a next) n = lengthElementList next (n + 1) 

maximumElement :: LinerList FxTaData -> FxTaData
maximumElement (DataNode x EmptyListData) = x
maximumElement (DataNode x next) =
  let n = maximumElement next
  in if ftChart x < ftChart n then n else x

-- - - 

data FxTaData = FxTaData { ftChart :: Double
                         , ftProfitInc :: Double
                         , ftProfitIncN :: Int
                         , ftProfitDec :: Double
                         , ftProfitDecN :: Int
                         , ftRciShort :: Double
                         , ftRciMiddle :: Double 
                         , ftRciLong :: Double } deriving (Show)

putChart :: FxTaData -> Double -> FxTaData
putChart x c = x { ftChart = c }

putRciShort :: FxTaData -> Double -> FxTaData
putRciShort x c = x { ftRciShort = c }

putRciMiddle :: FxTaData -> Double -> FxTaData
putRciMiddle x c = x { ftRciMiddle = c }

putProfitInc :: FxTaData -> Double -> FxTaData
putProfitInc x c = x { ftProfitInc = c }

putProfitIncN :: FxTaData -> Int -> FxTaData
putProfitIncN x c = x { ftProfitIncN = c }

-- - - 

rci :: Int -> [Double] -> Double
rci n x  =
  let r = map (\y -> (fromIntegral y):[]) (reverse [1..n])
      --- [[1,5,5],[2,4,4],[3,3,3],[4,2,2],[5,1,1]]
      d = sum . map (\a -> ((a !! 1) - (a !! 2)) ^ 2) . flip (zipWith (++)) r . sort . flip (zipWith (++)) r $ map (:[]) x
  in  (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

makeChartList :: [Double] -> LinerList FxTaData
makeChartList x = foldl' insertElement EmptyListData $ map (\e -> FxTaData e 0 0 0 0 0 0 0) x

makeRciList :: (FxTaData -> Double -> FxTaData) -> Int -> LinerList FxTaData -> LinerList FxTaData
makeRciList putf n EmptyListData = EmptyListData
makeRciList putf n x  =
  let r = rci n $ takeElement ftChart n x
      (DataNode a next) = putElement putf r (n - 1) x
  in DataNode a (makeRciList putf n next)

takeMonoProfit :: (Double -> Double -> Bool) -> Double -> LinerList FxTaData -> LinerList FxTaData
takeMonoProfit f _ EmptyListData = EmptyListData 
takeMonoProfit f p (DataNode a next) =
  if p `f` ftChart a
  then DataNode a (takeMonoProfit f (ftChart a) next)
  else EmptyListData

makeProfitIncList :: LinerList FxTaData -> LinerList FxTaData
makeProfitIncList EmptyListData = EmptyListData
makeProfitIncList x =
  let s = takeMonoProfit (<) 0 x
      p = abs ((ftChart $ headElement s) - (ftChart $ lastElement s))
      n = lengthElementList s 0
      (DataNode a next) = if min_profit < p 
                          then putElement putProfitIncN n 0 $ putElement putProfitInc p 0 x
                          else x
  in DataNode a (makeProfitIncList next)

-- - -

{-
printDoubleList :: (FxTaData -> Double) -> LinerList FxTaData -> IO ()
printDoubleList f EmptyListData = printf "\n"
printDoubleList f (DataNode x next) = do
  printf "%7.2f " (f x)
  printDoubleList f next

printIntList :: (FxTaData -> Int) -> LinerList FxTaData -> IO ()
printIntList f EmptyListData = printf "\n"
printIntList f (DataNode x next) = do
  printf "%7d " (f x)
  printIntList f next

printFxTaData :: LinerList FxTaData -> IO ()
printFxTaData x = do
  printDoubleList ftChart x
  printDoubleList ftProfitInc x
  printIntList ftProfitIncN x
  printDoubleList ftRciShort x
-}

printFxTaData :: LinerList FxTaData -> IO ()
printFxTaData EmptyListData = return ()
printFxTaData (DataNode x next) = do
  printf "%7.2f " (ftChart x)
  printf "%7.2f " (ftProfitInc x)
  printf "%7d " (ftProfitIncN x)
  printf "%7.2f " (ftRciShort x)
  printf "%7.2f " (ftRciMiddle x)
  printf "%7.2f " (ftRciLong x)
  printf "\n"
  printFxTaData next
  
-- - -

main = do 
  contents <- getContents
  let x = map (\x -> read x :: Double) . map (!! 6) $ map (splitOn ",") (lines contents)
      -- xm = maximumElement . 
      --xm = 
           --makeRciList putRciLong rci_long .
           --makeRciList putRciMiddle rci_middle . 
           --makeRciList putRciShort rci_short .
           --makeProfitIncList .
           -- reverseList $ makeChartList x
           --makeChartList x
      xm =  maximum $ reverse x
  --printFxTaData xm
  print xm
  
{-
-}           



