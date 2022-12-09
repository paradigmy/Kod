import Data.List

priemer  xs   = sum/count where (sum, count) = sumCount xs
sumCount xs   = foldr (\x -> \(sum, count) -> (sum+x, count+1)) (0, 0) xs

sumCount'    :: [[Float]] -> (Float,Float)
sumCount' xs   = 
  foldr (\x -> \(sum, count)->scitaj (sumCount x) (sum, count)) (0, 0) xs
  where scitaj (a,b) (c,d) = (a+c, b+d)

priemer'  :: [[Float]] -> Float
priemer'  = uncurry (/) . sumCount'

-- backtracking: 3x3

-- vsetky prvky ys sa nachadzaju v xs - tomu sa hovori podmnozina
subset' ys xs = and (map (\x -> elem x xs) ys)

subset'' xs ys = all (`elem` ys) xs

isOk  :: [Int] -> Bool
isOk xs = not (subset' [0,1,2] xs) && not (subset' [3,4,5] xs) && not (subset' [6,7,8] xs) &&
      not (subset' [0,3,6] xs) && not (subset' [1,4,7] xs) && not (subset' [2,5,8] xs) &&
      not (subset' [0,4,8] xs) && not (subset' [2,4,6] xs)

powerSet  :: [Int] -> [[Int]]
powerSet   []    = [[]]
powerSet   (x:xs)  = map (x:) ps ++ ps  where ps = powerSet   xs
    
solve3x3'   = filter (\x -> 6 == length x) (filter isOk (powerSet [0..8]))

-- kbo

kbo       :: [Int] -> Int -> [[Int]]
kbo _ 0     = [[]]
kbo [] _     = []
kbo (x:xs) k   = [x:ys | ys <- kbo xs (k-1)] ++ kbo xs k  

solve3x3''   = filter isOk (kbo [0..8] 6)
---

kbo'       :: [Int] -> Int -> [[Int]]
kbo' _ 0     = [[]]
kbo' [] _     = []
kbo' (x:xs) k   = [x:ys | ys <- kbo' xs (k-1), isOk (x:ys)] ++ kbo' xs k  


solve3x3   = kbo' [0..8] 6

-- backtracking: magicke cislo (cislo s neopakujucimi sa ciframi 1..9, ktoreho prvych i-cifier je delitelnych i)

-- riesenim je zoznam cifier od konca, t.j. [3,2,1] je cislo 123
type Riesenie = [Int]

-- najdi vsetky riesenia
magicBacktrack    :: [Int] -> [Riesenie]
magicBacktrack []  = [[]]
magicBacktrack cifry   = [ c:ciastocneRiesenie  | 
          c<-cifry, 
          ciastocneRiesenie <- magicBacktrack (diff cifry [c]), 
          jeMagicke (c:ciastocneRiesenie) ]
              
-- z prednasky (rozdiel zoznamov)
diff     :: (Eq a) => [a] -> [a] -> [a]
diff x y   = [ z | z <- x, notElem z y]         
         
jeMagicke    :: Riesenie -> Bool
jeMagicke cs  = jeMagicke' 1 0 (reverse cs)    -- z tohoto nie som nadseny :-)

jeMagicke'    :: Int->Int->Riesenie -> Bool
jeMagicke' _ a []  = True
jeMagicke' i a (c:cs)   = noveCislo `mod` i == 0 && jeMagicke' (i+1) noveCislo cs
              where noveCislo = 10*a+c

jeMagicke''  :: Riesenie -> Bool
jeMagicke'' xs  = res
  where (_,_,res) =  foldr (\x -> \ (count, sum, result) -> 
                      (count+1, 10*sum+x, result && ( (10*sum+x) `mod` (count+1) == 0) ) ) 
                      (0, 0, True) xs            
              
{-
Main> magicBacktrack [1,2,3,4,5,6,7,8,9]
[[9,2,7,4,5,6,1,8,3]]

t.j. jedine riesenie je
381654729
-}

-- backtracking: n-dam na sachovnici, aby sa neohrozovali

-- pozicie dam v stlpcoch 1,2,3, ..., n
type RiesenieDam = [Int]

-- najdi vsetky riesenia
velkostSachovnice  :: Int
velkostSachovnice   = 9

damyBacktrack    :: Int -> [RiesenieDam]
damyBacktrack 0   = [[]]
damyBacktrack n   = [ dama:ciastocneRiesenie | 
      ciastocneRiesenie <- damyBacktrack (n-1), 
      dama <- [0..velkostSachovnice-1], 
      damyOk (n-1) dama ciastocneRiesenie]

damyOk    :: Int -> Int -> RiesenieDam -> Bool
damyOk n dama ciastocneRiesenie 
  = and [ not (jednaDamaOk dama stlpec ciastocneRiesenie) | stlpec <- [0..(n-1)] ]

jednaDamaOk      :: Int-> Int-> RiesenieDam->Bool
jednaDamaOk dama stlpec ciastocneRiesenie    
          = (dama==ciastocneRiesenie!!stlpec) || (abs(dama - ciastocneRiesenie!!stlpec)==stlpec+1)
damy = damyBacktrack velkostSachovnice
{-
Main> damyBacktrack 8
[[3,1,6,2,5,7,4,0],[4,1,3,6,2,7,5,0],[2,4,1,7,5,3,6,0],[2,5,3,1,7,4,6,0],[4,6,0,2,7,5,3,1],[3,5,7,2,0,6,4,1],[2,5,7,0,3,6,4,1],[4,2,7,3,6,0,5,1],[4,6,3,0,2,7,5,1],[3,0,4,7,5,2,6,1]21,24),(1,23,25,27)],[2,5,3,0,7,4,6,1],[3,6,4,2,0,5,7,1],[5,3,1,7,4,6,0,2],[5,3,6,0,7,1,4,2],[0,6,3,5,7,1,4,2],[5,7,1,3,0,6,4,2],[5,1,6,0,3,7,4,2],[3,6,0,7,4,1,5,2],[4,7,3,0,6,1,5,2],[3,7,0,4,6,1,5,2],[1,6,4,7,0,3,5,2],[0,6,4,7,1,3,5,2],[1,4,6,3,0,7,5,2],[3,1,6,4,0,7,5,2],[4,6,0,3,1,7,5,2],[5,3,0,4,7,1,6,2],[4,0,3,5,7,1,6,2],[4,1,5,0,6,3,7,2],[5,2,6,1,7,4,0,3],[1,6,2,5,7,4,0,3],[6,2,0,5,7,4,1,3],[4,0,7,5,2,6,1,3],[0,4,7,5,2,6,1,3],[2,5,7,0,4,6,1,3],[5,2,0,6,4,7,1,3],[6,4,2,0,5,7,1,3],[6,2,7,1,4,0,5,3],[4,2,0,6,1,7,5,3],[1,4,6,0,2,7,5,3],[2,5,1,4,7,0,6,3],[5,0,4,1,7,2,6,3],[7,2,0,5,1,4,6,3],[1,7,5,0,2,4,6,3],[4,6,1,5,2,0,7,3],[2,5,1,6,4,0,7,3],[5,1,6,0,2,4,7,3],[2,6,1,7,5,3,0,4],[5,2,6,1,3,7,0,4],[3,1,6,2,5,7,0,4],[6,0,2,7,5,3,1,4],[0,5,7,2,6,3,1,4],[2,7,3,6,0,5,1,4],[5,2,6,3,0,7,1,4],[6,3,1,7,5,0,2,4],[3,5,7,1,6,0,2,4],[1,5,0,6,3,7,2,4],[1,3,5,7,2,0,6,4],[2,5,7,1,3,0,6,4],[5,2,0,7,3,1,6,4],[7,3,0,2,5,1,6,4],[3,7,0,2,5,1,6,4],[1,5,7,2,0,3,6,4],[6,1,5,2,0,3,7,4],[2,5,1,6,0,3,7,4],[3,6,2,7,1,4,0,5],[3,7,4,2,0,6,1,5],[2,4,7,3,0,6,1,5],[3,1,7,4,6,0,2,5],[4,6,1,3,7,0,2,5],[6,3,1,4,7,0,2,5],[7,1,3,0,6,4,2,5],[6,1,3,0,7,4,2,5],[4,0,7,3,1,6,2,5],[3,0,4,7,1,6,2,5],[4,1,7,0,3,6,2,5],[2,6,1,7,4,0,3,5],[2,0,6,4,7,1,3,5],[7,1,4,2,0,6,3,5],[2,4,1,7,0,6,3,5],[2,4,6,0,3,1,7,5],[4,1,3,5,7,2,0,6],[5,2,4,7,0,3,1,6],[4,7,3,0,2,5,1,6],[3,1,4,7,5,0,2,6],[3,5,0,4,1,7,2,6],[5,2,0,7,4,1,3,6],[4,2,0,5,7,1,3,6],[3,1,7,5,0,2,4,6],[5,2,4,6,0,3,1,7],[5,3,6,0,2,4,1,7],[3,6,4,1,5,0,2,7],[4,6,1,5,2,0,3,7]]
-}

