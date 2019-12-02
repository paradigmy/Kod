import Data.List
import Data.Bits
-- .|. je bitové OR
-- .&. je bitové AND
-- shift x 5 je x << 5
-- shift x (-3) je x >> 3

type Alergeny = Int   -- existuje 7 alergenov, ich bity sú 1,2,4,8,16,32,64, takže 9 = (1001) sú alergény 1 a 8
type Jedlo  = (String, Alergeny)
polievky    :: [Jedlo]
polievky    = [("sosovicova",32+4+1), ("pomodoro",8+2+1), ("pohankova",0), ("hokajdo",16+2), ("gulasovka",8+4+2), ("drzkova",32+2+1), ("brokolicova",64+16+1)]

hlavne      :: [Jedlo]
hlavne      = [("spagety",16+8+4), ("pizza",2+1), ("gulas",32+8+4+2), ("hambac",1+2+4+8+16+32+64), ("dukatove",8+4+1), ("perkelt",32+1), ("ratatoille",16+2)]

{-
polievky    :: [Jedlo]
polievky    = [("sosovicova",32+1), ("pomodoro",8+2+1), ("pohankova",0), ("hokajdo",16+2), ("gulasovka",8+2), ("drzkova",32+2+1), ("brokolicova",64+1)]

hlavne      :: [Jedlo]
hlavne      = [("spagety",16+8+4), ("pizza",2+1), ("gulas",8+2), ("hambac",1+4+32), ("dukatove",8+4+1), ("perkelt",32+1), ("ratatoille",16+2)]
-}

type Menu = (Jedlo, Jedlo)

pocetAlergenov :: Menu -> Int
pocetAlergenov ((p,pa),(h,ha)) = sum [ shift (pa .|. ha) (-a) .&. 1 | a <- [0..7]] 

-- pocetAlergenov (("sosovicova",32+4+1),("spagety",16+8+4)) == 5 lebo 1,4,8,16,32
-- pocetAlergenov (("pohankova",0),("hambac",1+2+4+8+16+32+64)) == 7 lebo hambáč prebije všetko

-- Zo zoznamu polievok a hlavných chodov vytvorte všetky dvojice typu Menu, ktoré sú akceptovateľné pre osobu citlivú na alergény
jedla :: [Jedlo] -> [Jedlo] -> Alergeny -> [Menu]
jedla polievky hlavne alergeny = [ (p,h) | p@(_,pa)<-polievky, pa .&. alergeny == 0, h@(_,ha)<-hlavne, ha .&. alergeny == 0]

{-
length $ jedla polievky hlavne 0 == 49
length $ jedla polievky hlavne (1+2+4) == 0
length $ jedla polievky hlavne (1+2) == 1
length $ jedla polievky hlavne (1) == 9
-}

-- Vytvorte všetky možné týždenné jedálne lístky, bez ohľadu na alergény, ale s podmienkou, že sa neopakuje žiadna polievka ani hlavné jedlo za celý týždeň

type Listok = [Menu]   -- jedálny listok
tyzdenny :: [Listok]
tyzdenny = alls 5 polievky hlavne
            where
            alls :: Int -> [Jedlo] -> [Jedlo] -> [Listok]
            alls 0 _ _ = [[]]
            alls n polievky hlavne = [ (p,h):l |  (p,h)<-jedla polievky hlavne 0, l <- alls (n-1) (polievky\\[p]) (hlavne\\[h]) ]
-- length tyzdenny == 6350400
-- (0.35 secs, 64,784 bytes)

-- iné riešenie
tyzdenny' :: [Listok]
tyzdenny' = listok 5
            where
            listok :: Int -> [Listok]
            listok 0 = [[]]
            listok n = [ j:l | l<-listok (n-1), j<-vsetkyJedla, neopakujeSa j l ]
                        where 
                        vsetkyJedla = jedla polievky hlavne 0
                        --
                        neopakujeSa :: Menu -> Listok -> Bool
                        neopakujeSa (p,h) l = not $ any (\(x,y) -> fst p == fst x || fst h == fst y) l
-- length tyzdenny' == 6350400
-- (119.27 secs, 46,596,309,792 bytes)

