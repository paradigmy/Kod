
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
mirror :: [Int] -> [Int] takú, e platí mirror xs = xs++(reverse xs), 
napríklad mirror [1,2,3,4,5] = [1,2,3,4,5,5,4,3,2,1]. 
Nesmiete pritom definova/pomenova iadnu inú funkciu okrem mirror.
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
foldr resp. foldl,  t.j. nesmiete pritom definova iadnu pomocnu 
funkciu okrem myMap. 
Lambda abstrakcia nie je definícia funkcie. Inımi slovami, kvíz tvaru - dop¾òte otázniky:
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

