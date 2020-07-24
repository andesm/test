import Data.List.Split
import Text.Printf

data FxTaData = FxTaData { ftChart :: Double
                         , ftProfitInc :: Double
                         , ftProfitIncN :: Int
                         , ftProfitDec :: Double
                         , ftProfitDecN :: Int
                         , ftRciShort :: Double
                         , ftRciMiddle :: Double 
                         , ftRciLong :: Double } deriving (Show)

data LinerList a = EmptyListData |
                   DataNode a (LinerList a) (LinerList a)  deriving (Show)
 
data LinerMatrix a b = EmptyMatrixData |
                       MatrixNode (LinerList a) (LinerList a) (LinerMatrix a b)  deriving (Show)

insertElement :: LinerMatrix a -> a -> LinerMatrix a
insertElement MatrixNode (DataNode a EmptyListData EmptyListData) (DataNode a EmptyListData EmptyListData) n =
  let next = DataNode a EmptyListData prev
      prev = DataNode a next EmptyListData 
  in MatrixNode next prev n
insertElement (DataNode a prev next) x =
  let head = DataNode a prev ins_elem
      ins_elem = DataNode x head next
  in head

printFxTaData :: LinerList FxTaData -> IO ()
printFxTaData EmptyListData = return ()
printFxTaData (DataNode x prev _) = do

  printf "%7.2f " (ftChart x)
  printf "%7.2f " (ftProfitInc x)
  printf "%7d " (ftProfitIncN x)
  printf "%7.2f " (ftRciShort x)
  printf "%7.2f " (ftRciMiddle x)
  printf "%7.2f " (ftRciLong x)
  printf "\n"
  printFxTaData prev

makeChartList :: [Double] -> LinerList FxTaData
makeChartList x = foldl insertElement EmptyListData $ map (\e -> FxTaData e 0 0 0 0 0 0 0) x

main = do 
  contents <- getContents
  let x = map (\x -> read x :: Double) . map (!! 6) $ map (splitOn ",") (lines contents)
      xs = makeChartList x
  printFxTaData xs
