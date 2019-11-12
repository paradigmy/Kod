-- backtracking
-- do kruhu umiestnite cisla 1..10 tak, aby sucet dvoch vedla stojacich nebol delitelny 3, 5 ani 7

type RiesenieKruh = [Int]

kruh :: [RiesenieKruh]
kruh = kruhBacktrack [1..10]

kruhBacktrack :: [Int] -> [RiesenieKruh]
kruhBacktrack [] = [[]]
kruhBacktrack cifry  = [ c : ciastocneRiesenie    | 
            c <- cifry, 
      ciastocneRiesenie <- kruhBacktrack (diff cifry [c]),
      kruhOK' (c : ciastocneRiesenie)]
            
kruhOK' :: [Int] -> Bool
kruhOK' xs | (length xs) < 10   = kruhOK xs
     | otherwise    = let a = (head xs) + (last xs) in a `mod` 3 > 0 && a `mod` 5 > 0  && a `mod` 7 > 0  && 
               kruhOK xs

kruhOK :: [Int] -> Bool
kruhOK [] = True
kruhOK [_] = True
kruhOK (x:y:ys) = let a = x + y in
                  a `mod` 3 > 0 && a `mod` 5 > 0  && a `mod` 7 > 0  && 
       kruhOK (y:ys)

diff :: (Eq a) => [a] -> [a] -> [a]
diff x y = [ z | z <- x, notElem z y]

{-
Main> kruh
[[1,3,8,5,6,2,9,4,7,10],[1,7,4,9,2,6,5,8,3,10],[1,10,3,8,5,6,2,9,4,7],[1,10,7,4,9,2,6,5,8,3],
[2,6,5,8,3,1,10,7,4,9],[2,6,5,8,3,10,1,7,4,9],[2,9,4,7,1,10,3,8,5,6],[2,9,4,7,10,1,3,8,5,6],
[3,1,10,7,4,9,2,6,5,8],[3,8,5,6,2,9,4,7,1,10],[3,8,5,6,2,9,4,7,10,1],[3,10,1,7,4,9,2,6,5,8],
[4,7,1,10,3,8,5,6,2,9],[4,7,10,1,3,8,5,6,2,9],[4,9,2,6,5,8,3,1,10,7],[4,9,2,6,5,8,3,10,1,7],
[5,6,2,9,4,7,1,10,3,8],[5,6,2,9,4,7,10,1,3,8],[5,8,3,1,10,7,4,9,2,6],[5,8,3,10,1,7,4,9,2,6],
[6,2,9,4,7,1,10,3,8,5],[6,2,9,4,7,10,1,3,8,5],[6,5,8,3,1,10,7,4,9,2],[6,5,8,3,10,1,7,4,9,2],
[7,1,10,3,8,5,6,2,9,4],[7,4,9,2,6,5,8,3,1,10],[7,4,9,2,6,5,8,3,10,1],[7,10,1,3,8,5,6,2,9,4],
[8,3,1,10,7,4,9,2,6,5],[8,3,10,1,7,4,9,2,6,5],[8,5,6,2,9,4,7,1,10,3],[8,5,6,2,9,4,7,10,1,3],
[9,2,6,5,8,3,1,10,7,4],[9,2,6,5,8,3,10,1,7,4],[9,4,7,1,10,3,8,5,6,2],[9,4,7,10,1,3,8,5,6,2],
[10,1,3,8,5,6,2,9,4,7],[10,1,7,4,9,2,6,5,8,3],[10,3,8,5,6,2,9,4,7,1],[10,7,4,9,2,6,5,8,3,1]]
-- 40 rieseni
-}
------------------------------------------------------------------------------------------------------------------

--backtrack2 farbnie grafu (na vstupe su dvojice Int ako zoznam hran, farba - zistujeme ci sa graf ofarbit tolkymi farbami)

check :: [(Int, Int)] -> [Int] -> Bool
check [] ohod = True
check ((x,y):xs) ohod = ohod!!(x-1) /= ohod!!(y-1) && check xs ohod


farbenie :: [(Int, Int)] -> Int -> [Int] -> [Int] -> [Int]   -- najpr vsetko ohodnotime a potom zistime ci je to dobre farbenie (blby backtrac bez orezavania)
farbenie hrany farba ohod [] = if check hrany ohod then ohod else []
farbenie hrany farba ohod (n:neohod) = f zoz  
                                     where zoz = [farbenie hrany farba (ohod++[f]) neohod  |f <- [1..farba]]
                                           f ([]:xs) = f xs
                                           f (x:xs) = x
                                           f [] = []

daSa :: [(Int, Int)] -> Int -> [Int] --n je tu pocet vrcholov, da sa zistit z hran
daSa hrany farba = farbenie hrany farba [] [1..n]
                    where n = maximum (map (\(x,y) -> max x y) hrany)
                              
--priklad petersenov graf
--daSa [(1,2),(1,6),(1,5),(2,7),(2,3),(3,4),(3,8),(4,5),(4,9),(5,10),(6,9),(6,8),(7,10),(7,9),(8,10)] 3                              

