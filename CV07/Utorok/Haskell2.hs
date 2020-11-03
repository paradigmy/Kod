import  Data.List

-- definujme vsetky podmnoziny danej mnoziny, ale predpokladame, ze na vstup je fakt mnozina, prvky sa neopakuju...

powerSet :: [t] -> [[t]]
powerSet = undefined
                    
-- powerSet [1,2,3]

-- zamyslime sa, ci vieme porovnat (Eq, Ord)
-- dvojice (1,2) < (1,3)
-- n-tice  (1,1,2) < (1,1,3)
-- zoznamy [1,1,2] < [1,1,2]
-- mnoziny

----------------------------------------------------------- APLIKOVANA KOMBINATORIKA
-- Na partii sa stretlo 5 chalanov a 5 bab

type Party = [String]
party = ["Adam", "Andrej", "Daniel", "Cyril", "Fero",
         "Zuzana", "Romana", "Xenia", "Nada", "Tatiana"]

-- kazdy si strngol s kazdym
type Dvojica = (String, String)

pripitok :: Party -> [Dvojica]
pripitok p = undefined

-- pripitok party
-- length$ pripitok party 

------------------------------------------------------------

-- k=traja maju zostavit projektovy tim na TISko
-- niekedy je lepsie abstrahovat a riesit pre vseobecny pripad k = 0..10

type Team = [String]
tisko :: Party -> Int -> [ Team ]
tisko p k  = undefined

-- length $ tisko party 2 

-- co z toho, co poznate to je, kombinacie/variacie s/bez opakovania








--  kombinacie  bez  opakovania  (n  nad  k)
kbo :: [t] -> Int -> [[t]]
kbo  _  0       =  [[]]
kbo  []  _      =  []
kbo  (x:xs)  k  =  [x:y  |  y  <-kbo  xs  (k-1)]  ++  kbo  xs  k

---------------------------------------------------------------------------

-- po party vznikli dvojice, (chalan,baba), kolatimi sposobmi sa mohli sparovat
-- party = ["Adam", "Andrej", "Daniel", "Cyril", "Fero",
--          "Zuzana", "Romana", "Xenia", "Nada", "Tatiana"]


boyz :: Party -> Party
boyz = undefined
girlz :: Party -> Party
girlz = undefined

type Dvojice = [ Dvojica ]
type Moznosti = [ Dvojice ]

-- sparuj boys girls = ... a predpokladame, ze |boys| = |girls|
sparuj :: Party -> Party -> [ Dvojice ]  -- Moznosti
sparuj = undefined




-- co to bolo, kombinacie, variacie, ... ?






-- z prednasky, permutacie bez opakovania
pbo [] = [ [] ]
pbo xs = [ x:p | x <- xs, p <- pbo (xs \\ [x])   ]

-- sparuj ["a","b"] ["c","d"]

dvojice :: Party -> Moznosti
dvojice p = undefined

-- length $ dvojice party

-- na party vzniko k dvojic, zvysni zostali nesparovani, kolkatimi sposobni to mohlo nastat
kdvojic :: [String] -> Int -> Moznosti
kdvojic p k = undefined

-- length $ kdvojic party 2      
-- length $ kdvojic party 3   


-- postavili sa do rady tak, ze chalan a baba sa striedaju
dorady p = undefined

--length $ dorady party


-- postavili sa do rady tak, ze vsetky baby su pokope, vedla seba
pokope p = undefined
                 
-- length $ pokope party                 

-----------------------------------------------

-- chalani a baby hrali spoloc.hry, a vznikla vysledkova listina, na ktorej su prve tri miesta/
-- ako mohol dopadnut nocny turnaj, relativne na 3prvkovu vysledkovku

{-
length $ vbo party 3
length $ vbo party 4
length $ vbo party 5
length $ vbo party 10
-}

-- chalani a baby si zahrali niekolko 14krat spolocensku hru, pricom baby vyhrali 7:4 a 3x nastala remiza
-- ake su moznosti, ako sa mohli hry vyvijat

e = (take 7 (repeat "baby")) ++ (take 4 (repeat "chalani")) ++ (take 3 (repeat "remiza"))

      
-- length $ pso e
-- fact 14/(fact 7*fact 4 * fact 3)

fact n = product [1..n]      