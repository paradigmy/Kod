module Haskell1 where

import Data.List -- vzdy sikovne nieco je v nom

-- rekurzia na cislach

-- fibonacci klasicky, pozor na zatvorkovanie !!!
-- zle riesenie (syntakticky ok, semanticky stack overflow)
fib      :: Int -> Int
fib  0  =  1
fib 1  =  1
fib n  =   fib n-1+fib n-2
-- preco je zle ???

-- pascalovsky styl
fib'    :: Int -> Int
fib'(0)  =  1
fib'(1)  =  1
fib'(n)  =   fib'(n-1)+fib'(n-2)

-- syntax case
fib''    :: Int -> Int
fib'' n    = case n of
              0  ->  0;
              1  ->   1;
              m  -> fib''(m-1)+fib''(m-2)
  
-- iterativne
fibi    :: Int -> Int -> Int -> Int
fibi 0 a b  = b
fibi n a b   = fibi (n-1) (a+b) a

-- iterativne, pascalovsky styl (zatvorkovania)
fibi'  :: (Int, Int, Int) -> Int
fibi'(0,a,b)  = b
fibi'(n,a,b)   = fibi'(n-1,a+b,a)


fyb :: Int -> Int
fyb n | n < 2 = 1
      | otherwise = fyb (n-2) + fyb (n-1)

fyb' :: Int -> Int
fyb' n = fybLoop n 1 1
         where fybLoop 0 a b = a
               fybLoop n a b = fybLoop (n-1) b (a+b)

-- Dijkstrova logaritmicka formula
-- F(2j)   = F(j)^2 + F(j+1)^2
-- F(2j+1) = (2 * F(j) + F(j+1)) * F(j+1) 

step :: (Integer, Integer) -> (Integer, Integer)
step (fj, fj1) = (fj*fj + fj1*fj1, (2*fj + fj1)*fj1)

fyb'' :: Int -> (Integer, Integer)
fyb'' n | n < 2  = (0,1)
        | even n = let (fj, fj1) = fyb'' (n `div` 2) in step (fj, fj1)
        | otherwise = (fj1, fj+fj1)
                      where (fj, fj1) = fyb'' (n - 1)
                    
-- ako zistit dlzku cisla, toString a length
-- length $ show $ snd $ fyb'' 1000000           

{-
*Haskell1> length $ show $ snd $ fyb'' 1000000
208988
*Haskell1> length $ show $ snd $ fyb'' 10000000
2089877
*Haskell1> length $ show $ snd $ fyb'' 100000000
20898764
*Haskell1> length $ show $ snd $ fyb'' (10^9)
208987640
-}         
---------------------------------
-- scitajte kladne prvky zoznamu okolo, ktorych stoja nuly

nulyOkolo :: [Int] -> Int
nulyOkolo [] = 0
nulyOkolo [_] = 0
nulyOkolo [_,_] = 0
nulyOkolo (0:y:0:zs) = (if y > 0 then y else 0) + nulyOkolo (0:zs)
nulyOkolo (x:xs)  = nulyOkolo xs

{-
nulyOkolo [0,1,0] = 1
nulyOkolo [0,1,0,2,0] = 3
nulyOkolo [0,1,2,0] = 0
nulyOkolo [0,1,0,-2,0] = 1
-}

kazdyDruhy :: [t] -> [t]
kazdyDruhy [] = []
kazdyDruhy [x] = [x]
kazdyDruhy (x:y:xs) = x:(kazdyDruhy xs)
                    

------ booleovske funkcie

neparneCislo   :: Int -> Bool
neparneCislo 0  = False
neparneCislo 1  = True
neparneCislo n  = neparneCislo (n-2)

-- dokonale cislo je cislo, ktore je rovne suctu jeho vlastnych delitelov
dokonale    :: Int -> Bool
dokonale x     = (sum (delitele x)) == x 

