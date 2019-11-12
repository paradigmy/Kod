{- ---------------------------------------------------------------------
Len pomocou funkcionálov foldr a/alebo foldl definujte funkciu 
mirror :: [Int] -> [Int] takú, že platí mirror xs = xs++(reverse xs), 
napríklad mirror [1,2,3,4,5] = [1,2,3,4,5,5,4,3,2,1]. 
Nesmiete pritom definova/pomenova žiadnu inú funkciu okrem mirror.
-}

mirror xs = undefined

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

myMap f   = undefined

{- --------------------------------------------------------------------
 definujte myFilter pomocou foldr
-}

myFilter p = undefined

{- --------------------------------------------------------------------
  definujte funkciu priemer :: [Float] -> Float, ktora vypocita aritmeticky zoznamu [Float]
  priemer len pouzitim foldr
-}

-- toto bolo na prednaske...
priemer :: [Float] -> Float
priemer  xs = undefined

{-
fold na matici
-}      
priemerM :: [[Float]] -> Float
priemerM = undefined

-- rozdiel max a minimalneho prvku vo vektore/matici
maxminRozdiel :: [Int] -> Int
maxminRozdiel xs = undefined


-- jeRastuca
jeRastuca :: [Int] -> Bool
jeRastuca xs = undefined

