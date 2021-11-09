import Data.List
{-
plaste kocky, prvych 6
+
++++
+

+
++++
 +
 
+
++++
  +

+
++++
   +

 +
++++
 +

 +
++++
  +

su aj dalsie ? Kolko je roznych plastov kocky ????
-}
plaste1 = [[a,b,c,d,e,f] |
        a <- [1..6],
        f <- [1..6],
        a + f == 7,
        b <- [1..6],
        d <- [1..6],
        b + d == 7,
        c <- [1..6],
        e <- [1..6],
        c + e == 7,
        length (nub [a,b,c,d,e,f]) == 6]
        
plaste2 = [[a,b,c,d,e,f] | [a,b,c,d,e,f] <- permutations [1..6], 
            a + f == 7,
            b + d == 7,
            c + e == 7]
{-
reprezentujem kocku takto
A
BCDE 
   F
spravna kocka ma sucet protialhkych stran 7

toto su jedine dve spravne kocky
1
2354    [1,2,3,5,4,8]
   8
   
1
3245   [1,3,2,4,5,8]
   8
-}

-- definujte vsetky natocenia spravnej kocky, niektorej


------------------------------------------------------------------
type Kocka = [Int]

moznosti :: [Kocka]
moznosti = undefined

-- length $ moznosti == 48

-- nub su rozne prvky zoznamu, toto je test, ze vsetky prvky zoznamy su rozne
-- allDifferent :: [t] -> Bool  toto nejde preto, ze nub ocakava, ze vieme porovnavat prvky zoznamu typu t
-- podobne ako v Jave, by sme museli predpokladat, ze t splna interface Comparable, tak v Haskelli miesto interface 
-- je class Eq, ktory ma dve predpisane funkcie, ==, /= (nerovna sa)
-- V haskelli predpoklad na t Comparable piseme ako constraint v nasledujucej syntaxi

allDifferent :: Eq(t) => [t] -> Bool
allDifferent xs = length (nub xs) == (length xs)

-- trochu inak
moznosti' :: [Kocka]
moznosti' = undefined
-- length moznosti' == 48

---------------------------------------------------

-- kocky stoja na sebe, tak ze bocne steny su rozne, v nasom modeli bocne steny maju indexy 1,2,3,4
kockySuOK :: [Kocka] -> Bool
kockySuOK xs = and [allDifferent [k!!i | k <- xs] | i <- [1..4]]
 

naSebeBF :: Int -> [Kocka] -> [[Kocka]]
naSebeBF k polohy = kbo polohy k 

-- toto su vlastne tri vnorene for cykly, na konci ktorych sa otestuje korektnost farieb postavenych kociek
-- ak length polohy == 24, tak test kockyOk sa vykona 24*24*24 krat, nie je to ziaden naznak backracku, len brutte force
triNaSebe :: [Kocka] -> [[Kocka]]
triNaSebe polohy = [[p1,p2,p3] | p1 <- polohy, 
                                p2 <- polohy, 
                                p3 <- polohy,
                                kockySuOK [p1,p2,p3]]

{-
Main> :set +s
*Main> length $ triNaSebe allRightHanded
*Main> length $ naSebeBF 3 allRightHanded
4512
(0.06 secs, 38,842,392 bytes)
-}

-- 24^4 == 331776
styriNaSebe :: [Kocka] -> [[Kocka]]
styriNaSebe polohy = [[p1,p2,p3,p4] | 
                                p1 <- polohy, 
                                p2 <- polohy, 
                                p3 <- polohy,
                                p4 <- polohy,
                                kockySuOK [p1,p2,p3,p4]]
 
{-
*Main> length $ styriNaSebe allRightHanded
*Main> length $ naSebeBF 4 allRightHanded
28512
(1.14 secs, 728,194,224 bytes)
-}

-- 24^5 == 7962624
patNaSebe :: [Kocka] -> [[Kocka]]
patNaSebe polohy = [[p1,p2,p3,p4,p5] | 
                                p1 <- polohy, 
                                p2 <- polohy, 
                                kockySuOK [p1,p2],
                                p3 <- polohy,
                                kockySuOK [p1,p2,p3],
                                p4 <- polohy,
                                kockySuOK [p1,p2,p3,p4],
                                p5 <- polohy,
                                kockySuOK [p1,p2,p3,p4,p5]]
 
{-
*Main> length $ patNaSebe allRightHanded
*Main> length $ naSebeBF 5 allRightHanded
80640
(29.33 secs, 15,495,767,864 bytes)
-}

