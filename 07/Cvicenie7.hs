import Data.List

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
delitele n = [d | d<-[1..n], n `mod` d == 0]

spolocneDelitele :: Int -> Int -> [Int]
spolocneDelitele a b = [x | x<-delitele a, elem x (delitele b)]

najmensiePrvocislo :: Int -> Int
najmensiePrvocislo n = (delitele n) !! 1

prvociselnyRozklad ::Int->[Int]
prvociselnyRozklad n    = undefined
                        
-------------------------------------------
type Matrix = [[Int]]


-- predpoklame dve nasobitelne matice, s rozmermi m x n a n x p vysledok je m x p
multiply :: Matrix -> Matrix -> Matrix
multiply a b = [[sum[a!!i!!k*b!!k!!j  | k<-[0..(length(a!!0)-1)]] | j<-[0..(length (b!!0)-1)] ]|i <-[0..(length a-1)] ]

-- ghci> multiply [[ 1,3,4], [2,3,4]] [[1,2,3], [4,5,6], [7,8,9]]
-- [[41,49,57],[42,51,60]]
-- https://www.wolframalpha.com/input?i=%7B%7B+1%2C3%2C4%7D%2C+%7B2%2C3%2C4%7D%7D+*+%7B%7B1%2C2%2C3%7D%2C+%7B4%2C5%2C6%7D%2C+%7B7%2C8%2C9%7D%7D+%7B%7B41%2C49%2C57%7D%2C%7B42%2C51%2C60%7D%7D
-- {{ 1,3,4}, {2,3,4}} * {{1,2,3}, {4,5,6}, {7,8,9}} {{41,49,57},{42,51,60}}
               
power :: Matrix -> Int -> Matrix
power m 1 = m 
power m n = multiply m(power m (n-1)) 

power' m n = (iterate (multiply m) m) !! (n-1)
               
-- power [[1,1],[1,0]] 9

perm1 :: Eq t => [t] -> [[t]]
perm1 [] = [[]]
perm1 xs = undefined

nperm xs = undefined
-- length (perm1 [1..6]) == nperm [1..6]


vloz p i xs = take (i-1) xs ++ p:drop (i-1) xs
perm2 :: [t] -> [[t]]
perm2 = undefined

-- length (perm2 [1..6]) == nperm [1..6]

vso :: [t] -> Int -> [[t]]
vso = undefined

nvso xs n = undefined
-- length (vso [1..6] 3) == nvso [1..6] 3


vbo :: (Eq t) => [t] -> Int -> [[t]]
vbo xs 0 = [[]]   
vbo xs k = [x:v |x<-xs, v <- vbo (delete x xs) (k-1)]

nvbo xs k = let n = length xs in product [n, n-1..n-k+1]
-- length (vbo [1..6] 3) == nvbo [1..6] 3

kbo :: [t] -> Int -> [[t]]
kbo = undefined

nNadk n k = undefined

nkbo = undefined
-- length (kbo [1..6] 3) == nkbo [1..6] 3


kso :: [t] -> Int -> [[t]]
kso _ 0 = [[]]
kso [] _ = []
kso (x:xs) k = kso xs k ++ ([x:v| v <- kso (x:xs) (k-1)])

nkso = undefined
-- length (kso [1..6] 3) == nkso [1..6] 3
