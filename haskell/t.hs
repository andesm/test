
import qualified Data.Foldable as F
import Control.Monad.Random

newtype LearningData a = LearningData { getLearningData :: [(a, Rational)] } deriving (Show)

instance Monoid (LearningData a) where
  mempty = LearningData []
  LearningData x `mappend` LearningData y = LearningData $ x ++ y
  
instance F.Foldable LearningData where
  foldMap f (LearningData x) = F.foldMap f $ map (fst) x

selection :: MonadRandom m => LearningData a -> m (LearningData a)
selection x = do
  x' <-  fromList $ getLearningData x
  return $ LearningData [(x', 0)]

copyFxSettingData :: MonadRandom m => LearningData a -> m (LearningData a)
copyFxSettingData (LearningData x) = return $ LearningData [head x]
  
getHeadGaData :: LearningData a -> a
getHeadGaData (LearningData x) = fst $ head x

