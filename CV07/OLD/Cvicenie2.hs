import Data.List

-- podmnoziny mnoziny s prvkami Int
data SubSetInt = SetInt [Int] 
--        deriving (Show, Eq)
        deriving (Show)

{- toto je to iste, ako deriving Eq
instance Eq SubSetInt where
      SetInt x == SetInt y     = (x == y)
      SetInt x /= SetInt y     = (x /= y)
-}
instance Eq SubSetInt where
      SetInt x == SetInt y     = (sort x == sort y)
      SetInt x /= SetInt y     = (sort x /= sort y)

-- porovnavanie na mensi, znamena podmnozinu
instance Ord SubSetInt  where
            SetInt  x  <=  SetInt  y  =  (x  \\  y  ==  [])    --  x  je  podmnozina  y
            a  >=  b  =  b  <=  a
            a  <  b    =  a  <=  b  &&  a  /=  b
            a  >  b    =  b  <  a
            max  (SetInt  x)  (SetInt  y)  =  SetInt  (nub  (x  ++  y))
            min  (SetInt  x)  (SetInt  y)  =  SetInt  (intersect  x  y)

{-
Main>  SetInt  [1,2]  <=  SetInt  [1,3]
False
Main>  SetInt  [1,2]  <=  SetInt  [1,2,3]
True
Main>  min  (SetInt  [1,2])    (SetInt  [1,3])
SetInt  [1]
Main>  max  (SetInt  [1,2])    (SetInt  [1,3])
SetInt  [1,2,3]

-}            
------------------------------------

--  podmnoziny  mnoziny  a
data  SubSet  a  =  Set  [a]  
  deriving  (Show)

--  toto  nejde...    
--  type  SubSet  a  =    [a]

instance  Eq  a  =>  Eq  (SubSet  a)  where
            Set  x  ==  Set  y            =  (x  ==  y)
            Set  x  /=  Set  y            =  (x  /=  y)

instance  Eq  a  =>Ord  (SubSet  a)    where
            Set  x  <=  Set  y  =  (x  \\  y  ==  [])    --  x  je  podmnozina  y
            a  >=  b    =  b  <=  a
            a  <  b    =  a  <=  b  &&  a  /=  b
            a  >  b    =  b  <  a
            max  (Set  x)  (Set  y)  =  Set  (nub  (x  ++  y))
            min  (Set  x)  (Set  y)  =  Set  (intersect  x  y)

          
qs    ::  (Ord  a)  =>  [a]  ->  [a]
qs  []    =  []
qs  (b:bs)    =  qs  [x  |  x  <-  bs,  x  <=  b]  ++  [b]  ++  qs  [x  |  x  <-  bs,  not(x  <=  b)]

--[Set  [1,2],Set  [1,3],Set  [1],Set  [2,3],Set  [2],Set  [3],Set  []]

--  [x  |  x  <-  Set  [1,2],  x  <=  Set  [1,3]]


powerSetInt  ::  [Int]  ->  [SubSetInt]
powerSetInt  []      =  [SetInt  []]
powerSetInt  (x:xs)    =  [SetInt(x:s)  |  SetInt  s  <-pp]  ++  pp
    where  pp  =  powerSetInt  xs


powerSet  ::  [a]  ->  [SubSet  a]
powerSet  []      =  [Set  []]
powerSet  (x:xs)    =  [Set(x:s)  |  Set  s  <-pp]  ++  pp
    where  pp  =  powerSet  xs

--  length(powerSetInt  [1..5])


--  kombinacie  su,  ak  nezalezi  na  poradi

--  kombinacie  s  opakovanim  (n+k-1  nad  k)
kso  _  0    =  [[]]
kso  []  _  =  []
kso  (x:xs)  k  =  [x:y  |  y  <-kso  (x:xs)  (k-1)]  ++  kso  xs  k

{-
Main>  length(kso  [1..8]  4)
330
-}


--  kombinacie  bez  opakovania  (n  nad  k)
kbo  _  0    =  [[]]
kbo  []  _  =  []
kbo  (x:xs)  k  =  [x:y  |  y  <-kbo  xs  (k-1)]  ++  kbo  xs  k

{-
Main>  length(kbo  [1..8]  4)
70
-}

--  variacie,  ak  zalezi  na  poradi
--  variacie  s  opakovanim  -  n^k
vso  _  0    =  [[]]
vso  []  _  =  []
vso  xs  k  =    [  x:y  |  x  <-  xs,  y  <-  vso  xs  (k-1)]

{-
Main>  length(vso  [1..8]  4)
4096
-}

