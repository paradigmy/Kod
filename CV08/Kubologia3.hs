import Data.List

type Cube = (Int, Int, Int)     -- suradnice jednej kocky 
type Shape = [Cube]             -- jeden utvar, viacero kociek

size = 3                        -- velkost hlavolamu
size1 = size-1

-- neofarbena verzia: https://www.teaching.co.nz/product/TFC10494
zlteT :: Shape
zlteT = [(0,0,0), (0,0,1), (0,0,2), (0,1,1)]

zeleneS :: Shape
zeleneS = [(0,0,0), (0,0,1), (0,1,1), (0,1,2)]

cerveneV :: Shape
cerveneV = [(0,0,0), (0,0,1), (0,1,0)]

cerveneLL :: Shape
cerveneLL = [(0,0,0), (0,0,1), (0,1,0), (1,1,0)]

modreLL :: Shape
modreLL = [(0,0,0), (0,0,1), (1,0,1), (0,1,0)]

zeleneW :: Shape
zeleneW = [(0,0,0), (0,0,1), (0,1,0), (1,0,0)]

modreL :: Shape
modreL = [(0,0,0), (0,0,1), (0,0,2), (0,1,0)]
-------------------------------- jeden testovaci shape
i :: Shape
i = [(0,0,0), (0,0,1), (0,0,2)]
-------------------------------- posunutie o vektor
type Vector = (Int, Int, Int)
move :: Vector -> Shape -> Shape
move (dx,dy,dz) sh = [ (x+dx, y+dy, z+dz)| (x,y,z) <- sh ]

-------------------------------- rotacia, na rotacie treba pochopit maticu rotacie a Eulerove uhly, plus vediet nasobit maticu s vektorom
-- ak chces rozumiet, a nie si uz stvrtak, tak pozri tu: http://www.cs.brandeis.edu/~cs155/Lecture_07_6.pdf
-- alebo v skratke tu: https://github.com/paradigmy/Kod/tree/master/CV08

type Matrix = [[Int]]
-- trochu Eulerovskej "geometrie", linearna algebra pre grafikov :)
rotateAll :: (Double,Double,Double) -> Shape -> Shape
rotateAll (angleX, angleY, angleZ) sh =         -- eulerovska rotacia je zlozenie troch rotacii
            (rotate (rotateMatrixZ angleZ)              -- okolo osi z
                (rotate (rotateMatrixY angleY)          -- okolo osi y
                    (rotate (rotateMatrixX angleX) sh)))-- okolo osi x
         where
            rotateMatrixX :: Double -> Matrix   -- matica rotacie okolo osi x
            rotateMatrixX theta = [ [1,                     0,                  0                   ], 
                                    [0,                     round(cos theta),   round(-(sin theta)) ], 
                                    [0,                     round(sin theta),   round(cos theta)    ] 
                                  ]
            rotateMatrixY :: Double -> Matrix   -- matica rotacie okolo osi y
            rotateMatrixY theta = [ [round(cos theta),      0,                  round(sin theta)    ], 
                                    [0,                     1,                  0                   ], 
                                    [round(-(sin theta)),   0,                  round(cos theta)    ] 
                                  ]
            rotateMatrixZ :: Double -> Matrix   -- matica rotacie okolo osi z
            rotateMatrixZ theta = [ [round(cos theta),      round(-(sin theta)),0                   ], 
                                    [round(sin theta),      round(cos theta),   0                   ], 
                                    [0,                     0,                  1                   ] 
                                  ]
            -------------------------------------------- nasobenie matice a vektora, hardcode pre SIZE = 3
            matrixTimesVector :: Matrix -> Cube -> Cube
            matrixTimesVector [[a00,a01,a02],[a10,a11,a12],[a20,a21,a22]] (x,y,z) = 
                                            (a00*x+a01*y+a02*z, a10*x+a11*y+a12*z, a20*x+a21*y+a22*z)
            --------------------------------------- zrotuj uvrar, znamena zrotuj vsetky kocky utvaru
            rotate :: Matrix -> Shape -> Shape
            rotate matrix sh = [ matrixTimesVector matrix (x,y,z)| (x,y,z) <- sh]

