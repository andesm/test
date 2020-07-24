import Data.Monoid
import Data.Char
import Text.Read
import Options.Applicative

data Mode = Foo | Bar | Baz deriving (Show, Read, Enum, Bounded)

data Options = Options
    { verbose        :: Bool
    , limit          :: Int
    , mode           :: Mode
    , outputFileName :: String
    , inputFiles     :: [FilePath]
    } deriving Show

verboseP :: Parser Bool
verboseP = switch $ short 'v' <> long "verbose" <> help "verbose mode"

limitP :: Parser Int
limitP = option $ mconcat 
    [ short 'l', long "limit"
    , help "limit"
    , metavar "INT"
    , value 0
    , showDefault
    ]

outputFileNameP :: Parser String
outputFileNameP = strOption $ mconcat
    [ short 'o', long "output"
    , help "output file"
    , metavar "FILE"
    , value "output.txt"
    , showDefaultWith id
    ]

inputFileP :: Parser FilePath
inputFileP = argument Just $ mconcat
    [ help "input files"
    , metavar "FILE"
    , completer $ bashCompleter "file"
    ]

inputFilesP :: Parser [FilePath]
inputFilesP = some inputFileP

modeReader :: Monad m => String -> m Mode
modeReader []     = fail "no input"
modeReader (c:cs) = case readMaybe $ toUpper c : map toLower cs of
    Nothing -> fail $ "unknown mode: " ++ c:cs
    Just m  -> return m

modeP :: Parser Mode
modeP = nullOption $ mconcat
    [ short 'm', long "mode"
    , help "mode"
    , value Foo
    , showDefault
    , metavar "MODE"
    , reader modeReader
    , completer $ listCompleter $ concatMap 
        ((\s -> [s, map toLower s]) . show) [minBound .. maxBound :: Mode]
    ]

optionsP :: Parser Options
optionsP = (<*>) helper $ 
    Options <$> verboseP <*> limitP <*> modeP <*> outputFileNameP <*> inputFilesP

myParserInfo :: ParserInfo Options
myParserInfo = info optionsP $ mconcat 
    [ fullDesc
    , progDesc "test program."
    , header "header"
    , footer "footer"
    , progDesc "progDesc"
    ]

main :: IO ()
main = execParser myParserInfo >>= print