--  variacie  bez  opakovania  -  n.(n-1)....(n-k+1)
vbo  _  0    =  [[]]
vbo  []  _  =  []
vbo  xs  k  =    [  x:y  |  x  <-  xs,  y  <-  vbo  (xs  \\  [x])  (k-1)]

{-
Main>  length(vbo  [1..8]  4)
1680
-}


----------------------------------------------------------------------

{-  ----------------------------------------------
Doména  grupy  je  reprezentovaná  zoznamom  jej  elementov  typu  d,  napr.  pre  Z5  je  doména  [0,1,2,3,4]  typu  [Int].  Binárna  operácia  v  grupe  je  funkcia/operácia  d->d->d,  napr.  \x  ->  \y  ->  (x+y)  `mod`  5.  Definujte  funkcie:
•  jeKomutativna  ::  (Eq  d)  =>  [d]  ->  (d->d->d)  ->Bool,  ktorá  zistí,  èi  daná  bin.funkcia  je  komutatívna,  t.j.  jeKomutativna  domena  f  platí,  ak  f  x  y  =  f  y  x,  pre  ¾ub.  x,  y  z  domény.  
•  neutralnyPrvok  ::  (Eq  d)  =>  [d]  ->  (d->d->d)  ->  d,  ktorá  pre  doménu  a  bin.funkciu  vráti  jej  neutrálny  prvok,  ak  existuje.  Predpokladajte,  že  bin.funkcia  je  komutatívna.  
•  inverznyPrvok    ::  (Eq  d)  =>  [d]  ->  (d->d->d)  ->  d  ->  d,  ktorá  pre  doménu  a  bin.funkciu  vráti  funkciu  vracajúcu  inverzný  prvok  k  prvku  domény,  ak  existuje.  Tiež  predpokladajte,  že  bin.funkcia  je  komutatívna.  Príklad:  jeKomutativna  [0,1,2,3,4]  (\x  ->  \y  ->  (x+y)  `mod`  5)  =  True,    
neutralnyPrvok  [0,1,2,3,4]  (\x  ->  \y  ->  (x+y)  `mod`  5)  =  0,  inverznyPrvok  [0,1,2,3,4]  (\x  ->  \y  ->  (x+y)  `mod`  5)  3  =  2.

-}

jeKomutativna  ::  (Eq  d)  =>  [d]  ->  (d->d->d)  ->Bool
jeKomutativna  domena  f  =  and  [  f  x  y  ==  f  y  x  |  x<-domena,  y<-domena]

jeNeutralnymPrvkom  ::  (Eq  d)  =>  [d]  ->  (d->d->d)  ->  d  ->  Bool
jeNeutralnymPrvkom  domena  f  n  =  and  [  f  x  n  ==  x  &&  f  n  x  ==  x  |  x<-domena  ]

neutralnyPrvok  ::  (Eq  d)  =>  [d]  ->  (d->d->d)  ->  d
neutralnyPrvok  domena  f  =  head  [  n  |  n  <-domena,  jeNeutralnymPrvkom  domena  f  n]

inverznyPrvok    ::  (Eq  d)  =>  [d]  ->  (d->d->d)  ->  d  ->  d
inverznyPrvok  domena  f  =  \x  ->  head  [  i  |  i<-domena,  f  i  x  ==  neutralnyPrvok  domena  f  ]

z5  =  [0..4]
plus5  =  \x  ->  \y  ->  (x+y)  `mod`  5
krat5  =  \x  ->  \y  ->  (x*y)  `mod`  5

{-
Main>  jeKomutativna  z5  plus5
True
Main>  jeKomutativna  z5  krat5
True
Main>  neutralnyPrvok  z5  plus5
0
Main>  neutralnyPrvok  z5  krat5
1
Main>  inverznyPrvok  z5  plus5  2
3
Main>  inverznyPrvok  z5  plus5  0
0
Main>  inverznyPrvok  z5  plus5  1
4
Main>  inverznyPrvok  z5  krat5  1
1
Main>  inverznyPrvok  z5  krat5  2
3
Main>  inverznyPrvok  z5  krat5  3
2
Main>  inverznyPrvok  z5  krat5  4
4
Main>  inverznyPrvok  z5  krat5  0
Program  error:  pattern  match  failure:  head  []
  -}
  
  
  --  definujme  Vyraz  s  konstruktormi  pre  celociselnu  konstantu,  
--  premennu,  scitanie,  odcidanie,  nasobenie,  delenie,  ...

