module Auto where

whereToStart :: [Float] -> [Float] -> [Int]
whereToStart dist lit = [ i | i<-[0..length zoz-1], zoz!!i == minimum zoz]
            where
                zoz = reverse $ tail $ foldl (\ys@(x:xs) -> \(dist,litre) -> (x+litre-dist) : ys)  [0] (zip dist lit)


-- to iste, akurat zoznam vytvarame tak, ze lepime vzdy na koniec
whereToStart' :: [Float] -> [Float] -> [Int]
whereToStart' dist lit = [ i | i<-[0..length zoz-1], zoz!!i == minimum zoz]
            where
                zoz = init $ foldl (\xs -> \(dist,litre) -> xs ++ [(last xs)+litre-dist])  [0] (zip dist lit)

{-
whereToStart [9,1] [1,9] = [1]
whereToStart [1,2,3,4] [2,2,2,4] = [0,3]
whereToStart [1,2,5,3,2,3,4,5,6] [1,1,2,2,3,3,4,4,11] = [4,8] -- viď priložený obrá
-}

{- Premia Autologia1
Na závodnom okruhu sa jazdí len v jednom smere. Na trati sú netradične čerpacie stanice, pumpy, v ktorých je isté množstvo benzínu. Vzdialenosti medzi pumpami sú rôzne, ale platí, že množstvo benzínu na všetkých pumpách spolu je presne také, koľko auto potrebuje na obehnutie celého okruhu. Kde (na ktorej pumpe) má auto s prázdnou nádržou natankovať a začať okruh, aby ho prešlo celý. A dá sa to vždy ? Porozmýšľajte najrpv na papieri a potom programujte.

Príklad:

    dve pumpy: na prvej je 1 liter, na prekonanie vzdialenosti k druhej treba 9 litrov, na druhej je 9 litrov a na prekonanie k prvej stačí 1 liter, 1+9=9+1. Odpoveď: začať treba na druhej pumpe.
    dve pumpy: na prvej je 9.1 litra, na prekonanie vzdialenosti k druhej treba 9 litrov, na druhej je 0.9 litrov a na prekonanie k prvej stačí 1 liter. Odpoveď: začať treba na prvej pumpe.
    dve pumpy: na prvej je 9 litrov, na prekonanie vzdialenosti k druhej treba 9 litrov, na druhej je 1 litrer a na prekonanie k prvej stačí 1 liter. Odpoveď: začať treba na niektorej z nich, úspech nastane v oboch prípadoch.

Hint: auto nemá nádrž neohraničenej veľkosti a pochopiteľne, na každej pumpe, kam dorazí, natankuje všetok benzínu, čo pompa ponúka.

Vstupom do funkcie sú dva rovnako dlhé vektory typy [Float], prvý (distances) nich hovorí koľko litrov treba na prejdenie od prvej k druhej, od druhej k treteje, ..., od poslednej k prvej pumpe. Druhy vektor (liters) hovorí, koľko litrov je na ktorej pumpe. Podmienka príkladu sum distances == sum liters && length distances == length liters.

V súbore Auto.hs definujte modul Auto , ktorý definujte funkciu whereToStart :: [Float] -> [Float] -> [Int], ktorá pre volanie whereToStares distances liters vráti zoznam púmp, kde auto môže začať, a pritom obehne celú trať. Indexy púmp sú 0..length liters-1. Ak taká pumpa neexistuje, tak vráti prázdny zoznam možností.

module Auto where

whereToStart :: [Float] -> [Float] -> [Int]
whereToStart dist lit = undefined  -- toto dopíšte
-}