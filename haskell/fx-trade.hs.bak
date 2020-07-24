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

data FxSetting = FxSetting { fsN :: Int
                           , fsChart :: Int
                           , fsRciShort :: Int
                           , fsRciMiddle :: Int
                           , fsRciLong :: Int } deriving (Show)
                           
data FxProfit = FxProfit { fpAve :: Double
                         , fpSum  :: Double
                         , fpCount :: Double } deriving (Show, Ord, Eq)

data FxTaData = FxTaData { ftChart :: Double
                         , ftRciShort :: Double
                         , ftRciMiddle :: Double
                         , ftRciLong :: Double } deriving (Show, Ord, Eq)

data FxTaDataList = FxTaDataList { ftdlChart :: [Double]
                                 , ftdlRciShort :: [Double]
                                 , ftdlRciMiddle :: [Double]
                                 , ftdlRciLong :: [Double] } deriving (Show)

data FxTa2dDataList = FxTa2dDataList { ftddlChart :: [[Double]]
                             , ftddlRciShort :: [[Double]]
                             , ftddlRciMiddle :: [[Double]]
                             , ftddlRciLong :: [[Double]] } deriving (Show)

type FxTaList = [FxTaData]

data FxTa = FxTa { fxtaUpperAve :: FxTaList
                 , fxtaLowerAve :: FxTaList
                 , fxtaAll :: [FxTaList] } deriving (Show, Ord, Eq)

instance Num FxTaData where
  (+) x y = FxTaData (ftChart x + ftChart y) (ftRciShort x + ftRciShort y) (ftRciMiddle x + ftRciMiddle y) (ftRciLong x + ftRciLong y)
  fromInteger a = FxTaData (fromIntegral a) (fromIntegral a) (fromIntegral a) (fromIntegral a) 

instance Fractional FxTaData where
  (/) x y = FxTaData (ftChart x / ftChart y) (ftRciShort x / ftRciShort y) (ftRciMiddle x / ftRciMiddle y) (ftRciLong x / ftRciLong y)

emptyFxTaData :: FxTaData
emptyFxTaData = FxTaData 0 0 0 0

toFxTa2dDataList :: [FxTaList] -> FxTa2dDataList
toFxTa2dDataList x =
  FxTa2dDataList  { ftddlChart = map (map ftChart) x
              , ftddlRciShort = map (map ftRciShort) x 
              , ftddlRciMiddle = map (map ftRciMiddle) x 
              , ftddlRciLong = map (map ftRciLong) x }

cutFxTaData  :: (Double -> Double -> Bool) -> FxTaData -> FxTaData
cutFxTaData f x =
  FxTaData { ftChart = if 0 `f` (ftChart x) then (ftChart x) else 0
           , ftRciShort = if 0 `f` (ftRciShort x) then (ftRciShort x) else 0
           , ftRciMiddle = if 0 `f` (ftRciMiddle x) then (ftRciMiddle x) else 0
           , ftRciLong = if 0 `f` (ftRciLong x) then (ftRciLong x) else 0 }

cutOneFxTaData  :: (Double -> Double -> Bool) -> FxTaData -> FxTaData
cutOneFxTaData f x =
  FxTaData { ftChart = if 0 `f` (ftChart x) then 1 else 0
           , ftRciShort = if 0 `f` (ftRciShort x) then 1 else 0
           , ftRciMiddle = if 0 `f` (ftRciMiddle x) then 1 else 0
           , ftRciLong = if 0 `f` (ftRciLong x) then 1 else 0 }
  
initFxTaList :: FxTaDataList -> FxTaList
initFxTaList (FxTaDataList [] _ _ _) = []
initFxTaList (FxTaDataList _ [] _ _) = []
initFxTaList (FxTaDataList _ _ [] _) = []
initFxTaList (FxTaDataList _ _ _ []) = []
initFxTaList (FxTaDataList (a:as) (b:bs) (c:cs) (d:ds)) = (FxTaData a b c d) : initFxTaList (FxTaDataList as bs cs ds)

rdrop :: Int -> [b] -> [b]
rdrop _ [] = []
rdrop 0 x = x
rdrop n x = rdrop (n - 1) (init x)

chart :: Int -> [Double] -> [Double]
chart c [] = []
chart c x =
  let l = head x
      xn = drop c x
  in l : chart c xn

rci :: Int -> [Double] -> Double
rci n x  =
  let r = map (\y -> (fromIntegral y):[]) (reverse [1..n])
      --- [[1,5,5],[2,4,4],[3,3,3],[4,2,2],[5,1,1]]
      d = sum . map (\a -> ((a !! 1) - (a !! 2)) ^ 2) . flip (zipWith (++)) r . sort . flip (zipWith (++)) r $ map (:[]) x
  in  (1.0 - (6.0 * d) / ((fromIntegral n) * ((fromIntegral n) ^ 2 - 1.0))) * 100.0

rciList :: Int -> [Double] -> [Double]
rciList n [] = []
rciList n x = rci n (take n x) : rciList n (tail x)

makeRciList :: Int -> [Double] -> [Double]
makeRciList r cl =
  if r < length cl
  then (map fromIntegral $ replicate (r - 1) 0) ++ (rdrop (r - 1) $ rciList r cl)
  else (map fromIntegral $ replicate (length cl) 0)

isMono :: (Double -> Double -> Bool) -> [Double] -> Bool
isMono f [] = False
isMono f (x:[]) = False
isMono f (x:xn:[]) = x `f` xn
isMono f (x:xn:xs) = x `f` xn && isMono f (xn:xs)

