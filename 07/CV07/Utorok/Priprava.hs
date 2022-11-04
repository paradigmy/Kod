module Priprava where

import Data.List

usporiadany :: [Int] -> Bool
usporiadany [] = True
usporiadany [_] = True
--usporiadany (x:y:ys) = x <= y && usporiadany (y:ys)
usporiadany (x:t@(y:ys)) = x <= y && usporiadany t

vektory :: Int -> [String]
vektory 0 = [""]
vektory n = [ch:v | ch <- ['0','1'], v <- vektory (n-1)]

type Mnozina t = [t]
powerSet :: [t] -> [[t]]
powerSet [] = [[]]
-- powerSet (x:xs) = ps ++ [x:p | p<- ps] where ps = powerSet xs
powerSet (x:xs) = let ps = powerSet xs in ps ++ [x:p | p<- ps] 

kbo :: [t] -> Int -> [[t]]
kbo _ 0 = [[]]
kbo [] _ = []
kbo (x:xs) k = kbo xs k ++ map (x:) (kbo xs (k-1))

kso :: [t] -> Int -> [[t]]
kso _ 0 = [[]]
kso [] _ = []
kso (x:xs) k = kso xs k ++ map (x:) (kso (x:xs) (k-1))

vbo :: (Eq t) => [t] -> Int -> [[t]]
vbo _ 0 = [[]]
vbo xs k = [x:v | x<-xs, v <- vbo (xs\\[x]) (k-1)]

vso :: (Eq t) => [t] -> Int -> [[t]]
vso _ 0 = [[]]
vso xs k = [x:v | x<-xs, v <- vso xs (k-1)]

