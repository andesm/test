import Data.List
import Data.List.Split
import Text.Printf
import Debug.Trace 

data FxTaData = FxTaData { ftChart :: Double
                         , ftProfitInc :: Double
                         , ftProfitIncN :: Int
                         , ftProfitDec :: Double
                         , ftProfitDecN :: Int
                         , ftRciShort :: Double
                         , ftRciMiddle :: Double 
                         , ftRciLong :: Double } deriving (Show)

data LinerList a = EmptyListData |
                   DataNode a (LinerList a)  deriving (Show)

{-
insertElement :: LinerList a -> a -> LinerList a
insertElement EmptyListData x = DataNode x EmptyListData
insertElement (DataNode a next) x = DataNode a (insertElement next x)
-}

insertElement :: LinerList a -> a -> LinerList a
insertElement next x = DataNode x next

reverseList :: LinerList a -> LinerList a
reverseList EmptyListData = EmptyListData
reverseList (DataNode x next) = DataNode x (reverseList next)

{-
maximumElement :: LinerList FxTaData -> Double
maximumElement x = ftChart $ foldl1 (\acc y -> if ftChart acc < ftChart y then y else acc) x
-}

maximumElement :: LinerList FxTaData -> Double
maximumElement (DataNode x EmptyListData) = ftChart x
maximumElement (DataNode x next) =
  let n = maximumElement next
  in if ftChart x < n then n else ftChart x

makeChartList :: [Double] -> LinerList FxTaData
makeChartList x = foldl insertElement EmptyListData $ map (\e -> FxTaData e 0 0 0 0 0 0 0) x

main = do 
  contents <- getContents
  let x = map (\x -> read x :: Double) . map (!! 6) $ map (splitOn ",") (lines contents)
      xm = reverseList $ makeChartList x
  --printFxTaData xs
  print xm


