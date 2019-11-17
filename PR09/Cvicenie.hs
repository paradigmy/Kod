module Cvicenie10 where

import Data.List

{---WARMUP-------------------------------------------}

-- aritmeticka postupnost je definovana prvym clenom a, a krokom (d-delta)
-- pomocou syntax Haskell sugar je to
ap :: Int -> Int -> [Int]
ap a d = [a, (a+d)..]

-- definujte ap bez tohoto syntax sugar
ap' :: Int -> Int -> [Int]
ap' a d = a:[x + d| x <- ap' a d]

-- a skuste este inak
ap'' a d = a : (ap'' (a+d) d)

-- a skuste este inak
ap''' a d = iterate (+d) a

-- a skuste este inak
ap'''' a d = foldl (\acc -> \n -> acc ++ [(last acc + d)]) [a] [1..]

-- a skuste este inak
ap''''' a d = [a + (i*d) | i <- [0..]]

-- a skuste este inak
ap'''''' a d = map (\i -> a + i*d) [0..]

-- definujte geometricku postupnost s prvym clenom a, kvocientom q, skuste niekolko rieseni, napadov, 
-- pomocou list comprehension, map, rekurzivne, ...
gp :: Int -> Int -> [Int]
gp a q = map (\i -> a * q ^ i) [0..]

gp' :: Int -> Int -> [Int]
gp' a q = undefined

gp'' :: Int -> Int -> [Int]
gp'' a q = undefined

{- --------------------------------------------------------------------------

Trojuholníkové čísla sú tvaru 1+2+...+n (lebo sa dajú ako guličky poskladať do trojuholníka). 
Príklad, 1,3,6,10,15,... Definujte ich ako nekonečný zoznam trojuholnikove. Skuste, aby bol usporiadany.
Definujte predikat (funkciu do Bool), ktory overi, ci cislo je trojuholnikove.
-} 
trojuholnikove  :: [Int]
trojuholnikove = tr 1 2

tr :: Int -> Int -> [Int]
tr a d = a:(tr (a+d) (d+1))

-- skuste este inak...
trojuholnikove' :: [Int]
trojuholnikove' = [i*(i+1) `div` 2| i <- [1..]]

jeTrojuholnikove  :: Int -> Bool
--jeTrojuholnikove t = any [t == i | i <- trojuholnikove] --zle
jeTrojuholnikove t = elemNekonecny t trojuholnikove

elemNekonecny :: Int -> [Int] -> Bool
elemNekonecny a [] = False
elemNekonecny a (x:xs) | x == a = True
                       | a < x = False
                       | otherwise = elemNekonecny a xs

{-
Odbľžnikové čísla sú zase také, že guličky sa dajú poskladať do obľžnika so stranami > 1. 
Príklad, 4,6,8,9,10,12,14,15,… Definujte ich ako nekonečný zoznam obĺžnikové. 
Definjte predikat na test jeObdlznikove...
-}

obdlznikove  :: [Int]
obdlznikove = filter(\n -> not (prvoc n)) [2..]

prvoc :: Int -> Bool
prvoc p = and[(p `mod` x)  > 0| x <- [2..(p `div` 2)]]

jeObdlznikove  :: Int -> Bool
jeObdlznikove o = elemNekonecny o obdlznikove

-- definujte funkciu elem', ktora v nekonecnom usporiadanom zozname najde prvok, ak sa tam nachadza, a nezacykli sa, ak nie
elem' :: Int -> [Int] -> Bool
elem'   = undefined

-- skuste to aj polymorfne
elem'' :: (Ord t) => t -> [t] -> Bool
elem'' a (x:xs) | x == a = True
                | a < x = False
                | otherwise = elem'' a xs

-- elem'' 6 [1,3..] = False
-- elem'' 7 [1,3..] = True

{-
Definujte funkciu prienik, ktorá vráti usporiadaný zoznam prvkov prieniku trojuholnikove a obĺžnikové. 
Príklad, take 5 prienik = [6,10,15,21,28].
-} 
                 
prienik (x:xs) (y:ys) |  x  <  y  =  (prienik  xs  (y:ys))
                      |  x  >  y  =  (prienik  (x:xs)  ys)
                      |  otherwise  =  x:(prienik  xs  ys)

-- prienik trojuholnikove obdlznikove = [6,10]

-- skuste definovat funkciu na prienik dvoch usporiadanych nekonecnych zoznamov, hint: merge bolo zjednotenie...
prienik'  :: [Int] -> [Int] -> [Int]
prienik'  = undefined

prienik''  :: (Ord t) =>[t] -> [t] -> [t]
prienik''  = undefined

-- z prednasky
merge [] x = x  
merge x [] = x
merge l1@(a:b) l2@(c:d)  |  a  <  c  =  a:(merge  b  l2)
                         |  a  >  c  =  c:(merge  l1  d)
                         |  otherwise  =  a:(merge  b  d)


--  pyramida  s  podstavou  stvorca  ma  v  jednotlivych  urovniach  n^2,  (n-1)^2,  ...,  3*3,  2*2,  1*1  guliciek.
--  definujte  pyramidove  cisla
-- 1, 5, 14, 30, 55, 91, 140, 204, 285, 385, 506, 650, 819
-- https://en.wikipedia.org/wiki/Square_pyramidal_number

pyramida4  =  undefined

