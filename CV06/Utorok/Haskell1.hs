module Haskell1 where

import Data.List -- vzdy sikovne nieco je v nom

-- rekurzivne
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = (fib (n-1)) + (fib (n-2))

-- iterativne, "cyklom"


fib' :: Integer -> Integer
fib' n = fibLoop n 0 1

fibLoop ::Integer -> Integer -> Integer -> Integer
fibLoop 0 a b = a
fibLoop n a b = fibLoop(n-1) b (a + b)

-- Dijkstrova logaritmicka formula
-- F(2j)   = F(j)^2 + F(j+1)^2
-- F(2j+1) = (2 * F(j) + F(j+1)) * F(j+1) 

step :: (Integer, Integer) -> (Integer, Integer)
step (fj, fj1) = (fj*fj + fj1*fj1, (2*fj + fj1)*fj1)

-- logaritmicky
fib'' :: Int -> (Integer, Integer)
fib'' n | n < 2 = (0,1)
        | even n = step (fib'' (n `div` 2))
        | otherwise = (b,a+b) 
          where (a,b) = fib'' (n-1)
                    
---------------------------------
-- scitajte kladne prvky zoznamu okolo, ktorych stoja nuly

nulyOkolo :: [Int] -> Int
nulyOkolo [] = 0
nulyOkolo (0:y:0:ys) = nulyOkolo(0:ys) + (if y > 0 then y else 0) 
nulyOkolo (y:ys) = nulyOkolo ys

{-
nulyOkolo [0,1,0] = 1
nulyOkolo [0,1,0,2,0] = 3
nulyOkolo [0,1,2,0] = 0
nulyOkolo [0,1,0,-2,0] = 1
-}

kazdyDruhy :: [t] -> [t]
kazdyDruhy [] = []
kazdyDruhy [x] = []
kazdyDruhy (x:y:xs) = (y:kazdyDruhy xs)

-- test, ci zoznam je usporiadany zoznam

usporiadany   :: [Int] -> Bool
usporiadany = undefined

-- priemer prvkov zoznamu
-- najivne tu znamena to, ze 2x ideme cez cely zoznam, lebo si nevieme zapamatat aj sucet aj pocet prvkov
priemer     :: [Float] -> Float
priemer xs   = undefined

type Kocka = [Int]
vsetky :: [Kocka]
vsetky = [[a,b,c,7-b,7-c,7-a] | a <- [1..6], b <- [1..6]\\[a,7-a], c <- [1..6]\\[a,b,7-a,7-b]]
