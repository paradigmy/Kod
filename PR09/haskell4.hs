import Data.List

-- nahrdelniky n koralky 
nahrdelniky :: Int -> [String] -> [[String]]

nahrdelniky 0 _ = [ [] ]
nahrdelniky n koralky = [ kor:nah | nah <- nahrdelniky (n-1) koralky, kor<-koralky ]

rovnake :: [String] -> [String] -> Bool
rovnake n1 n2 = (n1 == n2) || (n1 == reverse n2) ||
                or [ ((drop i n1) ++ (take i n1)) == n2 | i<-[1..length n1] ] ||
                or [ ((drop i n1) ++ (take i n1)) == reverse n2 | i<-[1..length n1] ] 
    
    
lenRozne :: [[String]] -> [[String]]
lenRozne xss = nubBy rovnake xss

-- lenRozne (nahrdelniky 4 ["cervena","zelena","modra"])

-------------------------------------------------

{-
Definujte nekoneËn˝ zoznam dveNaNtuMinusJedna :: [Int], 
ktor˝ obsahuje vzostupne ËÌsla tvaru 2^n-1, pre n prirodzenÈ, t.j. [1,3,7,15,31,63,...]. 
Analogicky definujte nekoneËn˝ zoznam dveNaNtuPlusJedna obsahuj˙ci 2^n+1, t.j. [3,5,9,17,...].
SËÌtajte porade oba zoznamy, prvok po prvku, v˝sledn˝ nekoneËn˝ zoznam musÌ byù [4,8,16,32,...].
-}

dveNaNtu            = map (2^) [1..]
dveNaNtuMinusJedna    = map (+(-1)) dveNaNtu
dveNaNtuMinusJedna' = 1:[2*x+1 | x <- dveNaNtuMinusJedna']

dveNaNtuPlusJedna     = map (+2) dveNaNtuMinusJedna

dveNaNtuMinusPlusJedna = map2 (+) dveNaNtuMinusJedna dveNaNtuPlusJedna

{- 
Main> take 20 dveNaNtuMinusPlusJedna
[4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152]
-}

-- co by urobilo nieco taketo ??? [ a+b | a<-dveNaNtuMinusJedna, b<-dveNaNtuPlusJedna]

map2 f [] [] = []
map2 f (a:as) (b:bs) = (f a b):map2 f as bs

-- pouzite map2 a predefinujte fibonacciho cisla pomocuou map2

fib8 :: [Int]
fib8 = 1 : 1 : (map2 (+) fib8 (tail fib8))

--------------------------------------------------
foo 0 x = 0
foo n x = 1+x

goo 0 _    = 0
goo n x = length x

fibonacci :: Integer -> Integer -> [Integer]
--fibonacci 0 _ = []
fibonacci a b = a : (fibonacci b (a+b))

                        
ones                    = 1 : ones

numsFrom n         = n : numsFrom (n+1)

squares                = map (^2) (numsFrom 0)


mocniny2 = 1:[ 2*x | x <- mocniny2 ]
mocniny3 = 1:[ 3*x | x <- mocniny3 ]
mocniny5 = 1:[ 5*x | x <- mocniny5 ]

mp = tail (merge mocniny2 mocniny3)
mp235 = tail (tail (merge mocniny2 (merge mocniny3 mocniny5)))

merge [] x     = x  
merge x []     = x
merge l1@(a:b) l2@(c:d) = if a < c then a:(merge b l2)
                            else c:(merge l1 d)


fib                   = 1 : 1 : [ a+b | (a,b) <- zip fib (tail fib) ]

fibo@(1:tfib)          = 1 : 1 : [ a+b | (a,b) <- zip fibo tfib ]

---------------------------------------------------

-- ako dostaneme nekonecny zoznam dvojic prirodzenych cisel
-- prve zle riesenie

dvojice = [ (i,j) | i<-[0..], j<-[0..] ]

{-
Main> take 20 dvojice
[(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(0,7),(0,8),(0,9),(0,10),(0,11),(0,12),(0,13),(0,14),(0,15),(0,16),(0,17),(0,18),(0,19)]
-}

-- diagonalne

dvojice' = [ (i,s-i) | s<-[0..], i<-[0..s] ]

{-
Main> take 20 dvojice'
[(0,0),(0,1),(1,0),(0,2),(1,1),(2,0),(0,3),(1,2),(2,1),(3,0),(0,4),(1,3),(2,2),(3,1),(4,0),(0,5),(1,4),(2,3),(3,2),(4,1)]
Main> -}

-- ortogonalne

dvojice'' = foldr (++) [] [ [(i,j) | j<-[0..i] ] ++ [ (j,i) | j<-[0..i-1] ]  | i<-[0..] ]

{-
Main> take 20 dvojice''
[(0,0),(1,0),(1,1),(0,1),(2,0),(2,1),(2,2),(0,2),(1,2),(3,0),(3,1),(3,2),(3,3),(0,3),(1,3),(2,3),(4,0),(4,1),(4,2),(4,3)]
-}

-------------------------

primes         = sieve [ 2.. ]     where
            sieve (p:x) = p : sieve [ n | n<-x, n `mod` p > 0 ]


primes'         :: [Int]
primes'         = map head (iterate sieve [2 ..])
sieve         :: [Int] -> [Int]
sieve (p:ps)     = [x | x <- ps, (x `mod` p) /= 0]
--iterate f x     = x : iterate f (f x) 

hamming     :: [Integer]
hamming      = 1 : (    map (2*) hamming ||
        map (3*) hamming || 
        map (5*) hamming)
               where (x:xs) || (y:ys)  
                                           | x==y  =  x : (xs || ys)
                                           | x<y   =  x : (xs || (y:ys))
                                           | y<x   =  y : (ys || (x:xs))

hamming2357     :: [Integer]
hamming2357      = 1 : (    map (2*) hamming2357 ||
        map (3*) hamming2357 || 
        map (5*) hamming2357 ||
        map (7*) hamming2357 )
               where (x:xs) || (y:ys)  
                                           | x==y  =  x : (xs || ys)
                                           | x<y   =  x : (xs || (y:ys))
                                           | y<x   =  y : (ys || (x:xs))
                                           
                                           
----------------------------------------------
kolko2 0=0
kolko2 1=1
kolko2 x=1+kolko2 (x `div` 2)

kolko23 0=0
kolko23 x=kolko2 (x)+kolko23 (x`div` 3)

kolko235 0=0
kolko235 x=kolko23 (x)+kolko235 (x`div` 5)

kolko2357 0=0
kolko2357 x=kolko235 (x)+kolko2357(x`div` 7)

find x= [(a,kolko2357 a),(b,kolko2357 b)]where (a,b)=findh x 1
findh x y| kolko2357 y< x = findh x (y*10)
         | otherwise = findb x (y`div`10) y

findb x min max | abs(min-max)<2 = (min,max)
                |   kd<x = findb x d max
                |   kd>x = findb x min d
                |   kd==x = findb x min d 
         where d  = (min+max)`div` 2
               kd = kolko2357 d

--1000. prvok   385875
--10000. prvok  63221760000
--100000. prvok 123093144973968750000
--
--Main> find 1000
--[(385874,999),(385875,1000)]
--Main> find 10000
--[(63221759999,9999),(63221760000,10000)]
--Main> find 100000
--[(123093144973968749999,99999),(123093144973968750000,100000)]
--

----------------------------------------------                                           
                                           
pascal :: [[Int]]
pascal = [1] : [[x+y | (x,y) <- zip ([0]++r) (r++[0])] | r <- pascal]




 