import Data.List

type Matrix = [[Int]]


--Komentár
{-
[1..5] =[1,2,3,4,5]
head [1,2,3]=1
last [1,2,3]=3
tail [1,2,3]=[2,3]
elem 2 [1,2,3]=True
4 : [1,2,3] =[4,1,2,3]
delete 2 [1,2,3]=[1,3]
nub [1,1,2,3]=[1,2,3]
[x | x<-[1..10], x `mod` 2 == 0]=[2,4,6,8,10]
concat [[1],[2],[3,4]]=[1,2,3,4]
intercalate ":" ["ahoj","xyz"]="ahoj:xyz"
[1,2,3]++[4,5]=[1,2,3,4,5]
reverse [1..5]  = [5,4,3,2,1]
sort [6,5,7,2] = [2,5,6,7]
True && False = False
True || False = True
and [True, True, False] = False
or [True, True, False] = True
[1,2,3]!!2 = 3
length [1,2,3,4] = 4
sum[1,2,3,4]=10
product[1,2,3,4]=24
mojaFunkcia (x:xs) = x 
let x=[1,2,3] in x++x
-}

delitele :: Int -> [Int]
delitele n = [x | x <- [1..n], n `mod` x == 0]

spolocneDelitele :: Int -> Int -> [Int]
spolocneDelitele a b = let x = delitele a in [y | y <- delitele b, elem y x]

najmensiePrvocislo :: Int -> Int
najmensiePrvocislo n = head (tail (delitele n))

prvociselnyRozklad ::Int->[Int]
prvociselnyRozklad n    | n == 1 = []
                        | otherwise = najmensiePrvocislo n : (prvociselnyRozklad (n `div` (najmensiePrvocislo n)))


-- predpoklame dve nasobitelne matice, s rozmermi m x n a n x p vysledok je m x p
multiply :: Matrix -> Matrix -> Matrix
multiply a b = [ [ sum [  a!!i!!k * b!!k!!j | k <- [0..length b-1] ] | j <- [0..length (b!!0)-1]
                 ] | i <- [0..length a-1]
               ]

-- ghci> multiply [[ 1,3,4], [2,3,4]] [[1,2,3], [4,5,6], [7,8,9]]
-- [[41,49,57],[42,51,60]]
-- https://www.wolframalpha.com/input?i=%7B%7B+1%2C3%2C4%7D%2C+%7B2%2C3%2C4%7D%7D+*+%7B%7B1%2C2%2C3%7D%2C+%7B4%2C5%2C6%7D%2C+%7B7%2C8%2C9%7D%7D+%7B%7B41%2C49%2C57%7D%2C%7B42%2C51%2C60%7D%7D
-- {{ 1,3,4}, {2,3,4}} * {{1,2,3}, {4,5,6}, {7,8,9}} {{41,49,57},{42,51,60}}
               
power :: Matrix -> Int -> Matrix
power m n = (iterate (\x ->  multiply m x) m)!! (n-1)               
               
-- power [[1,1],[1,0]] 9

perm1 :: Eq t => [t] -> [[t]]
perm1 [] = [[]]
perm1 xs = [ p:v | p <- xs, v <- perm1 (xs\\[p]) ]

nperm xs = product [1..length xs]
-- length (perm1 [1..6]) == nperm [1..6]


vloz p i xs = take (i-1) xs ++ p:drop (i-1) xs
perm2 :: Eq t => [t] -> [[t]]
perm2 [] = [[]]
perm2 (x:xs) = [  vloz x i v | i <- [0..length xs], v <- perm2 xs ]

-- length (perm2 [1..6]) == nperm [1..6]

vso :: [t] -> Int -> [[t]]
vso _ 0 = [[]]
vso xs n = [ p:v | p <- xs, v <- vso xs (n-1)]

nvso xs n = length xs ^ n
-- length (vso [1..6] 3) == nvso [1..6] 3


vbo :: Eq t => [t] -> Int -> [[t]]
vbo _ 0 = [[]]
vbo xs n = [ p:v | p <- xs, v <- vbo (xs \\ [p]) (n-1)]

nvbo xs n = let s = length xs in product $ take n [s,s-1..1]
-- length (vbo [1..6] 3) == nvbo [1..6] 3

kbo :: [t] -> Int -> [[t]]
kbo _ 0 = [[]]
kbo [] _ = []
kbo (x:xs) k = kbo xs k ++ map (x:) (kbo xs (k-1))

nNadk n k = product [n, n-1..(n-k+1)] `div` product [1..k]

nkbo xs k = let n = length xs in nNadk n k
-- length (kbo [1..6] 3) == nkbo [1..6] 3


kso :: [t] -> Int -> [[t]]
kso _ 0 = [[]]
kso [] _ = []
kso (x:xs) k = kso xs k ++ map (x:) (kso (x:xs) (k-1))

nkso xs k = let n = length xs in nNadk (n+k-1) k
-- length (kso [1..6] 3) == nkso [1..6] 3
