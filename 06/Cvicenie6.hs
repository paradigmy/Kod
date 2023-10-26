module Cvicenie6 where

import Data.List
import Data.Char

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

jeParne :: Int -> Bool
jeParne 1 = False
jeParne 2 = True
jeParne 3 = False
jeParne n | n==4 = True
          | n==5 = False
          | n>7 =   n `mod` 2 == 0
          |otherwise = True

--Delitelnost
cifry :: Int -> [Int]
cifry n | n<10 = [n]
        | otherwise = (cifry (n `div` 10)) ++ [(n `mod` 10)] 


del2:: Int -> Bool
del2 n = elem (last (cifry n)) [0,2,4,6,8]



cifSucet:: Int->Int
cifSucet n = sum (cifry n)

del3 :: Int->Bool
del3 n | n < 10 = elem n [3,6,9]
       | otherwise = del3 (cifSucet n)


del6 :: Int -> Bool
del6 n = del2 n && (del3 n)

delitele :: Int -> [Int]
delitele n = [x | x <- [1..n], n `mod` x == 0]

spolocneDelitele :: Int -> Int -> [Int]
spolocneDelitele a b = let x = delitele a in [y | y <- delitele b, elem y x]

najmensiePrvocislo :: Int -> Int
najmensiePrvocislo n = head (tail (delitele n))

prvociselnyRozklad ::Int->[Int]
prvociselnyRozklad n    | n == 1 = []
                        | otherwise = najmensiePrvocislo n : (prvociselnyRozklad (n `div` (najmensiePrvocislo n)))


--Retazce 

zamenZnak :: String -> Char -> Char -> String
zamenZnak  x old new | not (elem old x) = x
                     | head x == old = new : (zamenZnak (tail x) old new)
                     | otherwise = (head x):(zamenZnak  (tail x) old new)

zamenZnak2 :: String -> Char -> Char -> String
zamenZnak2  x old new = [if a==old then new else a| a<-x]

zamenZnaky :: String -> [(Char, Char)] -> String
zamenZnaky  x [] = x
zamenZnaky x ((old,new):xs) =zamenZnak (zamenZnaky x xs) old new

rozdelPodlaZnaku :: String -> Char -> [String]
rozdelPodlaZnaku x old  | not (elem old x) = [x]
                        | head x == old =[]: (rozdelPodlaZnaku (tail x) old)
                        | otherwise = (head x : (head (rozdelPodlaZnaku (tail x) old)))
                            : (tail (rozdelPodlaZnaku (tail x) old))


--cenzuraLight "dnesne vrany kradnu hlavne orechy" "vrany" = "dnesne ***** kradnu hlavne orechy"
cenzuraLight :: String -> String -> String
cenzuraLight x old = ""

--cenzuraFull "dnesne vrany kradnu hlavne orechy" ["vrany","orechy"] = "dnesne ***** kradnu hlavne ******"
cenzuraFull :: String -> [String] -> String
cenzuraFull x old = ""

{- Riesenie
--cenzuraLight "dnesne vrany kradnu hlavne orechy" "vrany" = "dnesne ***** kradnu hlavne orechy"
cenzuraLight :: String -> String -> String
cenzuraLight x old = intercalate  " " [if a==old then (zamenZnaky a [(b,'*')|b<-a]) else a |a<-(rozdelPodlaZnaku x ' ')]

--cenzuraFull "dnesne vrany kradnu hlavne orechy" ["vrany","orechy"] = "dnesne ***** kradnu hlavne ******"
cenzuraFull :: String -> [String] -> String
cenzuraFull x [] = x
cenzuraFull x (y:ys)= cenzuraFull (cenzuraLight x y) ys
-}

