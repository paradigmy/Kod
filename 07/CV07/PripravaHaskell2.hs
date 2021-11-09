import  Data.List

-- definujme vsetky podmnoziny danej mnoziny, ale predpokladame, ze na vstup je fakt mnozina, prvky sa neopakuju...

powerSet :: [t] -> [[t]]
powerSet [] = [[]]
powerSet (x:xs)   = let pom = powerSet xs 
                    in pom ++ [ x:p | p<-pom] 
                    
-- powerSet [1,2,3]

-- zamyslime sa, ci vieme porovnat (Eq, Ord)
-- dvojice (1,2) < (1,3)
-- ntice  (1,1,2) < (1,1,3)
-- zoznamy [1,1,2] < [1,1,2]
-- mnoziny

--  podmnoziny  mnoziny  a
data  SubSet  a  =  Set  [a]  deriving  (Show)
--  toto  nejde...    
--  type  SubSet  a  =    [a]

-- definujeme rovnost pre takyto typ
{-
instance  Eq  a => Eq  (SubSet  a)  where
     Set  x  ==  Set  y            =  (x  ==  y)
     Set  x  /=  Set  y            =  (x  /=  y)
     -}
-- Set [2,1] == Set [1,2]

-- https://oskole.detiamy.sk/clanok/vennove-diagramy
instance  Eq  a => Eq  (SubSet  a)  where
     Set  x  ==  Set  y            =  (x \\ y == []) && (y \\ x == [])
     Set  x  /=  Set  y            =  (x \\ y /= []) || (y \\ x /= [])
-- Set [2,1] == Set [1,2]


-- definujeme mensi ako pre takyto typ
instance  Eq  a  => Ord  (SubSet  a)    where
     Set  x  <=  Set  y         =  (x  \\  y  ==  [])    --  x  je  podmnozina  y
     a  >=  b                   =  b  <=  a
     a  <  b                    =  a  <=  b  &&  a  /=  b
     a  >  b                    =  b  <  a
     max  (Set  x)  (Set  y)    =  Set  (nub  (x  ++  y))
     min  (Set  x)  (Set  y)    =  Set  (intersect  x  y)


----------------------------------------------------------- APLIKOVANA KOMBINATORIKA
-- Na partii sa stretlo 5 chalanov a 5 bab

-- kazdy si strngol s kazdym
type Party = [String]
party = ["Adam", "Andrej", "Daniel", "Cyril", "Fero",
         "Zuzana", "Romana", "Xenia", "Nada", "Tatiana"]

type Dvojica = (String, String)

--pripitok p = [ (o1,o2) | o1 <- p, o2 <- p ]
--pripitok p = [ (o1,o2) | o1 <- p, o2 <- p, o1 /= o2 ]
--pripitok p = [ (o1,o2) | o1 <- p, o2 <- p \\ [o1] ]
--pripitok p = nubBy (\(a,b) -> \(c,d) -> (a,b)==(c,d) || (a,b)==(d,c)) [ (o1,o2) | o1 <- p, o2 <- p \\ [o1] ]
pripitok :: Party -> [Dvojica]
pripitok p = [ (p!!i1,p!!i2)| i1 <-[0..length p-1], i2 <-[i1+1..length p-1] ]

-- pripitok party
-- length$ pripitok party = 45

-- k=traja maju zostavit projektovy tim na TISko
-- niekedy je lepsie abstrahovat a riesit pre vseobecny pripad k = 0..10

type Team = [String]
tisko :: Party -> Int -> [ Team ]
tisko p 0  = [ [] ]
tisko [] _ = [    ]
tisko (x:xs) k = tisko xs k ++ [ x:t | t <- tisko xs (k-1) ]

-- length $ tisko party 2 = 45
-- length $ tisko party 3 = 120
-- length $ tisko party 4 = 210
-- length $ tisko party 5 = 252
-- length $ tisko party 6 = 210
-- length $ tisko party 7 = 120
-- length $ tisko party 8 = 45
-- length $ tisko party 9 = 10
-- length $ tisko party 10 = 1


