import  Data.List
--  kombinacie  bez  opakovania  (n  nad  k)
kbo          :: [t] -> Int -> [[t]]   -- n nad k
kbo _ 0      = [ [] ]                     -- n nad 0 = 1
kbo [] k     = []
kbo (x:xs) k = kbo xs k   ++ [x:t | t <- kbo xs (k-1) ]  -- n+1 nad k = n nad k + n nad (k-1)

{-
Main>  length(kbo  [1..8]  4)
70
-}

kso          :: [t] -> Int -> [[t]]   
kso _ 0      = [ [] ]                    
kso [] k     = []
kso (x:xs) k = kso xs k   ++ [x:t | t <- kso (x:xs) (k-1) ]   

{-
Main>  length(kso  [1..8]  4)
330
-}

--  variacie,  ak  zalezi  na  poradi
--  variacie  s  opakovanim  -  n^k
vso :: [t] -> Int -> [[t]]
vso _  0 = [ [] ]
vso [] k = []
vso xs k = [x:ys | x <- xs, ys <- vso xs (k-1)]

{-
Main>  length(vso  [1..8]  4)
4096
-}

--  variacie  bez  opakovania  -  n.(n-1)....(n-k+1)
vbo ::  Eq(t) => [t] -> Int -> [[t]]
vbo _  0 = [ [] ]
vbo [] k = []
vbo xs k = [x:ys | x <- xs, ys <- vbo (xs\\[x]) (k-1)]

{-
Main>  length(vbo  [1..8]  4)
1680
-}

-- z prednasky, permutacie bez opakovania
pbo :: Eq(t) => [t] -> [ [t] ]
pbo [] = [ [] ]
pbo xs = [ x:p | x <- nub xs, p <- pbo (xs \\ [x])   ]

pso :: Eq(t) => [t] -> [ [t] ]
pso [] = [ [] ]
pso xs = [ x:p | x <- xs, p <- pso (xs \\ [x])   ]

-- z prednasky, permutacie bez opakovania

