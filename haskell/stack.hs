import Debug.Trace

type Stack = [Integer]


calc :: (Integer -> Integer -> Integer) -> Stack -> ((Integer), Stack)
calc op = \stack ->
    let
        (i1, stack1) = pop stack
        (i2, stack2) = pop stack1
        (_, stack3)  = push (op i1 i2) stack2
    in
      ((op i1 i2), stack3)

add = calc (+)
sub = calc (-)
mul = calc (*)
dvv = calc div

popp :: Stack -> (Integer, Stack)
popp = pop `bind` \_ -> pop

poppp :: Stack -> (Integer, Stack)
poppp = pop `bind` \_ -> pop `bind` \_ -> pop

pushshop :: Stack -> (Integer, Stack)
pushshop = (push 1) `bind` \_ -> (push 2) `bind` \_  -> pop



--- \s -> let (i1, s1) = pop s in  (\i1 -> pop i1) s1

--- \s -> let (i0, s1) = (\s -> let (i1, s1) = pop s in (\i1 -> pop i1) s1) s
---       let (i0, s1) = (let (i1, s1) = pop s in pop s1)
----      in  ((\i2 -> push (op i1 i2)) i0) s1
----      in  (push (op i1 i0)) s1

---popopu :: (Integer -> Integer -> Integer) -> Stack -> (Integer, Stack)
---popopu op = \s -> let (i0, s1) = let (i1, s1) = pop s in pop s1
---in  (push (op i1 i0)) s1
---

--  (\x -> (\y -> x + y))


calc2 :: (Integer -> Integer -> Integer) -> (Stack -> (Integer, Stack))
calc2 op = pop `bind` (\i1 -> (pop `bind` (\i2 -> push (op i1 i2))))

calc5 :: (Integer -> Integer -> Integer) -> Stack -> (Integer, Stack)
calc5 op = pop `bind` \i -> pop `bind` \i -> push (op i i)

calc4 :: (Integer -> Integer -> Integer) -> Stack -> (Integer, Stack)
calc4 op = pop `bind` \i -> push (op 20 i) `bind`  \i -> push (op 300 i)

--- ------------------------

push :: Integer -> Stack -> (Integer, Stack)
push c cs = (c, c:cs)

pop :: Stack -> (Integer, Stack)
pop (c:cs) = (c,cs)

bind :: (Stack -> (Integer, Stack)) -> (Integer -> (Stack -> (Integer, Stack))) -> (Stack -> (Integer, Stack))
bind opstack1 opstack2 = \s -> let (i1, s1) =  opstack1 s
                               in  (opstack2 i1) s1

calc6 :: (Integer -> Integer -> Integer) -> Stack -> (Integer, Stack)
calc6 op = pop `bind` \i1 -> pop `bind` \i2 -> push (op i1 i2)

--- 
--- \s -> let (i2, s2) = (\sa -> let (i1, s1) = pop sa
---                              in  ((\k -> pop) i1) s1) s
----      in  ((\j -> (push (op i1 j)) i2) s2

--- \s -> let (i2, s2) (\s -> let (i1, s1) = pop s in  ((\i1 -> pop) i1) s1)
---       in  )

calc3 :: (Integer -> Integer -> Integer) -> (Stack -> (Integer, Stack))
calc3 op = let x = bind pop (\i1 -> pop)
           in bind x (\i2 -> (push 5))

main = print (calc3 (+) [1,2,3])

---strpop :: [Integer] -> [Integer]
---strpop (c:cs) = cs

---bind2 :: ([Integer] -> [Integer]) -> ([Integer] -> ([Integer] -> [Integer])) -> ([Integer] -> [Integer])
---bind2 f1 f2 = \s -> let s1 = f1 s
---                    in  f2 s

---str :: [Integer] -> [Integer]
---str s2 = strpop `bind2` \s -> strpop

---calc3 :: (Integer -> Integer -> Integer) -> Stack -> (Integer, Stack)
---calc3 op = bind (bind pop (\i1 -> pop))  (\i2 -> push (op i1 i2))
 
--- s = [0..10]
--- a = \s -> let i = 1 in ((\i -> max i) s)
--- op = \i -> max i

--- a1 = \s -> let i = 100 in ((\b -> max) s) i
--- a1 :: (Ord a, Num a) => t -> a -> a
--- a2 = \s -> let i = 100 in ((\b -> max b) s) i
--- a2 :: (Ord a, Num a) => a -> a