-- delitele cisla do zoznamu
delitele   :: Int -> [Int]
delitele x   = delitele' x 1

-- delitele inak
delitele'  :: Int -> Int -> [Int]
delitele' x i = if i < x then
      if x `mod` i == 0 then
      i:delitele' x (i+1)
      else
      delitele' x (i+1)
    else
      []
        
-- vytvorenie zoznamu [n, ... , 5,4,3,2,1]
gener  :: Int -> [Int]
gener  0  = []
gener  n  = n:gener(n-1)

-- rozdelenie zoznamu na dvojicu zoznamov, parnych a neparnych cisel
gener2  ::  Int -> ([Int], [Int])
gener2  0  = ([], [])
gener2  n  |  even n  = (n:parne, neparne)
      | otherwise  = (parne, n:neparne)
      where (parne, neparne) = gener2 (n-1)
      
----------------------------- rekurzia na zoznamoch      

-- posledny prvok zoznamu

posledny []      = error "prazdny zoznam nema posledny prvok"
posledny [x]    = x
posledny (x:xs)    = posledny xs

-- prvok sa nachadza v zozname
nachadzaSa       :: Int -> [Int] -> Bool
nachadzaSa  _ []  = False
nachadzaSa  x (y:xs)  | x == y  = True
            | otherwise = nachadzaSa x xs

-- test, ci zoznam je usporiadany zoznam

usporiadany        :: [Int] -> Bool
usporiadany []      = True
usporiadany [_]      = True
usporiadany (x:y:ys)  | x < y    = usporiadany (y:ys)
            | otherwise  = False
-- ina verzia

usporiadany'    :: [Int] -> Bool
usporiadany' []    = True
usporiadany' [_]  = True
usporiadany' (x:y:ys)  = x < y && usporiadany' (y:ys)

-- este ina verzia
usporiadany''    :: [Int] -> Bool
usporiadany'' xs  = length xs < 2 || ( head xs < head (tail xs) && usporiadany'' (tail xs) )

-- este-este ina verzia