----------------------------------- rozumne posunutia, ktore prichadzaju do uvahy
allShifts :: [Shape -> Shape]
allShifts =  [move (dx, dy, dz) | dx <-left2right, dy <-left2right, dz <-left2right]  -- 5*5*5 moznosti
              where left2right = [-size1..size1]  
             
----------------------------------- rozumne otocenia, ktore prichadzaju do uvahy
allRotates :: [Shape -> Shape]
allRotates =  [rotateAll (angleX, angleY, angleZ) |  angleX <- angles, angleY <- angles, angleZ <- angles ] 
              where angles = [0, pi/2, pi, 3*pi/2]  -- 4*4*4 moznosti
----------------------------------- test, ci cely utvar je v kocke SIZE x SIZE x SIZE
isIn :: Shape -> Bool
isIn sh = all (\(x,y,z) -> elem x [0..size1] && elem y [0..size1] && elem z [0..size1]) sh
{- 
- vsetky umiestnenia utvaru dostaneme tak, ze na vsetky jeho rotacie aplikujeme vsetky posunutia
- vyfiltrujeme len tie utvary, ktore nevybehli z kocky, ostatne zahodime
- pre redukciu moznosti, utriedime kazdu moznost usporiadanim na trojicu suradnic kociek utvaru
- vyhodime duplicity
-}
placements :: Shape -> [Shape]
placements sh = nub $ (map sort) $ filter isIn [shift (rot sh) | rot <- allRotates, shift <- allShifts ]
{-
test, ci sa kocky roznych utvarov neprekryvaju
- kocky vsetkych utvarov nahadzeme do jedneho zoznamu
- a zistime, ci sa tam nieco opakuje.
- ak ano, tak sa take utvary prekryvaju, neda sa to zlozit
- ak nie, tak ok
-}
allDifferent :: Shape -> Bool
allDifferent sh = length (nub sh) == length sh

isOK :: [Shape] -> Bool
isOK shapes = allDifferent allTogether 
              where allTogether = concat shapes

------------------------------------- samotny solver
solve =   [ (a,b,c,d,e,f,g) | 
                      a <- plzlteT, 
                      b <- plzeleneS, isOK [a,b], 
                      c <- plcerveneV, isOK [a,b,c],  -- 141408
                      d <- plcerveneLL, isOK [a,b,c,d],   -- 1356000
                      e <- plmodreLL, isOK [a,b,c,d,e],    -- 2681952 (713.82 secs, 467,631,060,160 bytes)
                      f <- plzeleneW, isOK [a,b,c,d,e,f],    --  552384 (1842.91 secs, 1,139,692,909,536 bytes)
                      g <- plmodreL, isOK [a,b,c,d,e,f,g]    --  11520 (2902.18 secs, 1,501,758,174,072 bytes)
          ]
{-
*Main> head solve
(
[(0,0,0),(0,0,1),(0,0,2),(0,1,1)],  -- zlteT
[(1,0,0),(1,0,1),(1,1,1),(1,1,2)],  -- zeleneS
[(2,0,0),(2,1,0),(2,1,1)],
[(0,1,2),(0,2,2),(1,2,1),(1,2,2)],
[(0,1,0),(0,2,0),(0,2,1),(1,1,0)],
[(1,0,2),(2,0,1),(2,0,2),(2,1,2)],
[(1,2,0),(2,2,0),(2,2,1),(2,2,2)])  -- modreL
(0.90 secs, 553,476,112 bytes)
-}          
-- 11520 = 2^8 * 3^2 * 5
------------------------------------- v poradi od najtazsieho (najmenej moznosti na umiestnenie v prazdnej kocke)
solve1 =   [ (a,b,c,d,e,f,g) | 
                      a <- plzeleneW, 
                      b <- plzlteT, isOK [a,b], 
                      c <- plzeleneS, isOK [a,b,c],  
                      d <- plcerveneLL, isOK [a,b,c,d],   -- 272616 (21.34 secs, 12,130,744,816 bytes)
                      e <- plmodreLL, isOK [a,b,c,d,e],    -- 312720 (215.45 secs, 102,145,415,960 bytes)
                      f <- plcerveneV, isOK [a,b,c,d,e,f],    -- 552384 (589.85 secs, 281,759,472,984 bytes)
                      g <- plmodreL, isOK [a,b,c,d,e,f,g]    --  11520 (1566.69 secs, 643,839,671,144 bytes)
          ]

