-- backtracking
-- do kruhu umiestnite cisla 1..10 tak, aby sucet dvoch vedla stojacich nebol delitelny 3, 5 ani 7

type RiesenieKruh = [Int]

kruh :: [RiesenieKruh]
kruh = kruhBacktrack [1..10]

kruhBacktrack :: [Int] -> [RiesenieKruh]
kruhBacktrack [] = [[]]
kruhBacktrack cifry  = [ c : ciastocneRiesenie    | 
            c <- cifry, 
      ciastocneRiesenie <- kruhBacktrack (diff cifry [c]),
      kruhOK' (c : ciastocneRiesenie)]
            
kruhOK' :: [Int] -> Bool
kruhOK' xs | (length xs) < 10   = kruhOK xs
     | otherwise    = let a = (head xs) + (last xs) in a `mod` 3 > 0 && a `mod` 5 > 0  && a `mod` 7 > 0  && 
               kruhOK xs

kruhOK :: [Int] -> Bool
kruhOK [] = True
kruhOK [_] = True
kruhOK (x:y:ys) = let a = x + y in
                  a `mod` 3 > 0 && a `mod` 5 > 0  && a `mod` 7 > 0  && 
       kruhOK (y:ys)

diff :: (Eq a) => [a] -> [a] -> [a]
diff x y = [ z | z <- x, notElem z y]

{-
Main> kruh
[[1,3,8,5,6,2,9,4,7,10],[1,7,4,9,2,6,5,8,3,10],[1,10,3,8,5,6,2,9,4,7],[1,10,7,4,9,2,6,5,8,3],
[2,6,5,8,3,1,10,7,4,9],[2,6,5,8,3,10,1,7,4,9],[2,9,4,7,1,10,3,8,5,6],[2,9,4,7,10,1,3,8,5,6],
[3,1,10,7,4,9,2,6,5,8],[3,8,5,6,2,9,4,7,1,10],[3,8,5,6,2,9,4,7,10,1],[3,10,1,7,4,9,2,6,5,8],
[4,7,1,10,3,8,5,6,2,9],[4,7,10,1,3,8,5,6,2,9],[4,9,2,6,5,8,3,1,10,7],[4,9,2,6,5,8,3,10,1,7],
[5,6,2,9,4,7,1,10,3,8],[5,6,2,9,4,7,10,1,3,8],[5,8,3,1,10,7,4,9,2,6],[5,8,3,10,1,7,4,9,2,6],
[6,2,9,4,7,1,10,3,8,5],[6,2,9,4,7,10,1,3,8,5],[6,5,8,3,1,10,7,4,9,2],[6,5,8,3,10,1,7,4,9,2],
[7,1,10,3,8,5,6,2,9,4],[7,4,9,2,6,5,8,3,1,10],[7,4,9,2,6,5,8,3,10,1],[7,10,1,3,8,5,6,2,9,4],
[8,3,1,10,7,4,9,2,6,5],[8,3,10,1,7,4,9,2,6,5],[8,5,6,2,9,4,7,1,10,3],[8,5,6,2,9,4,7,10,1,3],
[9,2,6,5,8,3,1,10,7,4],[9,2,6,5,8,3,10,1,7,4],[9,4,7,1,10,3,8,5,6,2],[9,4,7,10,1,3,8,5,6,2],
[10,1,3,8,5,6,2,9,4,7],[10,1,7,4,9,2,6,5,8,3],[10,3,8,5,6,2,9,4,7,1],[10,7,4,9,2,6,5,8,3,1]]
-- 40 rieseni
-}
------------------------------------------------------------------------------------------------------------------

--backtrack2 farbnie grafu (na vstupe su dvojice Int ako zoznam hran, farba - zistujeme ci sa graf ofarbit tolkymi farbami)

check :: [(Int, Int)] -> [Int] -> Bool
check [] ohod = True
check ((x,y):xs) ohod = ohod!!(x-1) /= ohod!!(y-1) && check xs ohod


farbenie :: [(Int, Int)] -> Int -> [Int] -> [Int] -> [Int]   -- najpr vsetko ohodnotime a potom zistime ci je to dobre farbenie (blby backtrac bez orezavania)
farbenie hrany farba ohod [] = if check hrany ohod then ohod else []
farbenie hrany farba ohod (n:neohod) = f zoz  
                                     where zoz = [farbenie hrany farba (ohod++[f]) neohod  |f <- [1..farba]]
                                           f ([]:xs) = f xs
                                           f (x:xs) = x
                                           f [] = []

daSa :: [(Int, Int)] -> Int -> [Int] --n je tu pocet vrcholov, da sa zistit z hran
daSa hrany farba = farbenie hrany farba [] [1..n]
                    where n = maximum (map (\(x,y) -> max x y) hrany)
                              
--priklad petersenov graf
--daSa [(1,2),(1,6),(1,5),(2,7),(2,3),(3,4),(3,8),(4,5),(4,9),(5,10),(6,9),(6,8),(7,10),(7,9),(8,10)] 3                              

------------------------------------------------------------------------------------------------------------------
-- definujme Vyraz s konstruktormi pre celociselnu konstantu, 
-- premennu, scitanie, odcidanie, nasobenie, delenie, ...

data Vyraz =Konst Int |
      Plus Vyraz Vyraz |
      Minus Vyraz Vyraz |
      Krat Vyraz Vyraz |
      Deleno Vyraz Vyraz |
      Prem String
      deriving (Show)

-- definujme si konstantu typu Vyraz, na ktorej potom mozeme cvicit

v:: Vyraz
v = Plus (Krat (Prem "x") (Konst 5)) (Prem "y")

-- derivujme Vyraz podla premennej
derivuj  ::  String -> Vyraz -> Vyraz

derivuj _ (Konst _)  = Konst 0
derivuj prem (Plus p1 p2) = (Plus (derivuj prem p1) (derivuj prem p2))
-- derivacia rozdielu: doplnit na domacu ulohu :-)
derivuj prem (Krat p1 p2) = (Plus 
        (Krat (derivuj prem p1) p2)
        (Krat p1 (derivuj prem p2)))