isProfit :: (Double -> Double -> Bool) -> [Double] -> Bool
isProfit f x = head x `f` last x

makeProfitList :: Int -> ((Double -> Double -> Bool) -> [Double] -> Bool) -> (Double -> Double -> Bool) -> [Double] -> [Double]
makeProfitList n f e [] = []
makeProfitList n f e x =
  (let s = take n x
       p = abs ((head s) - (last s))
   in (if min_profit < p && length s == n && f e s
        then p
        else 0)) : makeProfitList n f e (tail x)

makeFbList :: Int -> [Double] -> FxTaList -> FxTaList -> [FxTaList]
makeFbList n [] _ _  = [[]]
makeFbList n _ _ []  = [[]]
makeFbList n (mlv:mls) rl (rrv:rrs) =
  (if mlv /= 0
  then (reverse $ take (n - 1) rl) ++ (take n (rrv:rrs))
  else []) : makeFbList n mls (rrv:rl) rrs

makeFxTa :: Int -> [Double] -> FxTaList -> FxTa
makeFxTa n mono_list fx_ta_list = 
  let
    ta = filter (\a -> (length a) == n * 2 - 1) $ makeFbList n mono_list [] fx_ta_list
    upper_ta_sum = foldl (\acc x -> zipWith (+) acc x) (repeat (emptyFxTaData)) .
                   map (map (cutFxTaData (<))) $ ta
    upper_ta_count = foldl (\acc x -> zipWith (+) acc x) (repeat (emptyFxTaData)) .
                   map (map (cutOneFxTaData (<))) $ ta
    lower_ta_sum = foldl (\acc x -> zipWith (+) acc x) (repeat (emptyFxTaData)) .
                   map (map (cutFxTaData (>))) $ ta
    lower_ta_count = foldl (\acc x -> zipWith (+) acc x) (repeat (emptyFxTaData)) .
                   map (map (cutOneFxTaData (>))) $ ta
  in if null ta
     then FxTa { fxtaUpperAve = []
               , fxtaLowerAve = []
               , fxtaAll = [] }
     else -- traceShow(upper_ta_sum, upper_ta_count)
          FxTa { fxtaUpperAve = zipWith (/) upper_ta_sum upper_ta_count  
               , fxtaLowerAve = zipWith (/) lower_ta_sum lower_ta_count
               , fxtaAll = ta }

calcFxProfit :: [Double] -> FxProfit
calcFxProfit ml = 
  let l = filter (/=0) ml
      ml_count = fromIntegral $ length l
      ml_sum = sum l
  in FxProfit {fpAve = ml_sum / ml_count, fpSum = ml_sum, fpCount = ml_count}

fx :: FxSetting -> [Double] -> (FxProfit, FxTa, FxTa)
fx s x =
  let chart_list = chart (fsChart s) x
      profit_list_inc = makeProfitList (fsN s) isMono (<) chart_list
      profit_list_dec = makeProfitList (fsN s) isMono (>) chart_list
--      profit_list_inc = makeProfitList (fsN s) isProfit (<) chart_list
--      profit_list_dec = makeProfitList (fsN s) isProfit (>) chart_list

      fxta_data_list = FxTaDataList { ftdlChart = chart_list
                                    , ftdlRciShort = makeRciList (fsRciShort s) chart_list
                                    , ftdlRciMiddle = makeRciList (fsRciMiddle s) chart_list
                                    , ftdlRciLong = makeRciList (fsRciLong s) chart_list }

      fx_ta_list = initFxTaList fxta_data_list   
      fx_profit = calcFxProfit (profit_list_inc ++ profit_list_dec)

      fxta_inc = makeFxTa (fsN s) profit_list_inc fx_ta_list 
      fxta_dec = makeFxTa (fsN s) profit_list_dec fx_ta_list 
  in traceShow (s) 
     (fx_profit, fxta_inc, fxta_dec)

printfDoubleList :: [Double] -> IO ()
printfDoubleList a = do
  mapM_ (printf "%6.2f ") a
  printf "\n"

printDdList :: FxTa2dDataList -> IO ()
printDdList (FxTa2dDataList [] _ _ _) = return ()
printDdList (FxTa2dDataList (a:as) (b:bs) (c:cs) (d:ds)) = do
  printfDoubleList a
  printfDoubleList b
  printfDoubleList c
  printfDoubleList d
  printf "\n"
  printDdList $ FxTa2dDataList as bs cs ds
  
printFxTa :: FxTa -> IO ()
printFxTa x = do
  printf "Upper Ave:\n"
  printDdList . toFxTa2dDataList $ [fxtaUpperAve x]
  printf "Lower Ave:\n"
  printDdList . toFxTa2dDataList $ [fxtaLowerAve x]
  printf "All:\n"
  printDdList . toFxTa2dDataList $ fxtaAll x

main = do 
  contents <- getContents
  let x = map (\x -> read x :: Double) . map (!! 6) $ map (splitOn ",") (lines contents)
      (fx_profit, n, c, fxta_inc, fxta_dec) =
        maximum [(fx_profit, n, c, fxta_inc, fxta_dec) |
                 c <- sim_chart,
                 n <- sim_n,
                 (fx_profit, fxta_inc, fxta_dec) <- [fx (FxSetting n c rci_short rci_middle rci_long) x],
                 c * n <= max_position_time]
  print fx_profit
  printf "c = %d\n" c
  printf "n = %d\n" n
  printf "\n"
  printf "- Inc\n"
  printFxTa fxta_inc
  printf "- Dec\n"
  printFxTa fxta_dec


