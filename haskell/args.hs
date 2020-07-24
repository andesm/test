import Data.Monoid
import Control.Monad
import Options.Applicative

data Sample = Sample
  { hello  :: String
  , quiet  :: Bool
  , repeat :: Int }

sample :: Parser Sample
sample = Sample
     <$> strOption
         ( long "hello"
        <> metavar "TARGET"
        <> help "Target for the greeting" )
     <*> switch
         ( long "quiet"
        <> short 'q'
        <> help "Whether to be quiet" )
     <*> option auto
         ( long "repeat"
        <> help "Repeats for greeting"
        <> showDefault
        <> value 1
        <> metavar "INT" )

greet :: Sample -> IO ()
greet (Sample h False n) = replicateM_ n $ putStrLn $ "Hello, " ++ h
greet _ = return ()

main :: IO ()
main = execParser opts >>= greet
  where
    opts = info (helper <*> sample)
      ( fullDesc
     <> progDesc "Print a greeting for TARGET"
     <> header "hello - a test for optparse-applicative" )
