import Data.List
import Data.Map

type Card = (Char, Int)  
type Freecell = [Card]
type EndCell= Map Char Int
type Desk=[[Card]]
type Game = (EndCell, Freecell, Desk)

allowed ::Char -> [Char]
allowed c = (fromList [('C',['H','D']),('D',['C','S']),('H',['C','S']),('S',['H','D'])] ) ! c

testDesk::Desk
testDesk =[[('C', 5)], [('H', 2), ('S', 11), ('D', 11), ('H', 11), ('H', 12), ('D', 3), ('D', 10), ('D', 2), ('S', 12), ('D', 12)], [('H', 3), ('D', 8), ('C', 3), ('D', 4)], [('C', 9), ('S', 3), ('S', 13), ('H', 1), ('S', 10), ('S', 8), ('D', 5), ('H', 6), ('H', 4)], [('D', 13), ('D', 7), ('H', 5), ('D', 1), ('C', 12), ('H', 7), ('C', 4), ('C', 11), ('S', 7), ('S', 9)], [('C', 10), ('C', 1)], [('C', 6), ('S', 2), ('C', 2), ('S', 5), ('D', 9), ('H', 8), ('S', 1), ('C', 8), ('H', 13), ('H', 10)], [('H', 9), ('S', 4), ('C', 13), ('D', 6), ('S', 6), ('C', 7)]]

testGame::Game
testGame = (fromList [('C',0),('H',0),('D',0),('S',0)],[], testDesk)

testDeskMini=[[('C',1),('C',2)],[('C',3),('D',1)],[('D',2),('D',3)],[('H',1),('H',2)],[('H',3)],[('S',1)],[('S',2)],[('S',3)],[]]
testGameMini::Game
testGameMini=(fromList [('C',0),('H',0),('D',0),('S',0)],[], testDeskMini)

colToFree::Game -> [Game]
colToFree (endCell, freeCell, desk) 
   | length freeCell == 4 = []
   | otherwise = [ (endCell, i:freeCell, [ if j == i:is then is else j | j <- desk]) | i:is <- desk ]

-- second on top of the first
testPair::Card -> Card -> Bool
testPair (a, aval) (b, bval) = a `elem` (allowed b) && bval + 1 == aval 

freeToCol::Game -> [Game]
freeToCol (endCell, freeCell, desk)
   | length freeCell == 0 = []
   | otherwise =  [ (endCell, Data.List.delete i freeCell, [ if j == c:col then i:j else j | j <- desk ] ) | i <- freeCell, c:col <- desk, testPair c i] 
               ++ [ (endCell, Data.List.delete i freeCell, [ if j == c then i:j else j | j <- desk ] ) | i <- freeCell, c <- desk, c == []] 

freeToEnd::Game -> [Game]
freeToEnd (endCell, freeCell, desk)
   | length freeCell == 0 = []
   | otherwise = [ (Data.Map.insert i ival endCell, Data.List.delete (i, ival) freeCell, desk) | (i, ival) <- freeCell, (endCell ! i) + 1 == ival ]

colToCol::Game -> [Game]
colToCol (endCell, freeCell, desk) =   [ (endCell, freeCell, [ if k == i:ci then j:k else (if k == j:cj then cj else k) | k <- desk]) | i:ci <- desk, j:cj <- desk, ci /= cj && testPair i j] 
                                    ++ [ (endCell, freeCell, [ if k == i then j:k else (if k == j:cj then cj else k) | k <- desk]) | i <- desk, j:cj <- desk, i /= cj && i == [] ]

isOver::Game -> Bool
isOver (endCell, freeCell, desk) = freeCell == [] && (and [ i == [] | i <- desk])

solve ::  [Game] -> [[Game]]
solve solution@(x:xs) 
   | isOver x = [solution]
   | otherwise = concat [ solve (move:solution) | move <- ((colToCol x) ++ (freeToCol x) ++ (freeToEnd x) ++ (colToFree x)), not (elem move solution) ]


main :: IO()
main =do
   -- print $  show $ allowed 'D'
   -- print $ show $ testGameMini
   -- print $  solve [testGameMini]
   -- print $ freeToCol testGameMini
   -- print $ freeToCol (head (colToFree testGameMini))
   print $ testGameMini
   print $ '\n'
   print $ head (solve [testGameMini])
