module CV07 where
import Data.List

-- ++, head, tail, init, last, sum, maximum
-- drop, take, takeWhile, 

-- Ulohy 19..21
-- https://wiki.haskell.org/99_questions/11_to_20

-- 19
rotate :: [Char] -> Int -> [Char]
rotate xs k | k >= 0 = (drop k xs) ++ (take k xs)
            | otherwise = rotate xs (length xs+k)

-- 20
-- type String = [Char]

removeAt :: Int -> [Char] -> (Char, String)
removeAt k xs = let (first, second) = splitAt (k-1) xs in
                (head second, first ++ (tail second))
                
removeAt' :: Int -> [t] -> (t, [t])
removeAt' k xs = let (first, second) = splitAt (k-1) xs in
                 (head second, first ++ (tail second))
                 
-- 21
insertAt :: t -> [t] -> Int -> [t]
insertAt x  xs k = (take k' xs) ++ (x :drop k' xs)
                    where k' = k-1
                    
isSet :: Eq t => [t] -> Bool
isSet xs = length (nub xs) == length xs

-- [ f(x) for x in range... if ...]
-- [ x*x | x<-[1..100], odd x]
-- { x*x | x \eplislon {1..100}, odd x}
-- [ x*x | x<-[1..100]]
-- map (\x -> x*x) [1..100]
-- [ x*x | x<-[1..100], odd x]
-- map (\x -> x*x) (filter odd [1..100])
-- [x*y | x <- [1..10], y <- [1..20]]
-- concat (map (\x -> map (\y -> x*y) [1..20]) [1..10])
-- concat $ map (\x -> map (\y -> x*y) [1..20]) [1..10]

-- powerSet [1,2] = [ [], [1], [2], [1,2]] ... 2^n
powerSet :: [t] -> [[t]]
powerSet []     = [ [] ]
--powerSet (x:xs) = powerSet xs  ++ [x:p | p<-powerSet xs ]
powerSet (x:xs) = let pom = powerSet xs in pom ++ (map (x:) pom)

{-
kbo ++
kso --
vbo ++
vso --
-}

kbo :: [t] -> Int -> [[t]]   -- C(n,k)
kbo _ 0      = [ [] ]
kbo [] k     = []
kbo (x:xs) k = (kbo xs k)   -- C(n-1,k)
               ++
               map (x:) (kbo xs (k-1))  -- C(n-1,k-1)

vbo :: Eq t => [t] -> Int -> [[t]]
vbo _ 0 = [ [] ]
vbo xs k = [ x:v | x <- xs,     -- n
                   v <- vbo (xs \\ [x]) (k-1) -- (n-1)*(n-2).... je ich tu k-1
           ] -- n*(n-1)*(n-2) je ich tu k
           
perm xs = vbo xs (length xs)

inputs :: [Int]
inputs = [24, 76133, 857533, 46164, 22746, 321358, 194593, 
        1539492, 8014211, 3368825]

-- https://en.wikipedia.org/wiki/Thue%E2%80%93Morse_sequence
{-
100101100110100
-}

notCh '0' = '1'
notCh '1' = '0'

next :: String -> String
next w = w ++ map notCh w

padawa :: [Int] -> String
padawa input =  map (\n -> x!!(n-1)) input
        where m = maximum input
              x = head $ dropWhile (\w -> length w < m) (iterate next "1")