---------------------------------------------
porozdeluj p [] = []
porozdeluj p xs = 
    takeWhile p xs : 
        porozdeluj p 
            (dropWhile (\x -> (not (p x))) 
      (dropWhile p xs))
            

-----------------------------------------------

type Had   = [Int]

had1   ::Had
had1  = [3,3,3,3,2,2,2,3,3,2,2,3,2,3,2,2,3]

had2   :: Had
had2  = [3,2,2,3,2,3,2,2,3,3,2,2,2,3,3,3,3]

had3   ::Had
had3  = [3,3,2,3,2,3,2,2,2,3,3,3,2,3,3,3]

had4   ::Had
had4  = [3,2,3,2,2,4,2,3,2,3,2,3,2,2,2,2,2,2,2,2,3,3,2,2,2,2,2,3,4,2,2,2,4,2,3,2,2,2,2,2,2,2,2,2,4,2]


type SVektor  = (Int,Int,Int)
kolmo  :: SVektor -> [SVektor]
kolmo (_,0,0)   = [ (0,1,0), (0,-1,0), (0,0,1), (0,0,-1) ]
kolmo (0,_,0)   = [ (1,0,0), (-1,0,0), (0,0,1), (0,0,-1) ]
kolmo (0,0,_)   = [ (0,1,0), (0,-1,0), (1,0,0), (-1,0,0) ]

