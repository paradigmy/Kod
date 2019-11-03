zopakuj_prvy_prvok s@(x:xs) = x:s
 
-- head (x:_)  = x
-- tail (_:xs) = xs

--------------------------------
spoj        :: [a] -> [b] -> [(a,b)]

spoj (x:xs) (y:ys)  = (x,y) : spoj xs ys
spoj (x:xs) []       = []
spoj []     zs       = []

rozpoj         :: [(a,b)] -> ([a],[b])

rozpoj []       = ([],[])
rozpoj ((x,y):ps)   = (x:xs,y:ys)
              where
              (xs,ys) = rozpoj ps             
            
rozpoy         :: [(a,b)] -> ([a],[b])

rozpoy []       = ([],[])
rozpoy ((x,y):ps)   = let (xs,ys) = rozpoy ps in (x:xs,y:ys)

                      
spoy        :: ([a],[b]) -> [(a,b)]

spoy (x:xs,y:ys)  = (x,y) : spoy (xs,ys)
spoy (x:xs,[])     = []
spoy ([],zs)       = []

spoj123 = spoj [1,2,3]

--------------------------------
selectEven' xs = [ x | x<-xs , even x ]

-- dokonale cislo je cislo, ktore je rovne suctu jeho vlastnych delitelov
dokonale      :: Int -> Bool
dokonale x       = (sum (delitele x)) == x 

-- delitele cisla do zoznamu
delitele       :: Int -> [Int]
delitele n       = [ i | i<-[1..n-1], n `mod` i == 0]

----------------------------------

nasobilka    :: [(Int,Int,Int)]
nasobilka     = [ (i, j, i*j) | i <- [1..10], j <- [1..10] ]

nasobilka'    :: [[(Int,Int,Int)]]
nasobilka'     = [ [ (i,j,i*j) | j <- [1..10]] | i <- [1..10] ]

-----------------------------------
type Riadok   = [Int]
type Matica   = [Riadok]

-- ity riadok jednotkovej matice rozmeru nxn
riadok       :: Int -> Int -> Riadok
riadok i n    = [ if i==j then 1 else 0 | j <- [1..n]]

jednotka    :: Int -> Matica
jednotka n     = [ riadok i n | i <- [1..n] ]

-- scitovanie dvoch matic rovnakeho rozmeru
-- predpokladame, ze matice stvorcove, rovnakych rozmerov
scitajMatice   :: Matica -> Matica -> Matica
scitajMatice m n  = 
    [ [(m!!i)!!j + (n!!i)!!j | j <- [0..length(m!!0)-1] ]
               | i <- [0..length m-1] ]
-- nasobenie dvoch matic rovnakeho rozmeru
-- predpokladame, ze matice stvorcove, rovnakych rozmerov
nasobMatice   :: Matica -> Matica -> Matica
nasobMatice m n  = 
    [ [ sum [ m!!i!!k * n!!k!!j | k <- [0..length m-1]]    
              | j <- [0..length m-1] ]
               | i <- [0..length m-1] ]

m1  :: Matica               
m1 = [[1,2,3],[4,5,6],[7,8,9]]               
m2  :: Matica               
m2 = [[1,0,0],[0,1,0],[0,0,1]]               
m3  :: Matica               
m3 = [[1,1,1],[1,1,1],[1,1,1]]               
               
-- transponuj maticu

transpose                :: [[a]] -> [[a]]
transpose []             = []
transpose ([]     : xss) = transpose xss
transpose ((x:xs) : xss) = (x : [h | (h:t) <- xss]) : 
                           transpose (xs : [t | (h:t) <- xss])
                           
transponuj         :: Matica -> Matica
transponuj  []      = []
transponuj  ([]:xss)   = transponuj xss
transponuj  ((x:xs):xss)= (x:(map head xss)):(transponuj (xs:(map tail xss)))

-- obcas tie zatvorky otravuju, preto si zavedieme $ notaciu
transponuj'         :: Matica -> Matica
transponuj'  []      = []
transponuj'  ([]:xss)   = transponuj' xss
transponuj'  ((x:xs):xss)= (x:(map head xss)):(transponuj' $ xs:(map tail xss))
                           
------------------------------------

pyth n = [(a,b,c)|a<-[1..n],b <- [1..n],c<-[1..n],a+b+c<= n,a^2+b^2==c^2]

kombinacie 0    = [] -- [[]]
kombinacie n  = [ 0:k | k <- kombinacie (n-1)] ++ [ 1:k | k <- kombinacie (n-1)]

