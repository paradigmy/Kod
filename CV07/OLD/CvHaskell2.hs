import Data.List

{- temy na dnes:
- zoznamy
- polynomy
- matice
- vsetko s list comprehension
-}

-- riesenie niektorych prikladov DU

zrotuj k xs = reverse ((reverse (take k xs)) ++ (reverse (drop k xs)))

prienik xs ys = [x | x<-xs, elem x ys]

-- resp. ak nepozname elem

prienik' xs ys = [x | x<-xs, or [x==y | y<-ys]]

-- resp. ak chceme odstranit duplikaty

prienik'' xs ys = nub [x | x<-xs, elem x ys]

----------- warm-up : postupnosti (aritmeticka, geometricka, ...)

{- artitmeticka postupnost s prvym prvkom a0, krokom delta a limitom max -}

aritmeticka a0 delta max = [a0, a0+delta .. max]

aritmeticka' a0 delta max | a0 > max = []
              |otherwise = a0:aritmeticka' (a0+delta) delta max

{- geometricka postupnost s prvym prvkom a0, kvocientom q a limitom max -}

geometricka' a0 q max | a0 > max = []
               |otherwise = a0:geometricka' (a0*q) q max

------------- Rekurzia na zoznamoch
-- jednoduchy priklad na rozbeh...
-- scitaj neparne cisla zoznamu [Int], ktore su sprava aj zlava oblozene 0

neparne         :: [Int] -> Int
neparne (0:x:0:xs)    = (if odd x then x else 0) + neparne (0:xs)
neparne (x:xs)    = neparne xs
neparne _         = 0

-- zipovanie zoznamov, prvky sa beru na striedacku
-- dva zoznamy [a1,a2, ...] [b1, b2, ...] zozipsuje do [a1,b1,a2,b2, ...], chvost je z dlhsieho...
zipZoznamy    ::    [Int] -> [Int] -> [Int]
zipZoznamy    [] ys    = ys
zipZoznamy    xs []    = xs
zipZoznamy     (x:xs) (y:ys) = x:y:zipZoznamy xs ys

-- zoberie dva usporiadane zoznamy a spoji ich do jedneho usporiadaneho zoznamu
merge            :: [Int] -> [Int] -> [Int]
merge [] ys        = ys
merge xs []        = xs
merge (x:xs) (y:ys)    | x < y    = x:merge xs (y:ys)
            | otherwise = y:merge (x:xs) ys
                    
-- urobte modifikaciu merge, ktora zaroven vyhodi opakujuce sa prvky
merge'                :: [Int] -> [Int] -> [Int]
merge' [] ys            = ys
merge' xs []            = xs
merge' (x:xs) (y:ys)    | x == y    = x:merge' xs ys
            | x < y        = x:merge' xs (y:ys)
            | otherwise     = y:merge' (x:xs) ys
            
            
-- definujte funkciu najNek, ktora pre zoznam celych cisel vrati dlzku
-- najdlhsej neklesajucej postupnosti

najNek :: [Int] -> Int
najNek [] = 0
najNek (z:zs) = nn zs z 1 0
nn [] bol mam bolo = max mam bolo
nn (x:xs) bol mam bolo | x >= bol  = nn xs x (mam + 1) bolo
                       | otherwise = nn xs x 1 (max mam bolo)
                       
--------------------- Matice                       

vsetkyParne :: [Int] -> Bool
vsetkyParne z = all even z
-- vsetkyParne [1,2,3,4,5] -> False

type Riadok     = [Int]
type Matica     = [Riadok]

parnaMatica :: Matica -> Bool
parnaMatica m = and (map (\r -> all even r) m)
-- parnaMatica [[2,4,6],[2,2,0],[54,2332,122]] -> True

parneZMatice :: Matica -> Matica
parneZMatice m = map (\r -> filter even r) m
-- parneZMatice [[1,2,3],[4,5,6],[7,8,9]] -> [[2],[4,6],[8]]

pocetParnychVMatici :: Matica -> Int
pocetParnychVMatici m = sum (map length (parneZMatice m))
-- pocetParnychVMatici [[1,2,3],[4,5,6],[7,8,9]] -> 4


-- nasobenie dvoch matic rovnakeho rozmeru
-- predpokladame, ze matice stvorcove, rovnakych rozmerov
-- tri vnorene "cykly"
nasobMatice     :: Matica -> Matica -> Matica
nasobMatice m n    = 
        [ [ sum [ m!!i!!k * n!!k!!j | k <- [0..length m-1] ]        
                         | j <- [0..length m-1] ]
                            | i <- [0..length m-1] ]

