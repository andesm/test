import System.Random

rollDice :: IO Int
rollDice = getStdRandom (randomR (1,6))

main :: IO ()
main = rollDice >>= print 
