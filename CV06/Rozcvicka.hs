parNepar :: [Int] -> Int
parNepar xs = (sum (filter even xs)) - (sum (filter odd xs))

sudeLiche :: [Int] -> Int
sudeLiche xs = sum [ xs!!i * (-1)^i | i <- [0..length xs-1] ]
