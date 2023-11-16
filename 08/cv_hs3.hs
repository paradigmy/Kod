import qualified  Data.Map as M
import Data.List
import Data.Char

import Graphics.UI.GLUT


--GrahamScan
grahamScan :: [(Float,Float)]->[(Float,Float)]
grahamScan x = foldr hf y (drop 2 x)
              where
                hf a (p1:p2:xs) = if  not $ isClockwise p2 p1 a 
                  then a : (p2:xs)
                  else a :(p1:(p2:xs))
                y= [x!!1,x!!0]

isClockwise :: (Float,Float) -> (Float,Float) -> (Float,Float) -> Bool 
isClockwise (x1,y1) (x2, y2) (x3,y3) = 0 >=  (ax*by - bx*ay)
                  where ax = x2-x1
                        ay = y2-y1
                        bx = x3-x2
                        by = y3-y2 

vertex2point x = [(a,b)|(a,b,_)<-x]
point2vertex x = [(a,b,0)|(a,b)<-x]
main :: IO ()
main = do
  (_progName, _args) <- getArgsAndInitialize
  _window <- createWindow  "hs2" 
  windowSize $= (Size 800 600)
  displayCallback $= display
  mainLoop

vertices ::[(GLfloat, GLfloat, GLfloat)]
vertices = [(0,0,0),(0.5,0,0),(0.75,0,0),(0.75,0.25,0),(0.5,0.25,0),(0.5,0.5,0),(0.25,0.75,0),(0,0.5,0)]

display :: DisplayCallback
display = do 
  color $ Color4 1  1 (1 :: GLfloat) 1.0
  clear [ColorBuffer]  
  color $ Color4 0 0 (1 :: GLfloat) 1.0
  lineWidth $= 2
  renderPrimitive LineLoop $ 
    mapM_ (\(a,b,c) -> vertex $ Vertex3 a b c) vertices
  color $ Color4 1 0 (0 :: GLfloat) 1.0
  renderPrimitive LineLoop $ 
    mapM_ (\(a,b,c) -> vertex $ Vertex3 (a-1.0) b c) $ point2vertex $ grahamScan $ vertex2point vertices
  flush


------------------------------------------------
pripocitaj :: M.Map String Int -> String -> Int
pripocitaj zoznam komu = (M.findWithDefault 0 komu zoznam) + 1

pripocitaj2 :: M.Map String Int -> String -> Int
pripocitaj2 zoznam komu = case M.lookup komu zoznam of
                            Just a -> a+1
                            Nothing -> 0+1 


rozdelPodlaZnaku :: String -> Char -> [String]
rozdelPodlaZnaku [] z = [[]]
rozdelPodlaZnaku (x:xs) z = if x==z then []:(rozdelPodlaZnaku xs z) else let a=(rozdelPodlaZnaku xs z) in (x:(head a)):(tail a)

zamenSlova :: String -> M.Map String String ->String
zamenSlova x slova = foldr hf "" (rozdelPodlaZnaku x ' ')
                    where 
                        hf a acc = M.findWithDefault a a slova ++ " "++acc
---------------------------------------------------------
type Cube = (Int, Int, Int, Int, Int, Int)
            --horna, spodna, prava, lava, predna, zadna
kocka ::Cube
kocka = (1,6,3,4,2,5)

vpravo :: Cube -> Cube
vpravo  (horna, spodna, prava, lava, predna, zadna) = (horna, spodna, predna, zadna,lava ,prava)

dole :: Cube -> Cube 
dole (horna, spodna, prava, lava, predna, zadna) = (zadna, predna, prava, lava,horna , spodna)

vpravoN c 0 = c
vpravoN c n = vpravo $ vpravoN c (n-1)

doleN c 0 = c
doleN c n = dole $ doleN c (n-1)

rotacie ::Cube -> [Cube]
rotacie c = nub $  [doleN (vpravoN c j) i | i<-[0..3], j <- [0..3]] ++ [ doleN(vpravoN (dole c) j) i | i<-[0..3], j <- [0..3]]

test :: Cube -> [Cube] -> Bool
test c [] = True
test (_, _, prava, lava, predna, zadna) xs = and[prava/=xprava && lava/=xlava && predna/=xpredna && zadna/=xzadna | (_, _, xprava, xlava, xpredna, xzadna) <- xs] 

solve :: [Cube]-> [Cube] -> [[Cube]]
solve [] solution = [solution]
solve (x:xs) solution = concat[solve xs (r:solution) | r <- rotacie x, test r solution]
------------------------------------------------------------------
type Had = [Int]

had1   ::Had
had1  = [3,3,3,3,2,2,2,3,3,2,2,3,2,3,2,2,3]


type Kocka = (Int, Int, Int)

type Usek = [Kocka]

type SVektor  = (Int,Int,Int)
kolmo  :: SVektor -> [SVektor]
kolmo (_,0,0)   = [ (0,1,0), (0,-1,0), (0,0,1), (0,0,-1) ]
kolmo (0,_,0)   = [ (1,0,0), (-1,0,0), (0,0,1), (0,0,-1) ]
kolmo (0,0,_)   = [ (0,1,0), (0,-1,0), (1,0,0), (-1,0,0) ]

vytvorUsek :: Kocka -> SVektor -> Int -> Usek 
vytvorUsek _ _ 1 = []
vytvorUsek (a,b,c) (sx,sy,sz)  dlzka = vytvorUsek aktZac (sx,sy,sz) (dlzka -1 ) ++ [aktZac]
                            where
                                aktZac = (a+sx,b+sy,c+sz)
testUsek :: Usek -> Bool
testUsek [] = True
testUsek ((a,b,c):xs) = (elem a [1..3]) && (elem b [1..3]) && (elem c [1..3]) && (testUsek xs)

test solution = length (nub sol) == (length sol)
                where sol = concat solution 

solve :: Had -> [Usek] -> SVektor -> [[Usek]]
solve [] solution smer = [solution]
solve (x:xs) solution smer = concat [solve xs ((vytvorUsek ending aktSmer x):solution) aktSmer| 
                                    aktSmer <- kolmo smer, testUsek (vytvorUsek ending aktSmer x),
                                    test ((vytvorUsek ending aktSmer x):solution)]
                             where
                                ending = head (head solution)