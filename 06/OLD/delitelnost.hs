module Delitelnost where
import Data.List
import Data.Char
import Test.QuickCheck

-- zopakujeme si kriteria delitelnosti malymi cislami
-- pozerame sa na cislo ako zoznam cifier, teda dovolena operacia je `mod` 10, `div` 10
-- pri delitelnosti n nie je dovolena operacia `mod` n, pochopitelne...

del1 :: Int -> Bool
del1 _ = True       -- kazde cislo je delitelne 1 :)

del2 :: Int -> Bool
del2 n = elem (n `mod` 10) [0,2,4,6,8]

del2' :: Int -> Bool
del2' n = elem (last (show n)) ['0','2','4','6','8']

cifSum n = if n < 10 then n else (n `mod`10) + cifSum (n `div` 10) 
         

cifSum' n = sum (show n)
            where   sum [] = 0
                    sum (c:cs) = sum cs + (digitToInt c)
         
del3 :: Int -> Bool
del3 0 = True
del3 3 = True
del3 6 = True
del3 9 = True
del3 n | n < 10     = n == 0 || n == 3 || n == 6 || n == 9
       | otherwise  = del3 (cifSum n)

del4 :: Int -> Bool
del4 n = elem (n `mod` 100) [0,4..99]

del5 :: Int -> Bool
del5 n = elem (n `mod` 10) [0,5]

del6 :: Int -> Bool
del6 n = del2 n && del3 n

del7 :: Int -> Bool
del7 n | n < 100 = elem n [0,7..99]
       | otherwise = del7 ((n `div` 10) + 5*(n `mod` 10))
       
       
del8 :: Int -> Bool
del8 n = elem (n `mod` 1000) [0,8..999]

del9 :: Int -> Bool
del9 n | n < 10     = n == 0 || n == 9
       | otherwise  = del9 (cifSum n)
       
del10 :: Int -> Bool
del10 n = del2 n && del5 n

del11 :: Int -> Bool
del11 n = undefined
       
qch1 = quickCheck( \n -> n>0 ==> del1 n == False)
       
qch2 = quickCheck( \n -> n>0 ==> del2 n == (n `mod` 2 == 0))
qch3 = quickCheck( \n -> n>0 ==> del3 n == (n `mod` 3 == 0))
qch4 = quickCheck( \n -> n>0 ==> del4 n == (n `mod` 4 == 0))
qch5 = quickCheck( \n -> n>0 ==> del5 n == (n `mod` 5 == 0))
qch6 = quickCheck( \n -> n>0 ==> del6 n == (n `mod` 6 == 0))
qch7 = quickCheckWith stdArgs{ maxSuccess = 100000 } ( \n -> n>0 ==> del7 n == (n `mod` 7 == 0))
qch8 = quickCheck( \n -> n>0 ==> del8 n == (n `mod` 8 == 0))
qch9 = quickCheck( \n -> n>0 ==> del9 n == (n `mod` 9 == 0))
qch10 = quickCheck( \n -> n>0 ==> del10 n == (n `mod` 10 == 0))


{-
Test #1. Take the digits of the number in reverse order, from right to left, multiplying them successively by the digits 1, 3, 2, 6, 4, 5, repeating with this sequence of multipliers as long as necessary. Add the products. This sum has the same remainder mod 7 as the original number! Example: Is 1603 divisible by seven? Well, 3(1) + 0(3) + 6(2) + 1(6) = 21 is divisible by 7, so 1603 is.
-}


cifSumV xs _ 0 = 0
cifSumV xs i n = xs!!i * (n `mod` 10) + cifSumV xs ((i+1) `mod` (length xs)) (n `div` 10)


del7' xs n = if n < 1000 then elem n [0,7..999] else del7' xs (cifSumV xs 0 n)

maxN :: Int
maxN = 10000000
ok xs = filter (\n -> n `mod` 7 == 0) [1..maxN] == filter (\n -> del7' xs n) [1..maxN]