-- derivacia podielu : doplnit (p1/p2)' = [p1' * p2 - p1 * p2'] / p2^2
derivuj prem (Prem prem')   | prem == prem'  = Konst 1
         | otherwise  = Konst 0

-- definujte zjednodusenie Vyrazu
zjednodus  :: Vyraz -> Vyraz  
          
-- okrem pravidiel predstavujucich nase zakladne matematicke povedomie 
-- (ktore zjednodusia nejaky podvyraz), napr:

zjednodus  (Plus (Konst 0) p2) = p2
zjednodus  (Plus p1 (Konst 0)) = p1
zjednodus  (Krat (Konst 1) p2) = p2
zjednodus  (Krat p1 (Konst 1)) = p1

-- potrebujeme aj pravidla, ktore nam Vyraz traverzuju, t.j.
zjednodus (Krat p1 p2)   = (Krat (zjednodus p1) (zjednodus p2))
-- a toto robime dokolecka, kym je co zjednodusovat. Ako zistime, ze uz nie je 
-- co zjednodusit (vzhladom na nase zakladne matematicke predstavy) ? 
-- na rozmyslenie ako domaca uloha...

{- ---------------------------------------------------------------------
na prednaske sme skusili BVS, a neurobili sme delete na binarnom vyhladavacom strome...
-}
data BVS t     = Nod (BVS t) t (BVS t) | Nil
        deriving (Eq, Show, Ord)
            
-- dobre je mat nejaku konstantu toho typu
b1 :: BVS Int
b1 = Nod (Nod Nil 4 Nil) 5 (Nod Nil 7 Nil) 
b2 :: BVS Int
b2 = Nod (Nod Nil 0 Nil) 1 (Nod Nil 2 Nil) 
b3 :: BVS Int
b3 = Nod b2 3 b1 

jeOzajBVS  :: BVS Int -> Bool
jeOzajBVS  Nil      = True
jeOzajBVS  (Nod left value right)  = (maxBVS left) <= value && value <= (minBVS right) &&
            jeOzajBVS left && jeOzajBVS right
                    
maxBVS    :: BVS Int -> Int
maxBVS    Nil  = -99999
maxBVS    (Nod left value right)  = max (maxBVS left) (max value (maxBVS right))

minBVS    :: BVS Int -> Int
minBVS    Nil  = 99999
minBVS    (Nod left value right)  = min (minBVS left) (min value (minBVS right))
                    
--- delete v BVS

deleteBVS  :: Int -> BVS Int -> BVS Int
deleteBVS  _ Nil  = Nil
deleteBVS  x (Nod left value right) |x == value= if left == Nil then right
                  else if right == Nil then left
                  else -- tazky pripad
                  let max = maxBVS left in
              Nod (deleteBVS max left) max right
          | x < value  = Nod (deleteBVS x left) value right
          | otherwise  = Nod left value (deleteBVS x right)


{-
ine riesenie (autor PP):

deleteBVS :: (Ord t) => t -> BVS t -> BVS t
deleteBVS _ Nil = Nil
deleteBVS x (Nod left value right)
            | x < value = Nod (deleteBVS x left) value right
            | x > value = Nod left value (deleteBVS x right)
deleteBVS x (Nod Nil value Nil) = Nil
deleteBVS x (Nod left value Nil)= left
deleteBVS x (Nod Nil value right) = right
deleteBVS x (Nod left value right) = Nod newleft rightmost right
                        where (newleft,rightmost) = dorightmost left
                     
dorightmost :: (Ord t) => BVS t -> (BVS t, t)
dorightmost (Nod left x Nil) = (left, x)
dorightmost (Nod left x right) = ((Nod left x r2t), r2e)
                        where (r2t, r2e) = dorightmost right
-}
        
{- ---------------------------------------------------------------------
Vypoèítajte: foldr (-) 0 [1..100] a foldl (-) 0 [1..100].

foldr (-) 0 [1..100] = (1-(2-(3-(4-...-(100-0))))) = 1-2 + 3-4 + 5-6 + ... + (99-100) = - 50

foldl (-) 0 [1..100] = (...(((0-1)-2)-3) ... - 100) = -5050


Vypoèítajte:
foldr (.) id [(+1), (*2), (*3)] 100 = ( (+1) . ( (*2) . ( (*3) . id))) 100 = 601

foldl (.) id [(+1), (*2), (*3)] 100 = ( ( id . (+1)) . (*2)) . (*3) 100 = 601

lebo:

((f . g) . h) x = (f . g) (h x) = f (g (h x))
(f . (g . h)) x = f ((g . h) x) = f (g (h x))

-}

{- ---------------------------------------------------------------------
Len pomocou funkcionálov foldr a/alebo foldl definujte funkciu 
mirror :: [Int] -> [Int] takú, že platí mirror xs = xs++(reverse xs), 
napríklad mirror [1,2,3,4,5] = [1,2,3,4,5,5,4,3,2,1]. 
Nesmiete pritom definova/pomenova žiadnu inú funkciu okrem mirror.
-}

mirror' xs = foldr (:) xs xs    -- prvy pokus :-)

-- mirror' [1..5] = [1,2,3,4,5,1,2,3,4,5]
-- chcelo by to reverse

rev xs = foldr (\x -> \y->y++[x]) [] xs
rev' xs = foldl (\x -> \y->y:x) [] xs

-- takze pre foldr (:) (rev xs) xs dostaneme:

mirror'' xs   = foldr (\x -> \y->y++[x]) xs xs

-- skusme bez opetatora ++
-- pripomenme si, ze  x (++) y = foldr (:) [] xs
mirror''' xs = foldr (:) (foldl (\x y -> y:x) [] xs) xs    

{- ---------------------------------------------------------------------
Na pripomenutie, funkcia map aplikuje funkciu na prvky zoznamu, 
napr. map f [a, b, c] = [f a, f b, f c]. 
Definujte vašu implementáciu funkcie myMap pomocou funkcie 
foldr resp. foldl,  t.j. nesmiete pritom definova žiadnu pomocnu 
funkciu okrem myMap. 
Lambda abstrakcia nie je definícia funkcie. Inými slovami, kvíz tvaru - dop¾òte otázniky:
myMap :: (a->b)->[a]->[b]
myMap zoz = ? foldr ? ? zoz, resp.  
myMap zoz = ? foldl ? ? zoz
-}

myMap f   = foldr (\x -> \y->(f x):y) []

myMap' f   = foldr ((:) . f) []

{- --------------------------------------------------------------------
 definujte myFilter pomocou foldr
-}

myFilter p = foldr ( (++) . \x->if p x then [x] else [] ) []

myFilter' p = foldr ( \x -> \y -> if p x then x:y else y) []

{- --------------------------------------------------------------------
  definujte funkciu priemer :: [Float] -> Float, ktora vypocita aritmeticky zoznamu [Float]
  priemer len pouzitim foldr
-}

priemer  xs = sum/count
    where (sum, count) = foldr (\x -> \(sum, count) -> (sum+x, count+1)) (0, 0) xs

{-
fold na matici
-}      

-- pocet nul vo vektore/matici
pocetNul  :: [Int] -> Int
pocetNul  = foldr (\x -> \y -> if x==0 then y+1 else y) 0

pocetNul'  :: [[Int]] -> Int
pocetNul'  = foldr (\x -> \y -> (pocetNul x)+y) 0

-- priemer prvkov v matici
-- vrati sucet a pocet prvkov vo vektore

sumCount xs = foldr (\x -> \(sum, count) -> (sum+x, count+1)) (0, 0) xs

scitaj (a,b) (c,d) = (a+c, b+d)

-- v matici
sumCount' xs = foldr (\x -> \(sum, count) -> scitaj (sumCount x) (sum, count)) (0, 0) xs

priemer'  :: [[Float]] -> Float
priemer'  = uncurry (/) . sumCount'
  
-- rozdiel max a minimalneho prvku vo vektore/matici
maxmin (x:xs) = foldr (\x (big, small) -> (max x big, min x small)) (x, x) xs  -- z riesenia O.Sviteka

maxminuj (a,b) (c,d) = (max a c, min b d) 

maxmin' xs = foldr (\x -> \maxmins -> maxminuj (maxmin x) maxmins) (-9999, 9999) xs

maxminRozdiel xs = (uncurry (-) . maxmin') xs


{------------------------- definujte funckie scanr a scanl

pozrime sa na funckie scanr a scanl, ktore su standardne v Haskelli:

-- analogia toho, co robi foldr, akurat pozbiera vsetky medzivysledky do zoznamu
scanr  :: (a -> b -> b) -> b -> [a] -> [b]
scanr f z [a, b, c] = [f a (f b (f c  z)), f b (f c  z), f c z, z]

-- scanr1 robi to iste, akurat miesto inicialnej hodnoty sa zoberie posledny prvok vstupneho zoznamu
scanr1 :: (a -> a -> a) ->      [a] -> [a]
scanr1 f  [a, b, c] = [f a (f b c), f b c, c]

-- laviciarska analogia sa vola scanl
-- robi to, co foldl, akurat pozbiera vsetky medzivysledky do zoznamu
scanl  :: (a -> b -> a) -> a -> [b] -> [a]
scanl f z [a, b, c] = [z, f z a, f (f z a) b, f (f (f z a) b) c]

-- opat klon scanl1 nepotrebuje inicializacnu hodnotu akumulatora, ale zoberie si prvy prvok zoznamu
scanl1 :: (a -> a -> a) ->      [a] -> [a]
scanl1 f  [a, b, c] = [a, f a b, f (f a b) c]
-}  

-- priklad pouzitia:
-- definujte fact pomocou scanl, scanr
fac n = facs !! n 
facs = scanl (*) 1 [1..] 

-- definujte 
until' :: (a -> Bool) -> (a -> a) -> a -> a

until' cond next val | cond val = val
                     | otherwise = until' cond next (next val)

-- definujte for pomocou until

for i n d = until' d n i

-- definujte fac pomocou for, until
fac' n = result (for init next done)
        where init = (0,1)
              next   (i,m) = (i+1, m * (i+1))
              done   (i,_) = i==n
              result (_,m) = m

-- definujte scanl a scanr rekurzivne ...

myScanr f z []     = [z]
myScanr f z (x:xs) = (f x last) : (last:rs)
          where (last:rs) = myScanr f z xs
        
myScanl f acc xs      = acc : (case xs of
       []   -> []
       x:xs -> myScanl f (f acc x) xs)

{-
Main> myScanr (*) 1 [1..5]
[120,120,60,20,5,1]
Main> scanr1 (*) [1..5]
[120,120,60,20,5]

Main> myScanl (*) 1 [1..5]
[1,1,2,6,24,120]

Main> scanl1 (*) [1..5]
[1,2,6,24,120]
-}        

-- definujte scanl a scanr pomocou foldr/foldl
-- definujte scanr1 a scanl1 pomocou scanr a scanl, foldr....

myScanr' f z = foldr (\x -> \y -> f x (head y):y) [z]
myScanr'' f z = foldr (\x -> \z@(y:ys) -> f x y:z) [z]

myScanr1 f xs = myScanr'' f (last xs) (init xs) 
--

myScanl' f z = foldl (\y -> \x -> y++[f (last y) x]) [z]
myScanl1 f xs = myScanl f (head xs) (tail xs)

scanl' f z xs = reverse (foldl (\x y -> f (head x) y : x) [z] xs)
scanl'' f z xs = foldl (flip (:)) [] (foldl (\x y -> f (head x) y : x) [z] xs)

