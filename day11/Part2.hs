module Part1 where

main = do
  grid <- readData
  let (count, grid') = update grid 0
  print grid'
  print $ occupiedCount grid'

readData = do
  txt <- readFile "sample.txt"
  return $ lines txt

update grid n =
  let (w, h) = getDimensions grid
      grid' = [[updateSeat grid i j | i <- [0..(w-1)]] | j <- [0..(h-1)]]
  in
      if grid == grid' then
        (n+1, grid')
      else
        update grid' (n+1)

updateSeat grid i j =
  case grid !! j !! i of
    '.' -> '.'
    'L' -> if visibleOccupied grid i j == 0 then '#' else 'L'
    _   -> if visibleOccupied grid i j >= 5 then 'L' else '#'

visibleOccupied grid i j =
  let (w, h) = getDimensions grid
      directions = [(x,y) | x <- [-1, 0, 1], y <- [-1, 0, 1], (x,y) /= (0,0)]
      seen = map (\(i,j) -> grid !! j !! i) $
        concatMap (\(x,y) ->
          take 1 $
          dropWhile (\(i', j') -> grid !! j' !! i' == '.') $
          takeWhile (\(i',j') -> i' >= 0 && i' < w && j' >= 0 && j' < h) $
          tail $ iterate (\(i',j') -> (i'+x, j'+y)) (i, j)
        ) directions
  in
    length $ filter (=='#') seen

getDimensions grid = (length (head grid), length grid)

occupiedCount :: [String] -> Int
occupiedCount = length . filter (=='#') . concat

getVisibleCoords i j w h =
  [(x,y) | x <- [i-1, i, i+1],
           y <- [j-1, j, j+1],
           x >= 0, x < w, y >= 0, y < h,
           not (x == i && y == j)]
