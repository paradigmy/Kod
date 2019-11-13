module Rubik222 where

import Data.List
import Data.Set
import Data.Bits
import Data.Char

-- reprezentácia kocky
type RCube = ((Int,Int,Int,Int),(Int,Int,Int,Int),(Int,Int,Int,Int),(Int,Int,Int,Int),(Int,Int,Int,Int),(Int,Int,Int,Int)) 
{-             top side          down side         left side         right side        front side        back side
               t01,t01,t10,t11   d01,d01,d10,d11   l01,l01,l10,l11   r01,r01,r10,r11   f01,f01,f10,f11   b01,b01,b10,b11
               
                 +-------+
                 |b00 b01|
                 |b10 b11|
         +-------+-------+-------+-------+
         |l00 l01|t00 t01|r00 r01|d00 d01|
         |l10 l11|t10 t11|r10 r11|d10 d11|
         +-------+-------+-------+-------+
                 |f00 f01|
                 |f10 f11|
                 +-------+

-}
-- kedze potrebujete extremne rychle porovnavanie kociek, mozno pouzijete takto optimalizovany toString, ktory jednu stenu reprezentuje ako 16 bit char
toString (a,b,c,d) = chr ((shiftL a 12) + (shiftL b 8) + (shiftL c 4) + d)

-- toString pre kocku je vlastne 6 pismenkovy String, extremne dobre pre porovnavanie kociek, trochu horsie citatelne
-- preto si urobte vlastny toString pre ucely ladenia, ktory bude vyhovovat vam, kym to budete ladit
toStringC :: RCube -> String
toStringC (top, down, left, right, front, back) = [toString top,toString down,toString left,toString right,toString front,toString back]

-- zlozena kocka, a farebna abstrakcia, ak by ste potrebvali do nejakeho simulatora
-- white=1, red=3, green=6, blue=5, orange=4, yellow=2
initC :: RCube
initC = ((1,1,1,1), (2,2,2,2), (3,3,3,3), (4,4,4,4), (5,5,5,5), (6,6,6,6))

-- vsetky transformacie boli vygenerovane programom v jave
u:: RCube -> RCube
u ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t10,t00,t11,t01),(d01,d00,d11,d10),(l00,f00,l10,f01),(b10,r01,b11,r11),(r10,r00,f10,f11),(b00,b01,l11,l01))
u2:: RCube -> RCube
u2 ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t11,t10,t01,t00),(d01,d00,d11,d10),(l00,r10,l10,r00),(l11,r01,l01,r11),(b11,b10,f10,f11),(b00,b01,f01,f00))
u':: RCube -> RCube
u' ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t01,t11,t00,t10),(d01,d00,d11,d10),(l00,b11,l10,b10),(f01,r01,f00,r11),(l01,l11,f10,f11),(b00,b01,r00,r10))

d:: RCube -> RCube
d ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,t01,t10,t11),(d00,d10,d01,d11),(b01,l01,b00,l11),(r00,f11,r10,f10),(f00,f01,l00,l10),(r01,r11,b10,b11))
d2:: RCube -> RCube
d2 ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,t01,t10,t11),(d10,d11,d00,d01),(r11,l01,r01,l11),(r00,l10,r10,l00),(f00,f01,b01,b00),(f11,f10,b10,b11))
d':: RCube -> RCube
d' ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,t01,t10,t11),(d11,d01,d10,d00),(f10,l01,f11,l11),(r00,b00,r10,b01),(f00,f01,r11,r01),(l10,l00,b10,b11))

l:: RCube -> RCube
l ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((b00,t01,b10,t11),(f10,d00,f00,d10),(l10,l00,l11,l01),(r00,r01,r10,r11),(t00,f01,t10,f11),(d11,b01,d01,b11))
l2:: RCube -> RCube
l2 ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((d11,t01,d01,t11),(t10,d00,t00,d10),(l11,l10,l01,l00),(r00,r01,r10,r11),(b00,f01,b10,f11),(f00,b01,f10,b11))
l':: RCube -> RCube
l' ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((f00,t01,f10,t11),(b10,d00,b00,d10),(l01,l11,l00,l10),(r00,r01,r10,r11),(d11,f01,d01,f11),(t00,b01,t10,b11))

