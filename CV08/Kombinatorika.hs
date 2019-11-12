module Haskell2 where
import Data.List

-- definujte mnozinu pozmnozin nejakej mnoziny, je ich 2^N
powerSet :: [t] -> [[t]]
powerSet [] = [[]]
powerSet (x:xs)   = pom ++ [ x:p | p<-pom] where pom = powerSet xs

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


{-- 2 cierne a 3 cervene kocky vo vezi na sebe
Haskell2> kbo [1,1,2,2,2] 2
[[1,1],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[2,2],[2,2],[2,2]]
*Haskell2> length $ kbo [1,1,2,2,2] 2
10
2 cierne a 4 cervene kocky vo vezi na sebe
*Haskell2> kbo [1,1,2,2,2,2] 2
[[1,1],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[2,2],[2,2],[2,2],[2,2],[2,2],[2,2]]
*Haskell2> length $ kbo [1,1,2,2,2,2] 2
15
--}