module Cvicenie06 where

import Data.List
import Data.Char

{-
cif sucet
cifSum 1234 = 10
-}
cifSum :: Int -> Int
cifSum n = if n < 10 then n
           else (n `mod` 10) + cifSum (n `div` 10)

cifSum' :: Int -> Int           
cifSum' n = cifSumStr (show n)

-- Int, Integer, Char, Bool, String,.... [a] zoznam hodnot typu a 
-- type String = [Char]
cifSumStr :: String -> Int
cifSumStr "" = 0
cifSumStr (x:xs) = digitToInt x + cifSumStr xs

del2 :: Int -> Bool
del2 n = (n `mod` 10) `elem` [0, 2, 4, 6, 8]

del2' :: Int -> Bool
del2' n = last (show n) `elem` ['0', '2', '4', '6', '8']

del3 :: Int -> Bool
del3 n | n < 10 = elem n [0, 3.. 9]
       | otherwise = del3 (cifSum n)

del4 :: Int -> Bool
del4 n = (n `mod` 100) `elem` [0, 4..100]

del6 :: Int -> Bool
del6 n = (del2 n) && (del3 n)

del7 :: Int -> Bool
del7 n | n < 100 = n `elem` [0, 7..100]
       | otherwise = del7 ((5 * (n `mod` 10)) + (n `div` 10))