usporiadany'''    :: [Int] -> Bool
usporiadany''' []    = True
usporiadany''' [_]  = True
usporiadany''' (x:xs@(y:ys))  = x < y && usporiadany''' xs

-- test, ci v zozname sa opakuje jeden prvok hned za nim
opakujeSa  ::  [Int]  ->  Bool
opakujeSa  []  = False
opakujeSa  [_]  = False
-- toto nejde, pretoze je tam nelinearny pattern- pattern, ktory obsahuje 2xtu istu premennu- co je skryty test
-- opakujeSa  (x:x:_)  = True

-- toto zase nefunguje preto, ze sa vzdy pouzije 3.klauzula, na 4, uz ani nepride, priklad opakujeSa [1,2,2] = False
-- opakujeSa  (x:y:_) = x == y
-- opakujeSa  (x:xs)  = opakujeSa xs

-- takze...
opakujeSa (x:y:ys)  = (x == y) || opakujeSa (y:ys)
-- alebo
--opakujeSa (x:y:ys)  = if (x == y) then True else opakujeSa (y:ys)

-- scitaj neparne cisla zoznamu [Int], ktore su sprava aj zlava oblozene 0

neparne       :: [Int] -> Int
neparne (0:x:0:xs)  = (if odd x then x else 0) + neparne (0:xs)
neparne (x:xs)    = neparne xs
neparne _       = 0

-- priemer prveho zoznamu
-- najivne tu znamena to, ze 2x ideme cez cely zoznam, lebo si nevieme zapamatat aj sucet aj pocet prvkov
priemerNajivne     :: [Float] -> Float
priemerNajivne xs   = (sum xs) / fromIntegral(length xs)

-- teraz uz si to vieme zapamatat, staci si uvedomit, ze funkcia sice moze vratit len jednu hodnotu,
-- ale ta moze byt dvojica... Potom sa nam hodi porovnazanie s patternom vo where klauzule
priemer       :: [Float] -> Float
priemer xs = sum / fromIntegral(count) where
          (sum, count) = sumCount xs

sumCount       :: [Float] -> (Float,Int)
sumCount []      = (0,0)
sumCount (x:xs)    = (sum+x, count+1) where 
            (sum, count) = sumCount xs

-- zipovanie zoznamov
-- dva zoznamy [a1,a2, ...] [b1, b2, ...] zozipsuje do [a1,b1,a2,b2, ...], chvost je z dlhsieho...
zipZoznamy      ::  [Int] -> [Int] -> [Int]
zipZoznamy  [] ys  = ys
zipZoznamy  xs []  = xs
zipZoznamy   (x:xs) (y:ys) = x:y:zipZoznamy xs ys

-- zoberie dva usporiadane zoznamy a spoji ich do jedneho
merge    :: [Int] -> [Int] -> [Int]
merge [] ys  = ys
merge xs []  = xs
merge (x:xs) (y:ys)  | x < y  = x:merge xs (y:ys)
          | otherwise = y:merge (x:xs) ys
  
-- pivotizacia do quicksortu
-- rozdel prvy zoznamu na tie, ktore su mensie ako prvy prvok, a na vacsie rovne ako prvy prvok                  
pivot  :: [Int] -> ([Int], [Int])
pivot (x:xs)  = (liliputani x xs, maxiputani x xs)          
liliputani p xs = filter (<p) xs
maxiputani p xs = filter (>=p) xs

-- skalarny sucin dvoch rovnako dlhych zoznamov
skalarnySucin    :: [Int] -> [Int] -> Int
skalarnySucin  [] ys  = 0
skalarnySucin  xs []  = 0
skalarnySucin   (x:xs) (y:ys)  = x*y + skalarnySucin xs ys

---------------------- matice

type Riadok   = [Int]
type Matica   = [Riadok]

-- vytvor jednotkovu maticu
vyrobJednotkovuMaticu :: Int -> Matica
 
vyrobJednotkovuMaticu 0   = []
vyrobJednotkovuMaticu nn = (1:vyrobPrvyRiadok n):m'  
      where
      n = nn-1
      m = vyrobJednotkovuMaticu n
      m' = kazdemuRiadkuPridajNulu m

kazdemuRiadkuPridajNulu      :: Matica -> Matica
kazdemuRiadkuPridajNulu []    = []
kazdemuRiadkuPridajNulu (r:rs)  = (0:r):kazdemuRiadkuPridajNulu rs

vyrobPrvyRiadok       :: Int -> Riadok
vyrobPrvyRiadok 0      = []
vyrobPrvyRiadok n    = 0:vyrobPrvyRiadok (n-1)

-- scitovanie dvoch matic rovnakeho rozmeru
scitajMatice        :: Matica -> Matica -> Matica
scitajMatice (r:rs) (q:qs)  = (scitajRiadky r q):scitajMatice rs qs
scitajMatice [] []      = []

scitajRiadky [] []      = []
scitajRiadky (x:xs) (y:ys)  = (x+y):scitajRiadky xs ys

prvyStlpec          :: Matica -> Riadok
prvyStlpec []        = []
prvyStlpec ((x:r):rs)    = x:prvyStlpec rs

okremPrvehoStlpca      :: Matica -> Matica
okremPrvehoStlpca  []    = []
okremPrvehoStlpca((x:r):rs)  = r:okremPrvehoStlpca rs

-- transponuj maticu
transponuj           :: Matica -> Matica
transponuj  []        = []
transponuj  rs        = (prvyStlpec rs):(transponuj (okremPrvehoStlpca rs))

----- 
parNepar :: [Int] -> Int
parNepar xs = (sum (filter even xs)) - (sum (filter odd xs))

sudeLiche :: [Int] -> Int
sudeLiche xs = sum [ xs!!i * (-1)^i | i <- [0..length xs-1] ]