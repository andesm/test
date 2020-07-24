import Data.Array
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

data FxTaData = FxTaData { ftChart :: Double
                         , ftProfitInc :: Double
                         , ftProfitIncN :: Int
                         , ftProfitDec :: Double
                         , ftProfitDecN :: Int
                         , ftRciShort :: Double
                         , ftRciMiddle :: Double 
                         , ftRciLong :: Double } deriving (Show)

--type FxTaDataArray = Array Int FxTaData
type FxTaDataArray = [FxTaData]

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

makeChartList :: [Double] -> FxTaDataArray
makeChartList x = map (\e -> FxTaData e 0 0 0 0 0 0 0) x

maximumProfit :: FxTaDataArray -> FxTaData
maximumProfit x = foldl1 (\a b -> if ftChart a < ftChart b then b else a) x

{-
makeChartList :: [Double] -> FxTaDataArray
makeChartList x = array (1, length x) . zip [1..] $ map (\e -> FxTaData e 0 0 0 0 0 0 0) x

maximumProfit :: FxTaDataArray -> FxTaData
maximumProfit x = foldl1 (\a b -> if ftChart a < ftChart b then b else a) x

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
-}
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

printFxTaData :: FxTaData -> IO ()
printFxTaData x = do
  printf "%7.2f " (ftChart x)
  printf "%7.2f " (ftProfitInc x)
  printf "%7d " (ftProfitIncN x)
  printf "%7.2f " (ftRciShort x)
  printf "%7.2f " (ftRciMiddle x)
  printf "%7.2f " (ftRciLong x)
  printf "\n"
  
-- - -

main = do 
  contents <- getContents
  let x = map (\x -> read x :: Double) . map (!! 6) $ map (splitOn ",") (lines contents)
      xm = maximumProfit $
      --xm = 
           --makeRciList putRciLong rci_long .
           --makeRciList putRciMiddle rci_middle . 
           --makeRciList putRciShort rci_short .
           --makeProfitIncList .
           -- reverseList $ makeChartList x
           makeChartList x
  printFxTaData xm
  --print xm
  
{-
-}           



