module Rozcvicka where
import Data.List


--  kombinacie  su,  ak  nezalezi  na  poradi

--  kombinacie  s  opakovanim  (n+k-1  nad  k)
kso :: [t] -> Int -> [[t]]
kso  _ 0 = [[]]
kso  [] _ = []
kso  (x:xs) k = [x:comb | comb <- kso (x:xs) (k-1)] ++ [comb | comb <- kso xs k]

{-
Main>  length(kso  [1..8]  4)
330
-}


--  kombinacie  bez  opakovania  (n  nad  k)
kbo :: [t] -> Int -> [[t]]
kbo  _ 0 = [[]]
kbo  [] _ = []
kbo  (x:xs) k = [x:comb | comb <- kbo xs (k-1)] ++ [comb | comb <- kbo xs k]
{-
Main>  length(kbo  [1..8]  4)
70
-}

--  variacie,  ak  zalezi  na  poradi
--  variacie  s  opakovanim  -  n^k
vso :: [t] -> Int -> [[t]]
vso _ 0  = [[]]
vso xs k = [ x:var | x <- xs, var <- vso xs (k-1)]
{-
Main>  length(vso  [1..8]  4)
4096
-}

--  variacie  bez  opakovania  -  n.(n-1)....(n-k+1)
vbo :: Eq(t) => [t] -> Int -> [[t]]
vbo _ 0  = [[]]
vbo xs k = [ x:var | x <- xs, var <- vbo (xs \\ [x]) (k-1)]
{-
Main>  length(vbo  [1..8]  4)
1680
-}
