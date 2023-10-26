import Data.List

a :: [Int]
a = [1..8]
b :: [Int]
b = [1,2,2,1]

hhead :: [Int] -> Int
hhead xs = xs!! 0

ttail :: [Int] -> [Int]
ttail (x:xs) = xs

iinit :: [Int] -> [Int]
iinit xs@(x:xs')  | xs == [] = []
                   | length xs == 1 = []
                   | otherwise = x : (iinit xs')

llast :: [Int] -> Int
llast xs | xs == [] = error "empty list"
          | length xs == 1 = xs !! 0
          | otherwise = llast (ttail xs)

eelem :: [Int] -> Int -> Bool
eelem [] _ = False
eelem (x:xs) e | x == e = True
                | otherwise = eelem xs e 

rreverse :: [Int] -> [Int]
rreverse [] = []
rreverse (x:xs) = rreverse xs ++ [x]

pal :: [Int] -> Bool --je palindrom?
pal [] = True
pal [x] = True
pal xs | hhead xs == llast xs = pal (iinit (ttail xs))
        | otherwise = False

dup :: [Int] -> [Int] -- zduplikuj kazdy prvok pola
dup [] = []
dup (x:xs) = [x, x] ++ dup xs

ssum :: [Int] -> Int -- scitaj prvky pola, ktore su medzi dvoma nulami
ssum zoz@(x:xs) | x /= 0 = ssum xs
            | llast xs /= 0 = ssum (iinit zoz)
            | otherwise = sssum zoz

sssum :: [Int] -> Int -- sucet pola
sssum [] = 0
sssum (x:xs) = x + sssum xs
