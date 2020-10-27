module Haskell1 where

import Data.List -- vzdy sikovne nieco je v nom

-- fibonacci rekurzivne, len priklad syntaxe, typ+klauzalna definicia
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib(n-2)

-- fib 30
-- fib 40

-- Skusme to iterativne, "cyklom"
--fib' :: Int -> Int
--fib' :: Integer -> Integer
fib' n = fibLoop n 0 1

--fibLoop ::Int -> (Int -> (Int -> Int))
--fibLoop ::Integer -> Integer -> Integer -> Integer
fibLoop 0 a b = a
fibLoop n a b = fibLoop (n-1) b (a+b)

-- fib 50

-- Dijkstrova logaritmicka formula
-- F(2j)   = F(j)^2 + F(j+1)^2
-- F(2j+1) = (2 * F(j) + F(j+1)) * F(j+1) 

-- toto je funkcia, ktora dostane jeden argument (!!) a vrati jeden, ale vzdy je to dvojica
-- jedna dvojica nikdy nie su dva argumenty...
step :: (Integer, Integer) -> (Integer, Integer)
step (fj, fj1) = (fj*fj + fj1*fj1, (2*fj + fj1)*fj1)

-- logaritmicky
fib'' :: Int -> (Integer, Integer)
fib'' n | n <= 1    = ( 0, 1)
        | even n    = let npol = n `div` 2    in let xxx = fib'' npol in  step xxx
        | otherwise = let (a,b) = fib'' (n-1) in (b, a+b)
                 
-- zistite, ci cislo je clenom fib.postupnosti
isFib :: Int -> Bool
isFib f  = elem f [fib' i | i<-[1..f]]
-- fib f >= f                    
-- elem :: Eq a => a -> [a] -> Bool

isFib' :: Int -> Bool
isFib' f  = fibLoop f 0 1
            where 
                fibLoop :: Int -> Int -> Int -> Bool
                fibLoop f a b | f == a = True
                              | f < a  = False
                              | otherwise = fibLoop f b (a+b)

--------------------------------- TROCHU PRACE SO ZOZNAMOM
-- scitajte kladne prvky zoznamu okolo, ktorych stoja nuly
nulyOkolo :: [Int] -> Int
nulyOkolo []      = 0
nulyOkolo [_]      = 0
nulyOkolo [_,_]      = 0
nulyOkolo (0:x:0:xs)  = nulyOkolo (0:xs) + (if x > 0 then x else 0)
nulyOkolo (_:x:_:xs) = nulyOkolo xs
--[0,x,0,....]

{-
nulyOkolo [0,1,0] = 1
nulyOkolo [0,1,0,2,0] = 3
nulyOkolo [0,1,2,0] = 0
nulyOkolo [0,1,0,-2,0] = 1
-}

-- [3,4,5,6] = len 4
-- indexy ma 0,1,2,3
-- kazdy druhy prvok zo zoznamu, rozumie sa s parnym indexom
kazdyDruhy :: [t] -> [t]
kazdyDruhy xs = [ xs !!i | i <- [0,2..length xs-1] ]

kazdyDruhy' :: [t] -> [t]
kazdyDruhy' xs = map (\i -> xs!!i) [0,2..length xs-1]

kazdyDruhy'' :: [t] -> [t]
kazdyDruhy'' [] = []
kazdyDruhy'' [x] = [x]
kazdyDruhy'' (x:y:ys) = x : kazdyDruhy'' ys


-- test, ci zoznam je usporiadany zoznam
usporiadany   :: [Int] -> Bool
usporiadany [] = True
usporiadany [_] = True
usporiadany (x:ww@(y:xs)) = x < y && usporiadany ww


-- ako by sa to robilo, ak by sme chceli polymorficky zoznam
usporiadany'   :: Ord t => [t] -> Bool
usporiadany' [] = True
usporiadany' [_] = True
usporiadany' (x:ww@(y:xs)) = x < y && usporiadany' ww

-- priemer prvkov zoznamu
-- naivne tu znamena to, ze 2x ideme cez cely zoznam, lebo si nevieme zapamatat aj sucet aj pocet prvkov
priemer     :: [Float] -> Float
priemer xs   = sum xs / fromIntegral(length xs)

-- vygenerujte vsetky hracie kocky, dohodnime sa na nejakom plati kocky, aby sme mali rovnaku notaciu
{-
+                    a
++++                 bcde              ktorý kódujeme do šesť-prvkového zoznamu [a,b,c,d,e,f], teda a+f=b+d=c+e=7
+                    f
-}
allDifferent :: [Int] -> Bool
allDifferent xs = length (nub xs) == length xs

type Kocka = [Int]
vsetky :: [Kocka]  -- [[]]
vsetky = [ [a,b,c,7-b,7-c,7-a] | a <-[1..6], b <- [1..6], c <- [1..6], allDifferent [a,b,c,7-b,7-c,7-a] ]