type Pozicia  = (Int,Int,Int)

vKocke3  ::  Pozicia -> Bool
vKocke3 (x,y,z)  = x `elem` [1..3] && y `elem` [1..3] && z `elem` [1..3]

vKocke4  :: Pozicia -> Bool
vKocke4 (x,y,z)  = x `elem` [1..4] && y `elem` [1..4] && z `elem` [1..4]

nPoz       :: Pozicia -> SVektor -> Pozicia
nPoz (u,v,w) (x,y,z) = (x+u,y+v,z+w)

type Rebro  = [Pozicia]
rebro  :: Pozicia -> SVektor -> Int -> Rebro
rebro start smer  2 = [nPoz start smer]
rebro start smer  3 = [nPoz (nPoz start smer) smer, nPoz start smer]
rebro start smer  4 = [nPoz (nPoz (nPoz start smer) smer) smer, nPoz (nPoz start smer) smer, nPoz start smer]

type Solution   = [Rebro]
zloz3 :: Solution -> SVektor -> Had -> [Solution]
zloz3 ciastocneRiesenie smer []    = [ciastocneRiesenie]
zloz3 ciastocneRiesenie smer (len:rebra) = [ riesenie | kolmySmer <- kolmo smer,
               koniecHada <- [head (head ciastocneRiesenie)],
               noveRebro <- [rebro koniecHada kolmySmer len],
               all vKocke3 noveRebro,
                             all (`notElem` concat ciastocneRiesenie) noveRebro,
               riesenie <- zloz3 (noveRebro:ciastocneRiesenie) kolmySmer rebra
      ]

-- head (zloz3 [[(1,1,1)]] (0,0,1) had1)
-- head (zloz3 [[(1,1,1)]] (0,0,1) had2)
-- head (zloz3 [[(1,1,1)]] (0,0,1) had3)

      
zloz3' :: Solution -> SVektor -> Had -> [Solution]
zloz3' ciastocneRiesenie smer []    = [ciastocneRiesenie]
zloz3' ciastocneRiesenie smer (len:rebra) = [ s | kolmySmer <- kolmo smer,
            s <- let 
                   koniecHada = head (head ciastocneRiesenie)
                   noveRebro = rebro koniecHada kolmySmer len
                 in 
                   if (all vKocke3 noveRebro &&
         all (`notElem` concat ciastocneRiesenie) noveRebro) then
         zloz3' (noveRebro:ciastocneRiesenie) kolmySmer rebra
      else
          []
      ]

      
zloz4 :: Solution -> SVektor -> Had -> [Solution]
zloz4 ciastocneRiesenie smer []    = [ciastocneRiesenie]
zloz4 ciastocneRiesenie smer (len:rebra) = [ riesenie | kolmySmer <- kolmo smer,
               koniecHada <- [head (head ciastocneRiesenie)],
               noveRebro <- [rebro koniecHada kolmySmer len],
               all vKocke4 noveRebro,
                             all (`notElem` concat ciastocneRiesenie) noveRebro,
               riesenie <- zloz4 (noveRebro:ciastocneRiesenie) kolmySmer rebra
      ]
      
-- head (zloz4 [[(2,1,1)]] (0,0,1) had4)
-- head (zloz4 [[(1,2,2)]] (0,0,1) had4)

