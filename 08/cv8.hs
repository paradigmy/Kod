module Main where

main :: IO ()
main = return ()

-- binarny vyhladavaci strom
data BVS t     = Nod (BVS t) t (BVS t) | Nil deriving (Eq, Show, Ord)

-- dobre je mat nejaku konstantu toho typu
b1 :: BVS Int
b1 = Nod (Nod Nil 4 Nil) 8 (Nod (Nod Nil 9 Nil) 10 Nil) 
b2 :: BVS Int
b2 = Nod (Nod Nil 1 Nil) 2 Nil 
b3 :: BVS Int
b3 = Nod b2 3 b1

-- find
find  :: (Ord t) => t -> BVS t -> Bool
find  _ Nil  = False
find  x (Nod left value right) | x < value = find x left 
                               | x > value = find x right
                               | otherwise = True

-- insert
insert  :: (Ord t) => t -> BVS t -> BVS t                 
insert  x  Nil  = Nod Nil x Nil
insert  x bvs@(Nod left value right) | x < value = Nod (insert x left) value right
                                     | x > value = Nod left value (insert x right)
                                     | otherwise = bvs

delete  :: (Ord t) => t -> BVS t -> BVS t                 
delete  x  strom  = undefined -- DU7

maxBVS       :: (Ord t) => BVS t -> t
maxBVS Nil   =  error "prazdny nema maximum"
maxBVS bvs@(Nod left value right) | right == Nil = value
                                  | otherwise = maxBVS right 

minBVS       :: (Ord t) => BVS t -> t
minBVS Nil   = error "prazdny nema minimum"
minBVS bvs@(Nod left value right) | left == Nil = value
                                  | otherwise = minBVS left 

inorder       :: (Ord t) => BVS t -> [t]
inorder Nil   = []
inorder bvs@(Nod left value right)    | left == Nil && right == Nil = [value]
                                      | otherwise = (inorder left) ++ [value] ++ (inorder right)

preorder       :: (Ord t) => BVS t -> [t]
preorder Nil   = []
preorder bvs@(Nod left value right)   | left == Nil && right == Nil = [value]
                                      | otherwise = [value] ++ (preorder left) ++ (preorder right)

isBalanced :: (Ord t) => BVS t -> Bool
isBalanced bvs@(Nod left value right) = undefined



-- POUZITIM FCII FOLDL A FOLDR VYRIESTE NASLEDUJUCE PROBLEMY:

len :: [t] -> Int
--len xs = foldl (\acc x -> acc+1) 0 xs
len xs = foldr (\x acc -> acc+1) 0 xs

fact :: Int -> Int
--fact n = foldl (\acc x -> acc*x) 1 [2..n]
fact n = foldl (\x acc -> acc*x) 1 [2..n]

rev :: [t] -> [t]
--rev xs = foldl (\acc x -> x:acc) [] xs
rev xs = foldr (\x acc -> acc ++ [x]) [] xs

compress :: (Eq t) => [t] -> [t] --compressn "aaaaabbbbcccddddaaaa" -> "abcda" -- String = [Char]
compress xs = fst (foldl (\(pole, posledny) x -> (if (posledny == x) then pole else pole ++ [x], x)) ([xs!!0], xs!!0) xs)

dropEvery :: [t] -> Int -> [t] -- dropEvery [1,2,3,4,5,6,7] 2 -> [1,3,5,7]
dropEvery xs n = foldl (\acc (x, i) -> if mod i n == 0 then acc else acc ++ [x]) [] (zip xs [1..])

fib :: Int -> [Int] -- fib 6 = [1,1,2,3,5,8]
fib n = undefined

inits :: [t] -> [[t]] -- inits "ate" = [[], "a", "at", "ate"]
inits xs = undefined

flatten :: [[t]] -> [t] -- flatten [[1,2,3], [4], [5,5]] = [1,2,3,4,5,5]
flatten xss = undefined

palindrom :: [t] -> Bool
palindrom xs = undefined

