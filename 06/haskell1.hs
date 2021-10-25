-- toto je komentarik
{- toto je komentarisko
  a viac ich tu nebude -}


add x y   = x + y

fac :: Int->Int
fac n   = if n == 0 then 1 else n*fac( n - 1)

faci n = faciter n 1
faciter 1 f = f
faciter n f = faciter (n-1) (n*f)

fac' 0       = 1
fac' n   = (n)*fac'(n-1)

fac'' 0       = 1
fac'' n   = product [1..n]

fac''' n     | n <  0  = error "input to fac is negative"
            | n == 0    = 1
            | n >  0      = product [1..n]

power2 :: Int -> Int
power2 n
    | n==0        = 1
    | n>0         = 2 * power2 (n-1)
    | otherwise  = error "nedefinovane"

power2' n
    | n==0        = 1
    | n>0         = 2 * power2' (n-1)

power :: Float -> Int -> Float        
power x n  | n == 0      =  1
      | (n `rem` 2 == 0)  = power (x*x) (n `div` 2)
      | otherwise      = x*power x (n-1)

power' x n  | n == 0      =  1
      | (n `rem` 2 == 0)  = pom*pom 
      | otherwise      = x*power' x (n-1)
      where pom = power' x (n `div` 2)

power'' x n  | n == 0      =  1
      | (n `rem` 2 == 0)  = (power'' x (n `div` 2))^2 
      | otherwise      = x*power'' x (n-1)
            
quadsolve a b c | delta < 0    = error "complex roots"
              | delta == 0   = [-b/(2*a)]
              | delta > 0    = [-b/(2*a) + radix/(2*a),
                                   -b/(2*a) - radix/(2*a)]
                          where
                               delta = b*b - 4*a*c
                               radix = sqrt delta

-- dalsie jednoduche rekurzivne funkcie

fib 0  = 1
fib 1  = 1
fib  n  = fib(n-1) + fib(n-2)

fib' n  | n < 2  = 1
    | otherwise  = fib'(n-1) + fib'(n-2)
    
comb n k  |   k == 0  =  1
      |   n == k  =   1
      | otherwise  = comb(n-1)(k-1)+comb(n-1) k
      
comb' n k  |   k == 0  =  1
      | otherwise  = (n-k+1)*comb' n (k-1) `div` (k)
                               
-- priklad o rozmienani minci
rozmen _ []   = 0
rozmen _ [1] = 1
rozmen 1 _ = 1
rozmen s (x:xs) | s >= x = rozmen s xs + rozmen (s-x) (x:xs)
        | otherwise = rozmen s xs
                               
                               
len :: [a] -> Int

len []       = 0        
len (z:zs)   = 1 + len zs  

sucet []     = 0
sucet  (x:xs)   = x+sucet xs

-- ++
append  [] ys     = ys
append   (x:xs) ys  = x:(append xs ys)

rev []  =  []
rev  (x:xs) = (rev xs) ++ [x]

--------------------

f_Float :: Float -> Float
f_Float x = x

f_Bool :: Bool -> Bool
f_Bool x = x

f_Char :: Char -> Char
f_Char x = x

f_Double :: Double -> Double
f_Double x = x

f_Integer :: Integer -> Integer
f_Integer x = x


-- iterativny reverse
reverse xs  = rev' xs []

rev' []  ys  = ys
rev' (x:xs) ys  = rev' xs (x:ys)

selectEven :: [Int] -> [Int]

selectEven [] = []
selectEven (x:xs)
      | even x    = x : selectEven xs
    | otherwise   =     selectEven xs

zopakuj_prvy_prvok s@(x:xs) = x:s

--head (x:_)  = x
-- tail (_:xs) = xs

    
ack 0 n     = n+1
ack (m) 0   = ack (m-1) 1
ack (m) (n) = ack (m-1) (ack (m) (n-1))

pyth n = [(a,b,c)|a<-[1..n],b <- [1..n],c<-[1..n],a+b+c<= n,a^2+b^2==c^2]

perms [] = [[]]
perms x  = [ a:y | a <- x, y <- perms (diff x [a]) ]
diff x y = [ z | z <- x, notElem z y]

factors n = [ i | i <- [1..n], n `mod` i == 0 ] 

qs     :: [Int] -> [Int]
qs []     = []
qs (a:as) = qs [x | x <- as, x <= a] ++ [a] ++ qs [x | x <- as, x > a]

data BTree a     = Branch (BTree a) (BTree a) | Leaf a

data TreeInt     = Vrchol TreeInt TreeInt | List Int

flat       :: BTree a -> [a]
flat (Leaf x)                 = [x]
flat (Branch left right)   = flat left ++ flat right

queens    :: Int -> [[Int]]
queens 0   = [[]]
queens n   = [ q:b | b <- queens (n-1), q <- [0..7], safe q b (n-1)]

safe    :: Int -> [Int] -> Int -> Bool
safe q b n   = and [ not (checks q b i) | i <- [0..(n-1)] ]

checks    :: Int->[Int]->Int->Bool
checks q b i   = (q==b!!i) || (abs(q - b!!i)==i+1)

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

spoj:: [a] -> [b] -> [(a,b)]

spoj (x:xs) (y:ys)  = (x,y) : spoj xs ys
spoj (x:xs) []         = []
spoj []     zs         = []

rozpoj :: [(a,b)] -> ([a],[b])

rozpoj []     = ([],[])
rozpoj ((x,y):ps)   = (x:xs,y:ys)
            where
            (xs,ys) = rozpoj ps             
            
rozpoy :: [(a,b)] -> ([a],[b])

rozpoy []     = ([],[])
rozpoy ((x,y):ps)   = let (xs,ys) = rozpoy ps in (x:xs,y:ys)

                      
spoy:: ([a],[b]) -> [(a,b)]

spoy (x:xs,y:ys)  = (x,y) : spoy (xs,ys)
spoy (x:xs,[])     = []
spoy ([],zs)       = []

spoj123 = spoj [1,2,3]

nsd 0 0      = error "nsd 0 0 nie je definovany"
nsd x 0      = x
nsd x y      = nsd y (x `rem` y)

ones                    = 1 : ones

numsFrom n         = n : numsFrom (n+1)

squares                = map (^2) (numsFrom 0)

fibon                 = 1 : 1 : [ a+b | (a,b) <- zip fibon (tail fibon) ]

fibo@(1:tfib)        = 1 : 1 : [ a+b | (a,b) <- zip fibo tfib ]

primes     = sieve [ 2.. ]   where
      sieve (p:x) = p : sieve [ n | n<-x, n `mod` p > 0 ]


primes'     :: [Int]
primes'     = map head (iterate sieve [2 ..])
sieve     :: [Int] -> [Int]
sieve (p:ps)   = [x | x <- ps, (x `mod` p) /= 0]
--iterate f x   = x : iterate f (f x) 

hamming     :: [Integer]
hamming      = 1 : (  map (2*) hamming ||
        map (3*) hamming || 
        map (5*) hamming)
               where (x:xs) || (y:ys)  
                                         | x==y  =  x : (xs || ys)
                                         | x<y   =  x : (xs || (y:ys))
                                         | y<x   =  y : (ys || (x:xs))

pascal :: [[Int]]
pascal = [1] : [[x+y | (x,y) <- zip ([0]++r) (r++[0])] | r <- pascal]

-- maxTree :: TreeInt -> Int
-- maxTree (Vrchol (Vrchol (List 3) (List 1)) (Vrchol (List 2) (List 1)))



    
  