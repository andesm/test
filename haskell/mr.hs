import Control.Monad.Random

main = do
    g <- getStdGen
    let r = evalRand cfunc g :: Double
    -- or use runRand if you want to do more random stuff:
    -- let (r,g') = runRand (myFunc 1 2 3) g :: (Double,StdGen)
        b = r + 5
    putStrLn $ "Result is : " ++ show b

--my complicated func
cfunc :: (MonadRandom m) => m Double
cfunc = do
    ret <- getRandomR (0.0,1.0)
    return ret
    
