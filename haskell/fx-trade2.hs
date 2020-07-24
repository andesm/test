import qualified Data.Map.Strict as Map
import Control.Monad
import Data.List
import Data.List.Split
import Text.Printf
import Debug.Trace 

minProfit = 0.1
rciShort = 5
rciMiddle = 10
rciLong = 15
smaShort = 5
smaMiddle = 25
smaLong = 75
simChart = [1, 2, 3, 4, 5, 10, 15, 20, 30, 60, 120]

-- - - 

data FxTaDataProfit = FxTaDataProfit { ftProfitSum :: Double
                                     , ftProfitAve :: Double
                                     , ftProfitCount :: Double
                                     , ftProfitN :: Double
                                     , fxTaDataAve :: FxTaData }  deriving (Show)

data FxTaData = FxTaData { ftChart :: Double
                         , ftProfitInc :: Double
                         , ftProfitIncN :: Double
                         , ftProfitDec :: Double
                         , ftProfitDecN :: Double
                         , ftRciShort :: Double
                         , ftRciMiddle :: Double 
                         , ftRciLong :: Double
                         , ftSmaShort :: Double
                         , ftSmaMiddle :: Double 
                         , ftSmaLong :: Double
                         , ftBBp2a :: Double 
                         , ftBBm2a :: Double 
                         , ftBBp1a :: Double 
                         , ftBBm1a :: Double } deriving (Show)

type FxTaDataMap = Map.Map Int FxTaData

instance Num FxTaData where
  (+) x y = FxTaData { ftChart = ftChart x + ftChart y
                     , ftProfitInc = ftProfitInc x + ftProfitInc y
                     , ftProfitIncN = ftProfitIncN x + ftProfitIncN y
                     , ftProfitDec = ftProfitDec x + ftProfitDec y
                     , ftProfitDecN = ftProfitDecN x + ftProfitDecN y
                     , ftRciShort = ftRciShort x + ftRciShort y
                     , ftRciMiddle = ftRciMiddle x + ftRciMiddle y
                     , ftRciLong = ftRciLong x + ftRciLong y
                     , ftSmaShort = ftSmaShort x + ftSmaShort y
                     , ftSmaMiddle = ftSmaMiddle x + ftSmaMiddle y
                     , ftSmaLong = ftSmaLong x + ftSmaLong y
                     , ftBBp2a = ftBBp2a x + ftBBp2a y
                     , ftBBm2a = ftBBm2a x + ftBBm2a y
                     , ftBBp1a = ftBBp1a x + ftBBp1a y
                     , ftBBm1a = ftBBm1a x + ftBBm1a y }
            
  fromInteger a = FxTaData { ftChart = (fromIntegral a)
                           , ftProfitInc = (fromIntegral a)
                           , ftProfitIncN = (fromIntegral a)
                           , ftProfitDec = (fromIntegral a)
                           , ftProfitDecN = (fromIntegral a)
                           , ftRciShort = (fromIntegral a)
                           , ftRciMiddle = (fromIntegral a)
                           , ftRciLong = (fromIntegral a) 
                           , ftSmaShort = (fromIntegral a)
                           , ftSmaMiddle = (fromIntegral a)
                           , ftSmaLong = (fromIntegral a)
                           , ftBBp2a = (fromIntegral a)
                           , ftBBm2a = (fromIntegral a)
                           , ftBBp1a = (fromIntegral a)
                           , ftBBm1a = (fromIntegral a) }
            
instance Fractional FxTaData where
  (/) x y = FxTaData { ftChart = ftChart x / ftChart y
                     , ftProfitInc = ftProfitInc x / ftProfitInc y
                     , ftProfitIncN = ftProfitIncN x / ftProfitIncN y
                     , ftProfitDec = ftProfitDec x / ftProfitDec y
                     , ftProfitDecN = ftProfitDecN x / ftProfitDecN y
                     , ftRciShort = ftRciShort x / ftRciShort y
                     , ftRciMiddle = ftRciMiddle x / ftRciMiddle y
                     , ftRciLong = ftRciLong x / ftRciLong y
                     , ftSmaShort = ftSmaShort x / ftSmaShort y
                     , ftSmaMiddle = ftRciMiddle x / ftSmaMiddle y
                     , ftSmaLong = ftSmaLong x / ftSmaLong y
                     , ftBBp2a = ftBBp2a x / ftBBp2a y
                     , ftBBm2a = ftBBm2a x / ftBBm2a y
                     , ftBBp1a = ftBBp1a x / ftBBp1a y
                     , ftBBm1a = ftBBm1a x / ftBBm1a y }

