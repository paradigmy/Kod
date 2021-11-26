module Main where

main :: IO ()
main = return ()

ap :: Int -> Int -> [Int]
ap x y = [x,(x+y)..]

apr :: Int -> Int -> [Int]
apr x y = x:(apr (x+y) y) 

apnaj :: Int -> Int -> [Int]
apnaj x y = x : [a | a <- apnaj (x + y)  y ]

apf :: Int -> Int -> [Int]
apf x y = foldl (\acc _ ->  acc ++ [(last acc  + y)]) [x] [1..]

apm :: Int -> Int -> [Int]
apm x y = map (\n -> x+(n*y)) [0..]

api :: Int -> Int -> [Int]
--api x y = iterate (\n -> n+y) x
api x y = iterate (+y) x

-- a0+0d, a0+1d, a1+d = a0+2d, a0+3d, a0+4d .... a0+nd


troj :: [Int]
troj = map(\n -> div (n*(n+1)) 2) [1..]

troj2 :: [Int]
troj2 = tr 1 2

tr :: Int -> Int -> [Int]
tr x y = x:(apr (x+y) (y+1)) 

jeTrojuholnikove  :: Int -> Bool
jeTrojuholnikove  x = x `elem` takeWhile (<=x) troj

rect :: [Int]
rect = filter(\n -> not (prvoc n) ) [4..]

prvoc :: Int -> Bool
prvoc x = (True `elem` (map(\n -> (x `mod` n) == 0) [2..(x-1)])) == False

zakladny :: [Int] -> Int -> Int
zakladny [a0..an] x -> y

