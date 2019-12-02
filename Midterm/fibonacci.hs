fibStr :: Int -> String -> String -> String
fibStr n a b = fibStr' n 
    where 
    fibStr' 1 = a
    fibStr' 2 = b
    fibStr' n = (fibStr' (n-2)) ++ (fibStr' (n-1))
 -- [fibStr i "a" "b" | i <-[1..10]] 
 -- ["a","b","ab","bab","abbab","bababbab","abbabbababbab","bababbababbabbababbab","abbabbababbabbababbababbabbababbab","bababbababbabbababbababbabbababbabbababbababbabbababbab"]    
    
    
fibLinearne :: Int -> String -> String -> String
fibLinearne n a b = fibStr' n a b
    where
    fibStr' 1 a _ = a
    fibStr' 2 _ b = b
    fibStr' n a b = fibStr' (n-1) b (a++b)

jeFib :: String -> String -> String -> Bool
jeFib kandidat a b = kandidat == last (takeWhile (\xs -> length xs <= length kandidat) [fibLinearne n a b | n <- [1..]])

fibPoly :: (t->t->t)->Int->t->t -> t
fibPoly f n a b = fibPoly' f n a b
    where
    fibPoly' :: (t->t->t)->Int->t->t->t
    fibPoly' f 1 a _ = a
    fibPoly' f 2 _ b = b
    fibPoly' f n a b = fibPoly' f (n-1) b (f a b)
    
fibStr' = fibPoly (++)
fibInt n = fibPoly (+) n 1 1
    
prveDva :: String -> (String, String)
prveDva xs = ([head xs], tail xs)