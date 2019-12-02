import Test.QuickCheck
import Data.List

elem' :: Eq(t) => t -> [t] -> Bool
elem' a xs = foldr (\x -> \rek -> (x==a) || rek ) False xs

-- toto su unit testy 21.storocia
qch1 = quickCheck((\x -> \xs -> (elem' x xs == elem x xs))::Int->[Int]->Bool )

nub' :: Eq(t) => [t] -> [t]
nub' xs = foldr (\x -> \rek -> if elem' x rek then rek else (x:rek)) [] xs

qch2 = quickCheck((\xs -> (sort(nub' xs) == sort(nub xs)))::[Int]->Bool )

sort' :: Ord(t)=>[t]->[t]
sort' xs = foldr (\_ -> \b -> jedenBubblePrechod b) xs [1..length xs]
            where
            jedenBubblePrechod (x:xs) = foldr bubliFuk [] (x:xs)
            bubliFuk a xs = if xs == [] then [a] 
                            else if a < head xs then (a:xs) 
                                                else (head xs:a:(tail xs))

qch3 = quickCheck((\xs -> (sort' xs == sort xs))::[Int]->Bool )

{-
*Main> qch1
+++ OK, passed 100 tests.
*Main> qch1
+++ OK, passed 100 tests.
*Main> qch2
+++ OK, passed 100 tests.
*Main> qch2
+++ OK, passed 100 tests.
*Main> qch2
+++ OK, passed 100 tests.
*Main> qch3
+++ OK, passed 100 tests.
*Main> qch3
+++ OK, passed 100 tests.
*Main> qch3
+++ OK, passed 100 tests.

-}
