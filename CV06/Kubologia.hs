module Kubologia where
{-
toto su niektore plaste kocky, prvych 6
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

su aj dalsie ? kolko ?
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

allDifferent xs = nub xs == xs
type Kocka = [Int]

moznosti :: [Kocka]
moznosti = [ [a,b,c,7-b,7-c,7-a]    | a<-[1..6], b<-[1..6], b/=a, b/=7-a, c<-[1..6], allDifferent [a,b,7-a,7-b,c] ]

-- inak
moznosti' :: [Kocka]
moznosti' = [ [a,b,c,7-b,7-c,7-a]    | a<-[1..6], b<-[1..6]\\[a,7-a], c<-[1..6]\\[a,b,7-a,7-b] ]

isRightHanded :: Kocka -> Bool
isRightHanded = undefined  -- toto je na premiu
