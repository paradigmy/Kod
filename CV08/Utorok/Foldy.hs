{- ---------------------------------------------------------------------
Len pomocou funkcionálov foldr a/alebo foldl definujte funkciu 
mirror :: [Int] -> [Int] takú, že platí mirror xs = xs++(reverse xs), 
napríklad mirror [1,2,3,4,5] = [1,2,3,4,5,5,4,3,2,1]. 
Nesmiete pritom definova/pomenova žiadnu inú funkciu okrem mirror.
-}

--mirror xs = foldr (\x -> \rec  -> rec ++ [x] ) xs xs
mirror xs = 
        let xsR = reverse xs in
        foldl  (\acc -> \x -> x:acc) xsR xsR

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

--myMap f xs  = foldr (\x -> \rec -> (f x):rec) []  xs
myMap f xs  = foldl (\acc -> \x -> acc ++ [f x] ) []  xs

{- --------------------------------------------------------------------
 definujte myFilter pomocou foldr
-}

myFilter p xs = foldr (\x -> \rec -> if p x then x:rec else rec) [] xs

{- --------------------------------------------------------------------
  definujte funkciu priemer :: [Float] -> Float, ktora vypocita aritmeticky zoznamu [Float]
  priemer len pouzitim foldr
-}

-- toto bolo na prednaske...
sucpoc :: [Float] -> (Float,Float)
sucpoc  xs = foldr (\x -> \(sucet, pocet) -> (sucet+x, pocet+1)) 
              (0,0) xs 

priemer :: [Float] -> Float
priemer  xs = let (sucet, pocet) = sucpoc xs in  sucet/pocet

priemerM :: [[Float]] -> Float
priemerM xss = (fst res)/(snd res)
            where res = foldr (\row -> \(sucet,pocet) -> s2 (sucpoc row) (sucet,pocet)
                    ) (0,0) xss

priemerM' :: [[Float]] -> Float
priemerM' xss = uncurry (/) (foldr (\row -> \(sucet,pocet) -> s2 (sucpoc row) (sucet,pocet)
                    ) (0,0) xss)



s2 :: (Float,Float) -> (Float,Float) -> (Float,Float)
s2 (a,b) (c,d) = (a+c,b+d)

-- jeRastuca
jeRastuca :: [Int] -> Bool
jeRastuca [] = True
jeRastuca xs = snd (
                        foldr(\y -> \(predch, res) -> 
                        (y,res && (y<predch))
                        )
                        (last xs,True)   
                        (init xs)
                     )

jeRastuca' :: [Int] -> Bool
jeRastuca' [] = True
jeRastuca' (x:xs) = snd (
                        foldl(\(predch, res) -> \y ->
                        (y,res && (predch<y))
                        )
                        (x,True)   
                        xs
                     )


-- rozdiel max a minimalneho prvku vo vektore/matici
maxminRozdiel :: [Int] -> Int
maxminRozdiel xs = undefined

-- Premia Autologia1 alias PUMPY
whereToStart :: [Float] -> [Float] -> [Int]
whereToStart dist lit = undefined

{-
whereToStart [9,1] [1,9] = [1]
whereToStart [1,2,3,4] [2,2,2,4] = [0,3]
whereToStart [1,2,5,3,2,3,4,5,6] [1,1,2,2,3,3,4,4,11] = [4,8] -- vid priložený obrá
-}
