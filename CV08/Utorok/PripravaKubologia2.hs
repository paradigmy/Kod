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

import Data.List

type Kocka = [Int]

moznosti :: [Kocka]
moznosti = [ [a,b,c,7-b,7-c,7-a]    | a<-[1..6], b<-[1..6], b/=a, b/=7-a, c<-[1..6], allDifferent [a,b,7-a,7-b,c] ]

-- nub su rozne prvky zoznamu, toto je test, ze vsetky prvky zoznamy su rozne
-- allDifferent :: [t] -> Bool  toto nejde preto, ze nub ocakava, ze vieme porovnavat prvky zoznamu typu t
-- podobne ako v Jave, by sme museli predpokladat, ze t splna interface Comparable, tak v Haskelli miesto interface 
-- je class Eq, ktory ma dve predpisane funkcie, ==, /= (nerovna sa)
-- V haskelli predpoklad na t Comparable piseme ako constraint v nasledujucej syntaxi
allDifferent :: Eq(t) => [t] -> Bool
allDifferent xs = length (nub xs) == length xs

-- trochu inak
moznosti' :: [Kocka]
moznosti' = [ [a,b,c,7-b,7-c,7-a]    | a<-[1..6], b<-[1..6]\\[a,7-a], c<-[1..6]\\[a,b,7-a,7-b] ]
-- length moznosti' == 48

---------------------------------------------------

-- kocky stoja na sebe, tak ze bocne steny su rozne, v nasom modeli bocne steny maju indexy 1,2,3,4
kockySuOK :: [Kocka] -> Bool
kockySuOK ks = and [allDifferent (map (!!i) ks) | i <- [1..4]]

naSebeBF :: Int -> [Kocka] -> [[Kocka]]
--naSebeBF k polohy = filter kockySuOK (vso polohy k)
--naSebeBF k polohy = filter kockySuOK (kso polohy k)
naSebeBF k polohy = filter kockySuOK (kbo polohy k)

-- toto su vlastne tri vnorene for cykly, na konci ktorych sa otestuje korektnost farieb postavenych kociek
-- ak length polohy == 24, tak test kockyOk sa vykona 24*24*24 krat, nie je to ziaden naznak backracku, len brutte force
triNaSebe :: [Kocka] -> [[Kocka]]
triNaSebe polohy = [ [k1,k2,k3] | k1 <- polohy, k2 <- polohy, k3 <- polohy, kockySuOK [k1,k2,k3] ]
{-
Main> :set +s
*Main> length $ triNaSebe allRightHanded
4512
(0.06 secs, 38,842,392 bytes)
-}

-- 24^4 == 331776
styriNaSebe :: [Kocka] -> [[Kocka]]
styriNaSebe polohy = [ [k1,k2,k3,k4] | k1 <- polohy, k2 <- polohy, k3 <- polohy, k4 <- polohy, kockySuOK [k1,k2,k3,k4] ]
{-
*Main> length $ styriNaSebe allRightHanded
28512
(1.14 secs, 728,194,224 bytes)
-}

-- 24^5 == 7962624
patNaSebe :: [Kocka] -> [[Kocka]]
patNaSebe polohy = [ [k1,k2,k3,k4,k5] | k1 <- polohy, k2 <- polohy, k3 <- polohy, k4 <- polohy, k5 <- polohy, kockySuOK [k1,k2,k3,k4,k5] ]
{-
*Main> length $ patNaSebe allRightHanded
80640
(29.33 secs, 15,495,767,864 bytes)
-}

-- 24^6 == 191102976 .. uz fakt dost... skoro 200M
sestNaSebe :: [Kocka] -> [[Kocka]]
sestNaSebe polohy = [ [k1,k2,k3,k4,k5,k6] | k1 <- polohy, k2 <- polohy, k3 <- polohy, k4 <- polohy, k5 <- polohy, k6 <- polohy, kockySuOK [k1,k2,k3,k4,k5,k6] ]
{-
*Main> length $ sestNaSebe allRightHanded
57600
(639.81 secs, 376,944,910,136 bytes)
-}