-- 24^6 == 191102976 .. uz fakt dost... skoro 200M
sestNaSebe :: [Kocka] -> [[Kocka]]
sestNaSebe polohy = undefined 
{-
*Main> length $ sestNaSebe allRightHanded
*Main> length $ naSebeBF 5 allRightHanded
57600
(639.81 secs, 376,944,910,136 bytes)
-}

sedemNaSebe :: [Kocka] -> [[Kocka]]
sedemNaSebe polohy = undefined 
{-
*Main> length $ sedemNaSebe allRightHanded
0
(26638.40 secs, 9,636,916,710,424 bytes)  !!!!!!!!!!!!!! 7hodin
-}

---------------------------------------------------- skusme rozmyslat, ved sme poculi o backtrackingu...
naSebe :: Int -> [Kocka] -> [[Kocka]]
naSebe 0 _ = [[]]
-- pomale naSebe  k polohy = [ (p:m)| p <- polohy, m <- naSebe(k-1) polohy,  kockySuOK(p:m)]
naSebe  k polohy = [ (p:m)| m <- naSebe(k-1) polohy,  p <- polohy, kockySuOK(p:m)]

{-
*Main> :set +s
*Main> length $ naSebe 3 allRightHanded     4512        (0.09 secs, 33,865,928 bytes)
*Main> length $ naSebe 4 allRightHanded     28512       (0.77 secs, 353,548,976 bytes)
*Main> length $ naSebe 5 allRightHanded     80640       (5.13 secs, 2,146,420,680 bytes)
*Main> length $ naSebe 6 allRightHanded     57600       (15.56 secs, 6,640,328,112 bytes)
*Main> length $ naSebe 7 allRightHanded     0           (22.95 secs, 9,577,923,920 bytes)
-}

{-
prekvapivy vysledok, ak ten isty hlavolam riesime s pravymi kockami a fake kockami, teda spolu right a left handed, oboch typov kociem mame neobmedzene vela, tak tu su vysledky:

*Main> length $ naSebe 3 moznosti'          36096       (0.53 secs, 261,951,496 bytes)
*Main> length $ naSebe 4 moznosti'          456192      (11.28 secs, 5,372,439,744 bytes)
*Main> length $ naSebe 5 moznosti'          2580480     (123.23 secs, 62,689,655,264 bytes)
*Main> length $ naSebe 6 moznosti'          3686400     (607.91 secs, 349,989,975,904 bytes)
*Main> length $ naSebe 7 moznosti'          0           (1211.15 secs, 725,560,401,424 bytes)
-}

{- toto su vsetky rotacie kocky vypisane explicitne pre nasledujuci plast kocky
+      a
++++   bcde   [a,b,c,d,e,f]        a+f == b+d == c+e == 7
   +      f
-}

allRightHanded :: [Kocka]
allRightHanded = [[1,2,3,5,4,6],[1,3,5,4,2,6],[1,4,2,3,5,6],[1,5,4,2,3,6],[2,1,4,6,3,5],[2,3,1,4,6,5],[2,4,6,3,1,5],[2,6,3,1,4,5],[3,1,2,6,5,4],[3,2,6,5,1,4],[3,5,1,2,6,4],[3,6,5,1,2,4],[4,1,5,6,2,3],[4,2,1,5,6,3],[4,5,6,2,1,3],[4,6,2,1,5,3],[5,1,3,6,4,2],[5,3,6,4,1,2],[5,4,1,3,6,2],[5,6,4,1,3,2],[6,2,4,5,3,1],[6,3,2,4,5,1],[6,4,5,3,2,1],[6,5,3,2,4,1]]
-- length allRightHanded == 24 
 
allsRH :: [Kocka]
allsRH = map (\xs -> xs ++ [7-xs!!1, 7-xs!!2, 7-xs!!0]) 
                                          [
                                           [1,2,4],
                                           [1,4,5],
                                           [1,5,3],
                                           [1,3,2],
                                           [2,1,3],
                                           [2,3,6],
                                           [2,6,4],
                                           [2,4,1],
                                           [3,1,5],
                                           [3,5,6],
                                           [3,6,2],
                                           [3,2,1],
                                           [4,1,2],
                                           [4,2,6],
                                           [4,6,5],
                                           [4,5,1],
                                           [5,1,4],
                                           [5,4,6],
                                           [5,6,3],
                                           [5,3,1],
                                           [6,2,3],
                                           [6,3,5],
                                           [6,5,4],
                                           [6,4,2]
                                          ]


--  kombinacie  bez  opakovania  (n  nad  k)
kbo :: [t] -> Int -> [[t]]
kbo  _  0       =  [[]]
kbo  []  _      =  []
kbo  (x:xs)  k  =  [x:y  |  y  <-kbo  xs  (k-1)]  ++  kbo  xs  k