r:: RCube -> RCube
r ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,f01,t10,f11),(d01,b11,d11,b01),(l00,l01,l10,l11),(r10,r00,r11,r01),(f00,d10,f10,d00),(b00,t01,b10,t11))
r2:: RCube -> RCube
r2 ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,d10,t10,d00),(d01,t11,d11,t01),(l00,l01,l10,l11),(r11,r10,r01,r00),(f00,b01,f10,b11),(b00,f01,b10,f11))
r':: RCube -> RCube
r' ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,b01,t10,b11),(d01,f11,d11,f01),(l00,l01,l10,l11),(r01,r11,r00,r10),(f00,t01,f10,t11),(b00,d10,b10,d00))

f:: RCube -> RCube
f ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,t01,l10,l11),(d01,d00,r11,r10),(l00,l01,d10,d11),(r00,r01,t10,t11),(f10,f00,f11,f01),(b00,b01,b10,b11))
f2:: RCube -> RCube
f2 ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,t01,d10,d11),(d01,d00,t11,t10),(l00,l01,r10,r11),(r00,r01,l10,l11),(f11,f10,f01,f00),(b00,b01,b10,b11))
f':: RCube -> RCube
f' ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((t00,t01,r10,r11),(d01,d00,l11,l10),(l00,l01,t10,t11),(r00,r01,d10,d11),(f01,f11,f00,f10),(b00,b01,b10,b11))

b:: RCube -> RCube
b ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((r00,r01,t10,t11),(l01,l00,d11,d10),(t00,t01,l10,l11),(d00,d01,r10,r11),(f00,f01,f10,f11),(b10,b00,b11,b01))
b2:: RCube -> RCube
b2 ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((d00,d01,t10,t11),(t01,t00,d11,d10),(r00,r01,l10,l11),(l00,l01,r10,r11),(f00,f01,f10,f11),(b11,b10,b01,b00))
b':: RCube -> RCube
b' ((t00,t01,t10,t11),(d01,d00,d11,d10),(l00,l01,l10,l11),(r00,r01,r10,r11),(f00,f01,f10,f11),(b00,b01,b10,b11))=((l00,l01,t10,t11),(r01,r00,d11,d10),(d00,d01,l10,l11),(t00,t01,r10,r11),(f00,f01,f10,f11),(b01,b11,b00,b10))

-- zoznam vsetkych elementarnych tahov, hashmapa medzi elementarnou transformaciou kocky a jej menom (stringom), pre ucely vypisu...

-- ak ste sledovali prezentaciu, tak ste pochopili, ze lepsie ako zistovat vsetky symetrie kocky, je zafixovat si jeden rok kocky (napr. bielo/cerveno/modry vlavo hore, a nikdy s nim nepohnut.
-- potom sa nemusite starat o symetrie, lebo kocka, ktorej zafixujete jeden roh, uz nema symetrie. Lenze, miesto vsetkych 6x3 tahov mate k dispozicii len tie, ktore s tymto rozkom nehybu,
-- v nasom pripade jen tahy pravou stenou, zadnou stenou, a spodnou stenou. Takze nezistujete symetrie, a vsetkych moznych tahov mate 3x3, tu su:

allMoves :: [(RCube -> RCube, String)]
allMoves = [(r,"r"), (r2,"r2"), (r',"r'"), (b,"b"), (b2,"b2"),(b',"b'"), (d,"d"), (d2,"d2"), (d',"d'")] 

----------------------------------------- tu niekte zacina vas kod

perform :: String -> RCube -> RCube
perform = undefined

order :: (RCube -> RCube) -> Int
order = undefined               -- [1 bod]

maxOrder :: RCube-> RCube
maxOrder = undefined            -- [ 1-4 body podla order najdenej permutacie ]

solve :: RCube -> String
solve = undefined               -- [ 3 body ] 

optimal :: RCube-> String
optimal = undefined             -- [ 5 bodov ]

worst :: RCube
worst = undefined               -- [ 5 bodov ]