sedemNaSebe :: [Kocka] -> [[Kocka]]
sedemNaSebe polohy = [ [k1,k2,k3,k4,k5,k6,k7] | k1 <- polohy, k2 <- polohy, k3 <- polohy, k4 <- polohy, k5 <- polohy, k6 <- polohy, k7 <- polohy, kockySuOK [k1,k2,k3,k4,k5,k6,k7] ]
{-
*Main> length $ sedemNaSebe allRightHanded
0
(26638.40 secs, 9,636,916,710,424 bytes)  !!!!!!!!!!!!!! 7hodin
-}

---------------------------------------------------- skusme rozmyslat, ved sme poculi o backtrackingu...
naSebe :: Int -> [Kocka] -> [[Kocka]]
naSebe 0 _ = [[]]
naSebe  n polohy = [ (k:m) | m <- naSebe  (n-1) polohy, k <- polohy, kockySuOK (k:m) ]

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

isRightHanded :: Kocka -> Bool
-- isRightHanded = undefined  -- toto je premia, preto to tu nie je
-- riesenie DasaK
isRightHanded [a,b,c,d,e,f] | (a /= 1) && (b == 1) = isRightHanded[b,a,e,f,c,d]
                            | (a /= 1) && (c == 1) = isRightHanded[c,a,b,f,d,e]    
                            | (a /= 1) && (d == 1) = isRightHanded[d,a,c,f,e,b]        
                            | (a /= 1) && (e == 1) = isRightHanded[e,a,d,f,b,c]    
                            | (a /= 1) && (f == 1) = isRightHanded[f,b,e,d,c,a]                            
                            | b == 2 = (c == 3)
                            | b == 3 = (e == 2)
                            | b == 4 = (c == 2)
                            | b == 5 = (e == 3)

isRightHandedC [a,b,c,d,e,f] | (a /= 1) && (b == 1) = 1+isRightHandedC[b,a,e,f,c,d]
                            | (a /= 1) && (c == 1) = 1+isRightHandedC[c,a,b,f,d,e]    
                            | (a /= 1) && (d == 1) = 1+isRightHandedC[d,a,c,f,e,b]        
                            | (a /= 1) && (e == 1) = 1+isRightHandedC[e,a,d,f,b,c]    
                            | (a /= 1) && (f == 1) = 1+isRightHandedC[f,b,e,d,c,a]                            
                            | b == 2 = 0
                            | b == 3 = 0
                            | b == 4 = 0
                            | b == 5 = 0


{- toto su vsetky rotacie kocky vypisane explicitne pre nasledujuci plast kocky
+      a
++++   bcde   [a,b,c,d,e,f]        a+f == b+d == c+e == 7
   +      f
-}

allRightHanded :: [Kocka]
allRightHanded = filter isRightHanded moznosti'
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

--- Farbenie, Okamzite sialenstvo

data Farba = R | B | G | Y |W  deriving (Show, Eq)
type FKocka = [Farba]

type Farbenie = [Farba]
farbenie1 = [Y,B,R,R,Y,G]
farbenie2 = [Y,G,G,Y,B,G]
farbenie3 = [G,R,B,B,R,Y]
farbenie4 = [R,G,G,Y,Y,G]

farbenie :: Kocka -> Farbenie -> FKocka
farbenie xs fb = [ fb!!(i-1) | i <-xs]

{-
     22
     22
   44113366
   44113366
     55
     55
     -}

--  kombinacie  bez  opakovania  (n  nad  k)
kbo :: [t] -> Int -> [[t]]
kbo  _  0       =  [[]]
kbo  []  _      =  []
kbo  (x:xs)  k  =  [x:y  |  y  <-kbo  xs  (k-1)]  ++  kbo  xs  k

