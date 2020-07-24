import Control.Monad.State

type Stack = [Int]

pop :: State Stack Int
pop = state $ \(x:xs) -> (x, xs)

push :: Int -> State Stack ()
push a = state $ \xs -> ((), a:xs)

popAll :: State Stack ()
popAll = do
  now <- get
  if now == []
    then return ()
    else do pop
            popAll

stackMainp :: State Stack ()
stackMainp  = do
  push 3
  push 3
--  popAll
  
  