--  kombinacie  bez  opakovania  (n  nad  k)
kbo :: [t] -> Int -> [[t]]
kbo  _  0       =  [[]]
kbo  []  _      =  []
kbo  (x:xs)  k  =  [x:y  |  y  <-kbo  xs  (k-1)]  ++  kbo  xs  k

-- to su kombinacie bez opakovania a teda cisla v Pascalovom trojuholniku
--  kombinacie  s  opakovanim  (n+k-1  nad  k)

kso :: [t] -> Int -> [[t]]
kso = undefined

---------------------------------------------------------------------------

-- po party vznikli dvojice, chalan+baba, kolatimi sposobmi sa mohli sparovat
boyz :: Party -> Party
boyz = filter (\x -> x!!0 < 'M')
girlz :: Party -> Party
girlz = filter (\x -> x!!0 >= 'M')

type Dvojice = [ Dvojica ]
type Moznosti = [ Dvojice ]

sparuj :: Party -> Party -> [ Dvojice ]  -- Moznosti
sparuj [] []   = [ [] ]
--sparuj [b] [g]   = [ [(b,g)] ]
sparuj (b:bs) gs = [ (b,g):dv | g <- gs, dv <- sparuj bs (gs\\[g]) ]

-- z prednasky
pbo [] = [ [] ]
pbo xs = [ x:p | x <- xs, p <- pbo (xs \\ [x])   ]

-- sparuj ["a","b"] ["c","d"]

dvojice :: Party -> Moznosti
dvojice p = let bs = boyz p
                gs = girlz p
                in sparuj bs gs

-- length $ dvojice party
-- 120

-- na party vzniko k dvojic, zvysni zostali nesparovani, kolkatimi sposobni to mohlo nastat
kdvojic :: [String] -> Int -> Moznosti
kdvojic p k = let bs = boyz p
                  gs = girlz p
                  in concat [ sparuj hb hg | hb <- kbo bs k, hg <- kbo gs k ]

-- length kdvojic party 2      
-- length $ kdvojic party 3   
-- 25, 200, 600, 600, 120


-- postavili sa do rady tak, ze chalan a baba sa striedaju
dorady p = let bs = boyz p
               gs = girlz p
               in
                 [concat $ zipWith (\x -> \y -> [x,y]) pbs pgs |
                        pbs<-permutations bs,
                        pgs<-permutations gs ]

--length $ dorady party


-- postavili sa do rady tak, ze vsetky baby su pokope, vedla seba
pokope p = let bs = boyz p
               gs = girlz p
               in
                 [ take i pbs ++ pgs ++ drop i pbs |
                        pbs<-permutations bs,
                        pgs<-permutations gs,
                        i <- [0..length pbs]                        
                 ]
                 
-- length $ pokope party                 

-----------------------------------------------
-- chalani a baby hrali spoloc.hry, a vznikla vysledkova listina, na ktorej su prve tri miesta/
-- ako mohol dopadnut nocny turnaj, relativne na 3prvkovu vysledkovku

vbo xs 0    =  [ []  ]
vbo [] _    =  []
vbo xs k = [ x: ys | x<-xs, ys <- vbo (xs\\[x]) (k-1) ]

--length $ vbo party 2

{-
length $ vbo party 3
length $ vbo party 4
length $ vbo party 5
length $ vbo party 10
-}

-- chalani a baby si zahrali niekolko 14krat spolocensku hru, pricom baby vyhrali 7:4 a 3x nastala remiza
-- ake su moznosti, ako sa mohli hry vyvijat

e = (take 7 (repeat "baby")) ++ (take 4 (repeat "chalani")) ++ (take 3 (repeat "remiza"))

pso [] = [ [] ]
pso xs = [ x:p | x <- nub xs, p <- pso (xs \\ [x])   ]
      
-- length $ pso e
-- fact 14/(fact 7*fact 4 * fact 3)

fact n = product [1..n]      