-- - -

chart :: Int -> [Double] -> [Double]
chart c [] = []
chart c x =
  let l = head x
      xn = drop c x
  in l : chart c xn

rSort :: (Ord a) => [a] -> [a]
rSort = sortBy (flip compare)

rci :: Int -> [Double] -> Double
rci n x  =
  let r = map (\y -> (fromIntegral y):[]) [1..n]
      --- [[1,5,5],[2,4,4],[3,3,3],[4,2,2],[5,1,1]]
      d = sum . map (\a -> ((a !! 1) - (a !! 2)) ^ 2) . flip (zipWith (++)) r . rSort . flip (zipWith (++)) r $ map (:[]) x
  in  (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

sma :: Int -> [Double] -> Double
sma n x  = foldl (\acc b -> (b / (fromIntegral n) + acc) 0 x

getRci :: Int -> [Double] -> Double
getRci n x =
  let s = take n x
  in if length s < n
     then 0
     else rci n s

getSma :: Int -> [Double] -> Double
getSma n x =
  let s = take n x
  in if length s < n
     then 0
     else sma n s

getBB :: Int -> [Double] -> (Double, Double)
getBB a x =
  let n = smaMiddle
      ma = getSma n x
      sd = sqrt (n * (foldl (\acc b -> (b ^ 2 + acc) 0 x) - (sum x) ^ 2) / (n * (n - 1)))
  in if ma == 0
     then (0, 0)
     else (ma + sd * a, ma - sd * a)
  
takeMonoList :: (Double -> Double -> Bool) -> [Double] -> [Double]
takeMonoList f [] = []
takeMonoList f (x:[]) = [x]
takeMonoList f (x:xn:xs) = if x `f` xn then x : takeMonoList f (xn:xs) else [x]

getProfit :: (Double -> Double -> Bool) -> [Double] -> (Double, Double)
getProfit f x =
  let s = takeMonoList f x
      p = abs ((head s) - (last s))
      n = fromIntegral ((length s) - 1)
  in if minProfit < p
     then (p, n)
     else (0, 0)


makeFxTaData :: [Double] -> [Double] -> Int -> (Int, FxTaData)
makeFxTaData lr lf n =
  let chart = head lf
      (profitInc, profitIncN) = if n == 0
                                   then getProfit (<) lf
                                   else (0, 0)
      (profitDec, profitDecN) = if n == 0
                                   then getProfit (>) lf
                                   else (0, 0)
  in (if n == 0
       then truncate $ max profitIncN profitDecN
       else n - 1,
      FxTaData { ftChart = chart
               , ftProfitInc = profitInc
               , ftProfitIncN = profitIncN
               , ftProfitDec = profitDec
               , ftProfitDecN = profitDecN
               , ftRciShort = getRci rciShort lr
               , ftRciMiddle = getRci rciMiddle lr
               , ftRciLong = getRci rciLong lr
               , ftSmaShort = getSma smaShort lr
               , ftSmaMiddle = getSma smaMiddle lr
               , ftSmaLong = getSma smaLong lr })
    
makeFxTaDataMap :: [Double] -> [Double] -> Int -> Int -> FxTaDataMap -> FxTaDataMap
makeFxTaDataMap lr (lf0:[]) i n x =
  let (n', d) = makeFxTaData lr [lf0] n
  in Map.insert i d x
makeFxTaDataMap lr (lf0:lf1:lfs) i n x =
  let (n', d) = makeFxTaData lr (lf0:lf1:lfs) n
      x' = Map.insert i d x
  in makeFxTaDataMap (lf1:lr) (lf1:lfs) (i + 1) n' x'

maximumProfit :: [(Int, FxTaDataProfit, FxTaDataMap)] -> (Int, FxTaDataProfit, FxTaDataMap)
maximumProfit x = foldl1 (\a b -> let (_, a', _) = a
                                      (_, b', _) = b
                                  in if (ftProfitSum a') < (ftProfitSum b')
                                     then b
                                     else a ) x

makeAve :: FxTaDataMap -> FxTaDataProfit
makeAve x =
  let px = Map.filter (\a -> (ftProfitInc a) /= 0 || (ftProfitDec a) /= 0) x
      pSum = foldl1 (\a b -> a + b) px
      pLen = fromIntegral $ Map.size px
  in FxTaDataProfit { ftProfitSum = (ftProfitInc pSum) + (ftProfitDec pSum)
                    , ftProfitAve = ((ftProfitInc pSum) + (ftProfitDec pSum)) /pLen
                    , ftProfitCount = pLen
                    , ftProfitN = ((ftProfitIncN pSum) + (ftProfitDecN pSum)) / pLen
                    , fxTaDataAve = pSum / (fromIntegral $ Map.size px) }

-- - -

fx :: Int -> [Double] -> (FxTaDataMap, FxTaDataProfit)
fx c x =
  let xc = chart c x
      rm = makeFxTaDataMap [head xc] xc 0 0 Map.empty
      ave = makeAve $ rm
  in (rm, ave)

-- - -

printSection :: Int -> Int -> Int -> (FxTaData -> Double) -> FxTaDataMap -> IO ()
printSection i e b f x = do
  if e < i 
    then printf "\n"
    else do when (0 <= i && i < Map.size x) $ do
              if i == b
                then printf "| %7.2f " (f $ x Map.! i)
                else printf "%7.2f " (f $ x Map.! i)
            printSection (i + 1) e b f x
  
printProfitChart :: Int -> FxTaDataMap -> IO ()
printProfitChart i x = do
  if i == Map.size x
    then return ()
    else do let n = truncate . ftProfitIncN $ x Map.! i
            when (n /= 0) $ do
              printf "profit = %3.2f N = %2d\n" (ftProfitInc $ x Map.! i) n
              printSection (i - 6) (i + n) i ftChart x
              printSection (i - 6) (i + n) i ftRciShort x
              printSection (i - 6) (i + n) i ftRciMiddle x
              printSection (i - 6) (i + n) i ftRciLong x
              printSection (i - 6) (i + n) i ftSmaShort x
              printSection (i - 6) (i + n) i ftSmaMiddle x
              printSection (i - 6) (i + n) i ftSmaLong x
              printf "\n"
            printProfitChart (i + 1) x

printFxTaDataList :: [(Int, FxTaDataProfit, FxTaDataMap)] -> IO ()
printFxTaDataList [] = return ()
printFxTaDataList (x:xs) = do
  let (c, ave, _) = x
  printf "%3d " c
  printf "%6.2f " (ftProfitSum ave)
  printf "%4.2f " (ftProfitAve ave)
  printf "%6.0f " (ftProfitCount ave)
  printf "%6.2f " (ftProfitN ave)
  printf "%7.2f " (ftRciShort $ fxTaDataAve ave)
  printf "%7.2f " (ftRciMiddle $ fxTaDataAve ave)
  printf "%7.2f " (ftRciLong $ fxTaDataAve ave)
  printf "%7.2f " (ftSmaShort $ fxTaDataAve ave)
  printf "%7.2f " (ftSmaMiddle $ fxTaDataAve ave)
  printf "%7.2f " (ftSmaLong $ fxTaDataAve ave)
  printf "\n"
  printFxTaDataList xs

-- - -

main = do 
  contents <- getContents
  let x = map (\x -> read x :: Double) . map (!! 6) $ map (splitOn ",") (lines contents)
      result = [(c, ave, rm) | c <- simChart, (rm, ave) <- [fx c x]]
      (maxC, _, maxResultMap) = maximumProfit result
  printFxTaDataList result
  printf "\n- %3d : \n" maxC
  printProfitChart 0 maxResultMap


