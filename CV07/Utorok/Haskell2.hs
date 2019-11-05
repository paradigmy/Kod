module Haskell2 where
import Data.List

-- definujte mnozinu pozmnozin nejakej mnoziny, je ich 2^N

powerSet :: [t] -> [[t]]
powerSet [] = [[]]
powerSet (x:xs) =   [x:p | p <- pom]++pom
                    where pom = powerSet xs

{-
Haskell2> powerSet [1,2,3]
[[],[3],[2],[2,3],[1],[1,3],[1,2],[1,2,3]]
*Haskell2> length $ powerSet [1..10]
1024
-}

--  podmnoziny  mnoziny  a
data  SubSet  a  =  Set  [a]  deriving  (Show)

--  toto  nejde...    
--  type  SubSet  a  =    [a]

-- definujeme rovnost pre takyto typ
instance  Eq  a => Eq  (SubSet  a)  where
     Set  x  ==  Set  y            =  (x  ==  y)
     Set  x  /=  Set  y            =  (x  /=  y)

-- definujeme mensi ako pre takyto typ
instance  Eq  a  => Ord  (SubSet  a)    where
     Set  x  <=  Set  y  =    and [elem  a y | a <- x]    --  ?????????????????
     a  >=  b    =  b  <=  a
     a  <  b    =  a  <=  b  &&  a  /=  b
     a  >  b    =  b  <  a
     max  (Set  x)  (Set  y)  =  Set (nub (x ++ y)) -- ???????????????????????
     min  (Set  x)  (Set  y)  =  Set [a | a <- x, elem a y] -- ???????????????????????

-- toto bolo na prednaske
qs    ::  (Ord  a)  =>  [a]  ->  [a]
qs  []    =  []
qs  (b:bs)    =  qs  [x  |  x  <-  bs,  x  <=  b]  
                 ++  [b]  ++  
                 qs  [x  |  x  <-  bs,  not(x  <=  b)]

powerSet'  ::  [a]  ->  [ SubSet  a ]
powerSet'  []        =  [ Set  []]
powerSet'  (x:xs)    =  [ Set (x:s) | Set s <- pom]  ++  pom where pom = powerSet' xs


{-
Haskell2> qs $ powerSet' [1..4]
[Set [],Set [1],Set [2],Set [1,2],Set [3],Set [1,3],Set [2,3],Set [1,2,3],Set [4],Set [1,4],Set [2,4],Set [1,2,4],Set [3,4],Set [1,3,4],Set [2,3,4],Set [1,2,3,4]]
-}


--  kombinacie  su,  ak  nezalezi  na  poradi

--  kombinacie  s  opakovanim  (n+k-1  nad  k)
kso :: [t] -> Int -> [[t]]
kso  _  0    =  [[]]
kso  []  _  =  []
kso  (x:xs)  k  =  [x:y  |  y  <-kso  (x:xs)  (k-1)]  ++  kso  xs  k
{-
Main>  length(kso  [1..8]  4)
330
-}


--  kombinacie  bez  opakovania  (n  nad  k)
kbo :: [t] -> Int -> [[t]]
kbo  _  0    =  [[]]
kbo  []  _  =  []
kbo  (x:xs)  k  =  [x:y  |  y  <-kbo  xs  (k-1)]  ++  kbo  xs  k

{-
Main>  length(kbo  [1..8]  4)
70
-}

--  variacie,  ak  zalezi  na  poradi
--  variacie  s  opakovanim  -  n^k
vso :: [t] -> Int -> [[t]]
vso  _  0    =  [[]]
vso  []  _  =  []
vso  xs  k  =    [  x:y  |  x  <-  xs,  y  <-  vso  xs  (k-1)]

{-
Main>  length(vso  [1..8]  4)
4096
-}

--  variacie  bez  opakovania  -  n.(n-1)....(n-k+1)
vbo :: Eq(t) => [t] -> Int -> [[t]]
vbo  _  0    =  [[]]
vbo  []  _  =  []
vbo  xs  k  =    [  x:y  |  x  <-  xs,  y  <-  vbo  (xs  \\  [x])  (k-1)]

{-
Main>  length(vbo  [1..8]  4)
1680
-}