{-- prve riesenie: head solve1
(
[(0,0,0),(0,0,1),(0,1,0),(1,0,0)],  -- zeleneW
[(2,0,0),(2,0,1),(2,0,2),(2,1,1)],  -- zlteT
[(0,1,1),(0,1,2),(1,1,0),(1,1,1)],  -- zeleneS
[(1,2,0),(1,2,1),(2,1,0),(2,2,0)],  -- cerveneLL
[(1,1,2),(2,1,2),(2,2,1),(2,2,2)],  -- modreLL
[(0,0,2),(1,0,1),(1,0,2)],          -- cerveneV
[(0,2,0),(0,2,1),(0,2,2),(1,2,2)])  -- modreL
(1.42 secs, 684,139,648 bytes)

-- overenie spravnosti, vsetky kocky su pokryte...
concat   sort $ concat  [[(0,0,0),(0,0,1),(0,1,0),(1,0,0)],[(2,0,0),(2,0,1),(2,0,2),(2,1,1)],[(0,1,1),(0,1,2),(1,1,0),(1,1,1)],[(1,2,0),(1,2,1),(2,1,0),(2,2,0)],[(1,1,2),(2,1,2),(2,2,1),(2,2,2)],[(0,0,2),(1,0,1),(1,0,2)],[(0,2,0),(0,2,1),(0,2,2),(1,2,2)]]

[(0,0,0),(0,0,1),(0,0,2),(0,1,0),(0,1,1),(0,1,2),(0,2,0),(0,2,1),(0,2,2),
 (1,0,0),(1,0,1),(1,0,2),(1,1,0),(1,1,1),(1,1,2),(1,2,0),(1,2,1),(1,2,2),
 (2,0,0),(2,0,1),(2,0,2),(2,1,0),(2,1,1),(2,1,2),(2,2,0),(2,2,1),(2,2,2)
]
--}

---- pocty moznosti
plzlteT = placements zlteT          -- 72.
plzeleneS = placements zeleneS      -- 72.
plcerveneV = placements cerveneV    -- 144
plcerveneLL = placements cerveneLL  -- 96.
plmodreLL = placements modreLL      -- 96.
plzeleneW = placements zeleneW      -- 64.
plmodreL = placements modreL        -- 144

allShapes :: [Shape]
allShapes =  [zlteT, zeleneS, cerveneV, cerveneLL, modreLL, zeleneW, modreL]

allShapes1 :: [Shape]
allShapes1 =  [zeleneW, zlteT, zeleneS, cerveneLL, modreLL, cerveneV, modreL]

someShapes :: [Shape]
someShapes =  [zeleneW, zlteT, zeleneS]


backtrack1 :: [Shape] -> [[Shape]]
backtrack1 [] = [[]]
backtrack1 (sh:shapes) = [ (a:b) | a <- placements sh, b <- backtrack1 shapes, isOK (a:b) ]
{- 41520 (1165.88 secs, 567,820,329,472 bytes) -}

backtrack2 :: [Shape] -> [[Shape]]
backtrack2 [] = [[]]
backtrack2 (sh:shapes) = [ (a:b) | b <- backtrack2 shapes, a <- placements sh, isOK (a:b) ]
{- 41520 (734.84 secs, 341,626,494,216 bytes) -}