-- male testovacie data
m1    :: Matica                       
m1 = [[1,2,3],[4,5,6],[7,8,9]]                       
m2    :: Matica                       
m2 = [[1,0,0],[0,1,0],[0,0,1]]                       
m3    :: Matica                       
m3 = [[1,1,1],[1,1,1],[1,1,1]]                       
m4    :: Matica                       
m4 = [[1,0,0],[2,1,0],[3,2,1]]                       
m5    :: Matica                       
m5 = [[1,2,3],[0,1,2],[0,0,1]]                       
                       
-- vytvor jednotkovu maticu
vyrobJednotkovuMaticu :: Int -> Matica 
vyrobJednotkovuMaticu n = [ [ if i==j then 1 else 0 | j<-[1..n]] | i<- [1..n] ]

-- zkradlovy obraz matice, otoci riadky zlava doprava
zrkadliZlavaDoprava    :: Matica -> Matica
zrkadliZlavaDoprava m = [ reverse riadok | riadok <- m]

-- zkradlovy obraz matice, prvy riadok je poslendym a posledny prvym
zrkadliZhoraDole    :: Matica -> Matica
zrkadliZhoraDole m     = reverse m

-- otocenie matice podla stredu
otoceniePodlaStredu    :: Matica -> Matica
otoceniePodlaStredu m     = zrkadliZlavaDoprava (zrkadliZhoraDole m)

-- transponuj maticu (z prednasky)
transponuj         :: Matica -> Matica
transponuj    []    = []
transponuj      ([]:xss)= transponuj xss
transponuj    ((x:xs):xss)= (x:(map head xss)):(transponuj (xs:(map tail xss)))

-- transponuj podla druhej diagonaly
transponuj2    :: Matica -> Matica
transponuj2    m    =    zrkadliZlavaDoprava (transponuj (zrkadliZlavaDoprava m))
                  
-- zisti, ci vsetky riadky su rovnako dlhe
jeMatica    :: Matica -> Bool
jeMatica []    = True
jeMatica (r:rs)    = and [ length r == length riadok | riadok <- rs ]

-- zisti, ci je stvorcova
jeStvorcova    :: Matica -> Bool
jeStvorcova []    = True
jeStvorcova m    = length m == length (head m) && jeMatica m
                                  
-- rozcvicka 1,2,3
jeSymetricka    :: Matica -> Bool
jeSymetricka    m     = and [ m!!i!!j == m!!j!!i | i<-[0..length m-1], j<-[0..length m-1], i<j ]

jeTrojuholnikova    :: Matica -> Bool
jeTrojuholnikova m     = and [ if i<=j then m!!i!!j /= 0 else m!!i!!j == 0  | i<-[0..length m-1], j<-[0..length m-1] ]

jeJednotkova        :: Matica -> Bool
jeJednotkova m         = and [ m!!i!!j == if i==j then 1 else 0 | i<-[0..length m-1], j<-[0..length m-1] ]

---------------------------------- Polynomy jednej premennej

type Poly = [Float]

p1    :: Poly
p1    = [3,2,1]    -- 3+2x+x^2
p2    :: Poly
p2    = [1,0,1]    -- 1+x^2
p3    :: Poly
p3     = [1]        -- 1

sucet            :: Poly -> Poly -> Poly
sucet [] []        = []
sucet ps []        = ps
sucet [] qs        = qs
sucet (p:ps) (q:qs)    = (p+q):sucet ps qs

hodnota         :: Poly -> Float -> Float
hodnota [] x        = 0
hodnota (p:ps) x    = p+x*(hodnota ps x)

sucinConst        :: Poly -> Float -> Poly
sucinConst    ps k    = [ k*x | x <- ps]
-- sucinConst  ps k    = map (*k) ps

sucin            :: Poly -> Poly -> Poly
sucin [] qs        = []
sucin (k:ps) qs        = sucet (sucinConst qs k) (0:(sucin ps qs))

-- derivuj Poly 

sucin' :: Poly -> Poly -> Poly
sucin' p q =
    [ sum
       [ (koef j p) * (koef k q)
         | j<-[0..(length p)-1], k<-[0..(length q)-1], j+k == i]    -- sucin koeficientov j,k da mocninu i
      | i<-[0..(length p)+(length q)-2]    -- toto je dlzka vysledneho Polyu
    ]
    where -- definicia lokalnej fcie
    koef i p | i < length p    = p!!i
         | otherwise    = 0

