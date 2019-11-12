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
priemer  xs = uncurry (/) $ foldr (\x -> \(sum, count) -> (sum + x, count + 1))                                 (0, 0) xs
priemer' :: [Float] -> Float
priemer'  xs = uncurry (/) $ foldl (\(sum, count) -> \x -> (sum + x, count + 1))                                  (0, 0) xs

jerastuca' :: [Int] -> Bool
jerastuca' (x:xs) = snd $ foldl (\(pred, b) -> \x -> (x, (x > pred) && b))  (x, True) xs


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


-- Premia Autologia1 alias PUMPY
whereToStart :: [Float] -> [Float] -> [Int]
whereToStart dist lit = undefined

{-
whereToStart [9,1] [1,9] = [1]
whereToStart [1,2,3,4] [2,2,2,4] = [0,3]
whereToStart [1,2,5,3,2,3,4,5,6] [1,1,2,2,3,3,4,4,11] = [4,8] -- vid priložený obrá
-}
