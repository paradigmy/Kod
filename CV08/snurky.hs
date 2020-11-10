import Data.List

-- lubovolne snurkovanie
lancing n = map(1:) $ permutations ([2..n]++[-1,-2..(-n)])

count_lancing n = ((fact (2*n))`div` n) `div` 2

{-
count_lancing 3
120
length $ lancing 3
120
length $ lancing 4
5040
count_lancing 4
5040
length $ lancing 6
39916800
count_lancing 6
39916800
-}

---------------------
isTwoCrossed   :: [Int] -> Bool
isTwoCrossed s = isTwoCrossed1 (((last s):s) ++ [head s]) 
                 where
                      isTwoCrossed1 (x:y:z:us) = ((y < 0 && x > 0 && z > 0) || (y > 0 && x < 0 && z < 0)) 
                                                 &&  isTwoCrossed1 (y:z:us)
                      isTwoCrossed1 _ = True
                   
twoCrossed n = filter isTwoCrossed (lancing n)
distinctTwoCrossed n = nubBy same (twoCrossed n)
                       where 
                        same s1 s2 = reverse (tail s1) == tail s2

count_TwoCrossed 1 = 1
count_TwoCrossed n = (fact (n-1) * fact n) `div`2

-- ina definicia...
utiahnute n = [ napreskacku left right |
                left <- map (1:)(permutations [2..n]),
                right <- permutations [(-n)..(-1)]
              ]
utiahnutebezsymetrii n = nubBy same (utiahnute n)
                         where 
                         same s1 s2 = reverse (tail s1) == tail s2    
    
napreskacku [] [] = []           
napreskacku (x:xs) (y:ys) = x:y:napreskacku xs ys


{-
length $ distinctTwoCrossed 1
1
count_TwoCrossed 1
1
length $ distinctTwoCrossed 2
1
count_TwoCrossed 2
1
length $ distinctTwoCrossed 3
6
count_TwoCrossed 3
6
length $ distinctTwoCrossed 4
72
count_TwoCrossed 4
72
length $ distinctTwoCrossed 5
1440
count_TwoCrossed 5
1440
-}
--------------------------------------------------------
fact n | n <= 0     = 1
       | otherwise  = product [1..n]