-- prermutacie
perms [] = [[]]
perms x  = [ a:y | a <- x, y <- perms (diff x [a]) ]
diff x y = [ z | z <- x, notElem z y]

-- delitele
factors n = [ i | i <- [1..n], n `mod` i == 0 ] 

-- quicksort
qs     :: [Int] -> [Int]
qs []     = []
qs (a:as) = qs [x | x <- as, x <= a] ++ [a] ++ qs [x | x <- as, x > a]

-------------------- rozcvicka

tripivot (x:xs) = rozdel x xs

rozdel _ []   = ([],[],[])
rozdel x (y:ys)  | y < x  = (y:mini,midi,maxi)
    | y > x  = (mini,midi,y:maxi)
    | otherwise = (mini,y:midi,maxi)
    where (mini,midi,maxi) = rozdel x ys

-------------------


data BTree a     = Branch (BTree a) (BTree a) | Leaf a
            deriving (Show)

data TreeInt     = Vrchol TreeInt TreeInt | List Int
instance Show TreeInt where        -- vlastná implementácia show pre TreeInt
  show (List i)    = show i
  show (Vrchol left right) = "(" ++ show left ++ "," ++ show right ++ ")"

maxTree         :: TreeInt -> Int
maxTree (List x)     = x
maxTree (Vrchol l r)   = max (maxTree l) (maxTree r)

data Color = Ged | Green | Blue

--data Bool = True | False

data Znamka = A | B | C | D | E | Fx 
    deriving (Eq, Show, Ord, Enum)


flat       :: BTree a -> [a]
flat (Leaf x)                 = [x]
flat (Branch left right)   = flat left ++ flat right
---------------------------------------

-- binarny vyhladavaci strom

data BVS t     = Nod (BVS t) t (BVS t) | Nil
        deriving (Eq, Show, Ord)

-- dobre je mat nejaku konstantu toho typu
b1 :: BVS Int
b1 = Nod (Nod Nil 3 Nil) 5 (Nod Nil 7 Nil) 
b2 :: BVS Int
b2 = Nod (Nod Nil 1 Nil) 1 (Nod Nil 4 Nil) 
b3 :: BVS Int
b3 = Nod b2 3 b1

jeBVS  :: BVS Int -> Bool
jeBVS  Nil            = True
jeBVS  (Nod left value right)  = (maxBVS left) <= value && value <= (minBVS right)

maxBVS    :: BVS Int -> Int
maxBVS    Nil  = -99999
maxBVS    (Nod left value right)  = max (maxBVS left) (max value (maxBVS right))

minBVS    :: BVS Int -> Int
minBVS    Nil  = 99999
minBVS    (Nod left value right)  = min (minBVS left) (min value (minBVS right))

--
-- vyhladavanie v BVS
findBVS  :: (Ord t) => t -> BVS t -> Bool
findBVS  _ Nil  = False
findBVS  x (Nod left value right) |x == value  = True
                 | x < value  = findBVS x left
                 | otherwise  = findBVS x right

-- insertBVS                 
insertBVS  :: (Ord t) => t -> BVS t -> BVS t                 
insertBVS  x  Nil  = Nod Nil x Nil
insertBVS  x bvs@(Nod left value right) |x == value  = bvs
                 | x < value  = Nod (insertBVS x left) value right
                 | otherwise  = Nod left value (insertBVS x right)
      
-- delete bude na domacu ulohu :-)                            
                 
-- n dam na sachovnici
queens    :: Int -> [[Int]]
queens 0   = [[]]
queens n   = [ q:b | b <- queens n1, q <- [0..7], safe q b n1]
        where n1 = n-1

safe    :: Int -> [Int] -> Int -> Bool
safe q b n   = and [ not (checks q b i) | i <- [0..(n-1)] ]

checks    :: Int->[Int]->Int->Bool
checks q b i   = (q==b!!i) || (abs(q - b!!i)==i+1)

-- stromy a lesy
type Forest t = [Tree t]
data Tree t = Node t (Forest t)

find_forest     :: Eq t => t->(Forest t)->Bool

find_forest a []     = False
find_forest a (x:xs)   = (find_tree a x) || (find_forest a xs)

find_tree     :: Eq t => t->(Tree t)->Bool

find_tree a (Node b f)   = (a==b) || (find_forest a f)

find a []   = False
find a ((Node b sons):broths)   =   (a==b) || 
            (find a sons) || 
            (find a broths)


