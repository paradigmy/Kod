import Data.List
import Data.Char

permutacie :: [Int] -> [[Int]]
permutacie [] = [[]]
permutacie x = concat [map (\a -> y:a)( permutacie (delete y x)) | y <- x]

kombinacie :: [Int] -> [[Int]]
kombinacie [] = [[]]
kombinacie (x:xs) = kombinacie xs ++ [x:y | y <- kombinacie xs]

npermutacia :: [Int] -> Int -> [Int]
npermutacia x n =head $ drop (n-1) (permutacie x)

--BVS
-- binarny vyhladavaci strom
data BVS t     = Nod (BVS t) t (BVS t) | Nil deriving (Eq, Show, Ord)
-- dobre je mat nejaku konstantu toho typu
b1 :: BVS Int
b1 = Nod (Nod Nil 4 Nil) 8 (Nod (Nod Nil 9 Nil) 10 Nil) 
b2 :: BVS Int
b2 = Nod (Nod Nil 1 Nil) 2 Nil 
b3 :: BVS Int
b3 = Nod b2 3 b1

findX  :: (Ord t) => t -> BVS t -> Bool
findX x Nil = False
findX  x (Nod left value right) | x < value = findX x left
                                | x > value = findX x right
                                | otherwise = True

preorder       :: (Ord t) => BVS t -> [t]
preorder Nil = []
preorder bvs@(Nod left value right)   = value : preorder left ++ preorder right

inorder       :: (Ord t) => BVS t -> [t]
inorder Nil = []
inorder bvs@(Nod left value right)   = inorder left ++ [value] ++ inorder right

hlbka :: (Ord t) => BVS t -> Int
hlbka Nil = 0
hlbka bvs@(Nod left value right) = 1 + (maximum [(hlbka left), (hlbka right)])

isBalanced :: (Ord t) => BVS t -> Bool
isBalanced Nil = True
isBalanced bvs@(Nod left value right) = (hlbka left) == (hlbka right)


--fold

foldSucet :: [Int] -> Int
foldSucet x = foldr hf 0 x
  where
    hf x acc = x + acc

foldSplitParne :: [Int] -> ([Int],[Int])
foldSplitParne x = foldr hf ([], []) x
  where
    hf x (a, b) = if even x then (x:a, b) else (a, x:b) 

--Retazce fold

rozdelPodlaZnaku :: String -> Char -> [String]
rozdelPodlaZnaku [] z = [[]]
rozdelPodlaZnaku (x:xs) z = if x==z then []:(rozdelPodlaZnaku xs z) else let a=(rozdelPodlaZnaku xs z) in (x:(head a)):(tail a)

zamenZnak :: String -> Char -> Char -> String
zamenZnak  x old new = foldr hf "" x
  where
    hf o all = if o == old then new:all else o:all

zamenSlova :: String -> [(String,String)] ->String
zamenSlova x slova = foldr hf "" rozdelene
  where
    rozdelene = rozdelPodlaZnaku x ' '
    hf y acc = if elem y [a | (a,_) <- slova] then head [b | (a, b) <- slova, a == y] ++ " " ++ acc else y ++ " " ++ acc

--GrahamScan
grahamScan :: [(Float,Float)]->[(Float,Float)]
grahamScan x = x
