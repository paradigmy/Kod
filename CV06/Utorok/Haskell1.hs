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
fibLoop n a b = undefined

-- Dijkstrova logaritmicka formula
-- F(2j)   = F(j)^2 + F(j+1)^2
-- F(2j+1) = (2 * F(j) + F(j+1)) * F(j+1) 

step :: (Integer, Integer) -> (Integer, Integer)
step (fj, fj1) = (fj*fj + fj1*fj1, (2*fj + fj1)*fj1)

-- logaritmicky
fib'' :: Int -> (Integer, Integer)
fib'' n = undefined
                    
---------------------------------
-- scitajte kladne prvky zoznamu okolo, ktorych stoja nuly

nulyOkolo :: [Int] -> Int
nulyOkolo xs = undefined

{-
nulyOkolo [0,1,0] = 1
nulyOkolo [0,1,0,2,0] = 3
nulyOkolo [0,1,2,0] = 0
nulyOkolo [0,1,0,-2,0] = 1
-}

kazdyDruhy :: [t] -> [t]
kazdyDruhy xs = undefined

-- test, ci zoznam je usporiadany zoznam

usporiadany   :: [Int] -> Bool
usporiadany = undefined

-- priemer prvkov zoznamu
-- najivne tu znamena to, ze 2x ideme cez cely zoznam, lebo si nevieme zapamatat aj sucet aj pocet prvkov
priemer     :: [Float] -> Float
priemer xs   = undefined

type Kocka = [Int]
vsetky :: [Kocka]
vsetky = undefined
