module ListBasicsForDummies where      -- hlavicka modulu, nie je povinna

{-- 
toto je 
+ zlozeny komentar
+ subor, ktory si prejdi prvy, a vias zakladne veci so zoznamom
-}

import Data.List                 -- import modulu, ktory obsahuje mnozstvo dobrych funkcii na pracu so zoznamami

example :: [Int]    -- definicia konstatny typu zoznam Int
example = [1,2,3,4,5,6,7,8,9,10]   -- priradenie hodnoty konstante example

odds :: [Int]    -- definicia konstatny typu zoznam Int
odds = [1,3..100]  -- neparne cisla mensie ako 100

odds' :: [Int]     -- filter
odds' = filter (\x -> x `mod` 2 > 0) example

odds'' :: [Int]   -- listComprehension, preklad z Pythonu x for x in range example if x % 2 > 0
odds'' =  [x | x <- example, x `mod` 2 > 0]

evens :: [Int]     -- map
evens = map(+ (-1)) odds  -- parne cisla 0,2..98

evens' :: [Int]   -- listComprehension, preklad z Pythonu x-1 for x in range example
evens' = [ x-1 | x<- example]



e1 = head evens  -- prve, 0::Int
e2 = tail evens  -- zvysne, okrem prveho [2,4..98]::[Int]
e3 = last evens  -- posledne, 98::Int
e4 = init evens  -- okrem posledneho, [2,4..96]
e5 = sum evens   -- 2450
e6 = product evens  -- 0
e7 = maximum evens -- 98
e8 = minimum evens -- 0

e9 = all (\x -> x `mod` 2 == 0) evens  -- True, pre kazde x z evens, plati, ze je to parne cislo
e10 = any (\x -> x `mod` 2 /= 0) evens  -- False, existuje nejake x z evens, ze je neparne, ... asi nie

e11 = evens ++ odds      -- zretazenie zoznamov :: [Int]
e12 = reverse example    -- otocenie zoznamu
e13 = example !! 1   -- indexovanie prvu v zozname, indexy zacinaju 0, takze toto je 2
e14 = sort (evens ++ odds)  -- ked musis triedit, tak neprogramuj quicksort
