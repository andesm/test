import qualified Data.Map.Strict as Map
import Control.Monad
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
type FxTaDataMap = Map.Map Int FxTaData

putChart :: Double -> FxTaData -> FxTaData
putChart c x = x { ftChart = c }

putRciShort :: Double -> FxTaData -> FxTaData
putRciShort c x = x { ftRciShort = c }

putRciMiddle :: Double -> FxTaData -> FxTaData
putRciMiddle c x = x { ftRciMiddle = c }

putProfitInc :: Double -> FxTaData -> FxTaData
putProfitInc c x = x { ftProfitInc = c }

putProfitIncN :: Int -> FxTaData -> FxTaData
putProfitIncN c x = x { ftProfitIncN = c }

-- - - 

rci :: Int -> [Double] -> Double
rci n x  =
  let r = map (\y -> (fromIntegral y):[]) (reverse [1..n])
      --- [[1,5,5],[2,4,4],[3,3,3],[4,2,2],[5,1,1]]
      d = sum . map (\a -> ((a !! 1) - (a !! 2)) ^ 2) . flip (zipWith (++)) r . sort . flip (zipWith (++)) r $ map (:[]) x
  in  (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

makeChartList :: [Double] -> FxTaDataMap
makeChartList x = Map.fromList . zip [1..] $ map (\e -> FxTaData e 0 0 0 0 0 0 0) x

maximumProfit :: FxTaDataMap -> FxTaData
maximumProfit x = foldl1 (\a b -> if ftChart a < ftChart b then b else a) x

makeRciList :: (Double -> FxTaData -> FxTaData) -> Int -> Int -> FxTaDataMap -> FxTaDataMap
makeRciList putf n 0 x  = x
makeRciList putf n i x  =
  let r = rci n $ map (\a -> ftChart $ x Map.! a) [i..i + (n-1)]
      xr = Map.update (\a -> Just . putf r $ x Map.! (i + (n-1))) (i + (n-1)) x
  in makeRciList putf n (i - 1) xr 

takeMonoProfit :: (Double -> Double -> Bool) -> Double -> Int -> FxTaDataMap -> Int
takeMonoProfit f p i x =
  let ir = if Map.member i x
        then let cp = ftChart $ x Map.! i
             in if p `f` cp
                then takeMonoProfit f cp (i + 1) x
                else i -1
        else i - 1
  in ir
    
makeProfitIncList :: Int -> FxTaDataMap -> FxTaDataMap
makeProfitIncList 0 x = x
makeProfitIncList i x =
  let ie = takeMonoProfit (<) 0 (i + 1) x
      p = abs ((ftChart $ x Map.! i) - (ftChart $ x Map.! ie))
      n = ie - i
      xn= if min_profit < p 
          then Map.update (\a -> Just . putProfitIncN n . putProfitInc p $ x Map.! i) i x
          else x
  in makeProfitIncList (i - 1) xn 

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

printFxTaDataMap :: Int -> FxTaDataMap -> IO ()
printFxTaDataMap i x = do
  printf "%7.2f " (ftChart $ x  Map.! i)
  printf "%7.2f " (ftProfitInc $ x Map.! i)
  printf "%7d " (ftProfitIncN $ x Map.! i)
  printf "%7.2f " (ftRciShort $ x Map.! i)
  printf "%7.2f " (ftRciMiddle $ x Map.! i)
  printf "%7.2f " (ftRciLong $ x Map.! i)
  printf "\n"

-- - -

main = do 
  contents <- getContents
  let x = map (\x -> read x :: Double) . map (!! 6) $ map (splitOn ",") (lines contents)
      len = length x
      -- xm = 
      xm = maximumProfit $
           --makeRciList putRciLong rci_long .
           --makeRciList putRciMiddle rci_middle . 
           makeRciList putRciShort rci_short len .
           makeProfitIncList len $
           makeChartList x
  printFxTaData xm
  --forM [1..len] $ \a -> do
  --  printFxTaDataMap a xm