data  Vyraz  =Konst  Int  |
          Plus  Vyraz  Vyraz  |
          Minus  Vyraz  Vyraz  |
          Krat  Vyraz  Vyraz  |
          Deleno  Vyraz  Vyraz  |
          Prem  String
          deriving  (Show)

--  definujme  si  konstantu  typu  Vyraz,  na  ktorej  potom  mozeme  cvicit

v::  Vyraz
v  =  Plus  (Krat  (Prem  "x")  (Konst  5))  (Prem  "y")

--  derivujme  Vyraz  podla  premennej
derivuj  ::  String  ->  Vyraz  ->  Vyraz

derivuj  _  (Konst  _)  =  Konst  0
derivuj  prem  (Plus  p1  p2)  =  (Plus  (derivuj  prem  p1)  (derivuj  prem  p2))
--  derivacia  rozdielu:  doplnit  na  domacu  ulohu  :-)
derivuj  prem  (Krat  p1  p2)  =  (Plus  
        (Krat  (derivuj  prem  p1)  p2)
        (Krat  p1  (derivuj  prem  p2)))
--  derivacia  podielu  :  doplnit  (p1/p2)'  =  [p1'  *  p2  -  p1  *  p2']  /  p2^2
derivuj  prem  (Prem  prem')    |  prem  ==  prem'  =  Konst  1
          |  otherwise  =  Konst  0

--  definujte  zjednodusenie  Vyrazu
zjednodus  ::  Vyraz  ->  Vyraz  
          
--  okrem  pravidiel  predstavujucich  nase  zakladne  matematicke  povedomie  
--  (ktore  zjednodusia  nejaky  podvyraz),  napr:

zjednodus  (Plus  (Konst  0)  p2)  =  p2
zjednodus  (Plus  p1  (Konst  0))  =  p1
zjednodus  (Krat  (Konst  1)  p2)  =  p2
zjednodus  (Krat  p1  (Konst  1))  =  p1

--  potrebujeme  aj  pravidla,  ktore  nam  Vyraz  traverzuju,  t.j.
zjednodus  (Krat  p1  p2)    =  (Krat  (zjednodus  p1)  (zjednodus  p2))
--  a  toto  robime  dokolecka,  kym  je  co  zjednodusovat.  Ako  zistime,  ze  uz  nie  je  
--  co  zjednodusit  (vzhladom  na  nase  zakladne  matematicke  predstavy)  ?  
--  na  rozmyslenie  ako  domaca  uloha...

{-  ---------------------------------------------------------------------
na  prednaske  sme  skusili  BVS,  a  neurobili  sme  delete  na  binarnom  vyhladavacom  strome...
-}
data  BVS  t      =  Nod  (BVS  t)  t  (BVS  t)  |  Nil
        deriving  (Eq,  Show,  Ord)
            
--  dobre  je  mat  nejaku  konstantu  toho  typu
b1  ::  BVS  Int
b1  =  Nod  (Nod  Nil  4  Nil)  5  (Nod  Nil  7  Nil)  
b2  ::  BVS  Int
b2  =  Nod  (Nod  Nil  0  Nil)  1  (Nod  Nil  2  Nil)  
b3  ::  BVS  Int
b3  =  Nod  b2  3  b1  

jeOzajBVS  ::  BVS  Int  ->  Bool
jeOzajBVS  Nil      =  True
jeOzajBVS  (Nod  left  value  right)  =  (maxBVS  left)  <=  value  &&  value  <=  (minBVS  right)  &&
              jeOzajBVS  left  &&  jeOzajBVS  right
                      
maxBVS    ::  BVS  Int  ->  Int
maxBVS    Nil  =  -99999
maxBVS    (Nod  left  value  right)  =  max  (maxBVS  left)  (max  value  (maxBVS  right))

minBVS    ::  BVS  Int  ->  Int
minBVS    Nil  =  99999
minBVS    (Nod  left  value  right)  =  min  (minBVS  left)  (min  value  (minBVS  right))
                      
---  delete  v  BVS

deleteBVS  ::  Int  ->  BVS  Int  ->  BVS  Int
deleteBVS  _  Nil  =  Nil
deleteBVS  x  (Nod  left  value  right)  |x  ==  value=  if  left  ==  Nil  then  right
                        else  if  right  ==  Nil  then  left
                        else  --  tazky  pripad
                        let  max  =  maxBVS  left  in
              Nod  (deleteBVS  max  left)  max  right
          |  x  <  value  =  Nod  (deleteBVS  x  left)  value  right
          |  otherwise  =  Nod  left  value  (deleteBVS  x  right)

    