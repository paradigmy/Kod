module Cv07 where
import Data.List

usp :: [Int] -> Bool
usp [] = True
usp [x] = True
--usp (x:(y:ys)) = (x <= y) && usp (y:ys) 
usp (x:t@(y:ys)) = (x <= y) && usp t


vektory :: Int -> [String]
vektory 0 = [""]
--vektory n = ['0':v | v<-pom] ++ ['1':v | v<-pom]
--            where pom = vektory (n-1)
--vektory n = let pom = vektory (n-1) in ['0':v | v<-pom] ++ ['1':v | v<-pom]
vektory n = let pom = vektory (n-1) in (map (\v -> '0':v) pom) ++ ['1':v | v<-pom]


ps :: [t] -> [[t]]
ps [] = [[]]
ps (x:xs) = let pom = ps xs in (map (x:) pom) ++ pom


vso :: [Int] -> Int -> [[Int]]
vso xs 0 = [[]]
vso xs k = [x:v | x <- xs, v <- vso xs (k-1)]

kbo :: [Int] -> Int -> [[Int]]
kbo _ 0 = [[]]
kbo [] _ = []
kbo (x:xs) k = (kbo xs k) ++ [ x:ys | ys <- kbo xs (k-1)]


