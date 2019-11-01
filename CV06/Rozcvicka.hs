parNepar :: [Int] -> Int
parNepar xs = (sum (filter even xs)) - (sum (filter odd xs))

sudeLiche :: [Int] -> Int
sudeLiche xs = sum [ xs!!i * (-1)^i | i <- [0..length xs-1] ]

sudeLiche' :: [Int] -> Int
sudeLiche' [] = 0
sudeLiche' [x] = x
sudeLiche' (x:y:xs) = x-y + sudeLiche' xs

sudeLiche'' :: [Int] -> Int
sudeLiche'' xs = sum [ xs!!i | i <- [0..length xs-1], even i ] - sum [ xs!!i | i <- [0..length xs-1], odd i ]
