module Main where

import Text.Parsec
import Data.List (nub, transpose)
import Data.Map (Map)
import qualified Data.Map as Map

data Side = N | E | S | W deriving (Show, Eq)
data Flip = None | H | V | HV deriving (Show, Eq)

main = do
  rs <- readFile "input.txt"
  let (Right (gridMap, photos)) = parse photosParser "" rs
  putStrLn "Photos:"
  print photos
  let corners = getCorners photos
  let corner = fst $ (!! 2) $ Map.toList corners
  putStrLn $ "Corners: " ++ show corners
  putStrLn $ "Corner: " ++ show corner
  let m = reverse $ assembleRows (corner,N,V) [] photos gridMap []
  putStrLn "Grid ids:"
  print m

  putStrLn "Trimmed grid:"
  let grid = concatMap (`combineGrids` gridMap) m
  putStrLn $ unlines grid

  putStrLn $ unlines grid
  let hashes = length [1 | c <- concat grid, c == '#']
  let monsterCoords = concatMap (uncurry $ getMonsterCoords grid) dirs

  putStrLn $ "Choppiness: " ++ show hashes
  putStrLn $ "Without monsters: " ++ show (hashes - (15 * length monsterCoords))
  putStrLn $ "Monster coords: " ++ show monsterCoords
  print $ length monsterCoords

getMonsterCoords grid turn fl =
  let d = length grid
      monst = rotate monster turn fl
      monsterIndices = [(i,j) | j <- [0..length monst - 1], i <- [0..length (head monst) - 1], monst !! j !! i == '#']
      in [(k,l) | l <- [0..(d-1)], k <- [0..(d-1)],
                 all (\(i,j) -> i+k < d && j+l < d &&
                      grid !! (j+l) !! (i+k) == '#') monsterIndices]

dirs =
  [(N, None)
  ,(E, None)
  ,(W, None)
  ,(S, None)
  ,(N, H)
  ,(E, H)
  ,(W, H)
  ,(S, H)
  ]

combineGrids :: [(Int,Side,Flip)] -> Map Int [String] -> [String]
combineGrids [] _ = []
combineGrids ((p,o,f):ps) gridMap =
  let (Just piece) = Map.lookup p gridMap
      rotated = rotate piece o f
      snipped = transpose $ eat $ transpose $ eat rotated
      rest = combineGrids ps gridMap
      in if null rest
            then snipped
            else zipWith (++) snipped rest

eat :: [String] -> [String]
eat grid = init . tail <$> grid

assembleRows :: (Int,Side,Flip) -> [Int] -> Map Int [(Int,Side,Flip)] -> Map Int [String] -> [[(Int,Side,Flip)]] -> [[(Int,Side,Flip)]]
assembleRows corner used photos gridMap acc =
  let (row,used') = assembleRow [corner] used photos gridMap
      (below,used'') = getPieceBelow (last row) used' photos gridMap
      in case below of
              Nothing -> row:acc
              (Just (bp,o,f)) ->
                let (Just botPiece) = Map.lookup bp gridMap
                    rotatedBot = rotate botPiece o f
                    in assembleRows (bp,o,f) used'' photos gridMap (row:acc)

getPieceBelow (p,o,f) used photos gridMap =
  let (Just piece) = Map.lookup p gridMap
      rotatedPiece = rotate piece o f
      bottom = bin2dec (last rotatedPiece)
      (Just neighbour) = Map.lookup bottom photos
         in case filter (\(a,_,_) -> a `notElem` (p:used)) neighbour of
           [] -> (Nothing,used)
           [(p',o',f')] -> (Just (p',o',f'),p':used)

assembleRow row@((p,o,f):xs) used photos gridMap =
  let (Just piece) = Map.lookup p gridMap
      rotatedPiece = rotate piece o f
      left' = bin2dec (head $ transpose rotatedPiece)
      left = if left' > 8888 then error ("Left of " ++ show p ++ ": " ++ show left') else left'
      (Just neighbour) = Map.lookup left photos
         in case filter (\(a,_,_) -> a `notElem` (p:used)) neighbour of
           [] -> (row,used)
           [(p',o',f')] -> assembleRow ((p',derotate o' 1,f'):row) (p':used) photos gridMap

derotate E 1 = N
derotate S 1 = E
derotate W 1 = S
derotate N 1 = W

rotate :: [String] -> Side -> Flip -> [String]
rotate piece d H = rotate (map reverse piece) d None
rotate piece d V = rotate (reverse piece) d None
rotate piece d HV = reverse $ rotate (map reverse piece) d None
rotate piece N _ = piece
rotate piece E _ = reverse $ transpose piece
rotate piece S _ = reverse $ map reverse piece
rotate piece W _ = map reverse $ transpose piece

getCorners photos =
  let connections =
        Map.fromListWith (\a b -> nub (a ++ b)) $
        concat ((\xs -> (\(p,_,_) -> (p, (\(a,_,_) -> a) <$> xs)) <$> xs) . snd <$> Map.toList photos)
      lengths = Map.map length connections
  in Map.filter (==3) lengths

photosParser :: Parsec String () (Map Int [String], Map Int [(Int, Side, Flip)])
photosParser = do
  ps <- sepEndBy (
          do
            string "Tile "
            photoId <- try $ many1 digit
            let pid = read photoId
            string ":\n"

            grid <- sepEndBy1 (count 10 $ char '#' <|> char '.') (char '\n')
            let grid' = transpose grid

            let top = bin2dec (head grid)
            let topH = bin2dec (reverse $ head grid)
            let bottomH = bin2dec (last grid)
            let bottom  = bin2dec (reverse $ last grid)

            let leftV = bin2dec (head grid')
            let left  = bin2dec (reverse $ head grid')
            let right = bin2dec (last grid')
            let rightV = bin2dec (reverse $ last grid')

            let facts =
                  ((pid, grid)
                   ,[(top, (pid, N, None))
                    ,(topH, (pid, N, H))
                    ,(right, (pid, E, None))
                    ,(rightV, (pid, E, V))
                    ,(bottom, (pid, S, None))
                    ,(bottomH, (pid, S, H))
                    ,(left, (pid, W, None))
                    ,(leftV, (pid, W, V))])
            return facts
           ) (string "\n")
  let gridMap = Map.fromList $ map fst ps
  let edgeMap = Map.fromListWith (++) $ map (\(code, tx) -> (code, [tx])) $ concatMap snd ps
  return (gridMap, edgeMap)

bin2dec :: String -> Int
bin2dec s = rec '#' '.' s 0
  where rec hi lo "" total = total
        rec hi lo (c:cs) total = rec hi lo cs (2*total + if c == hi then 1 else 0)

monster = lines "                  # \n#    ##    ##    ###\n #  #  #  #  #  #   "
