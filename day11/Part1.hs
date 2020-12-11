module Main where

-- Warning: ridiculously slow due to list access. Should have used Data.Array.
main = do
  grid <- readData
  -- print grid
  let (count, grid') = update grid 0
  -- print grid'
  print $ occupiedCount grid'

readData = do
  txt <- readFile "input.txt"
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
    'L' -> if nearbyOccupied grid i j == 0 then '#' else 'L'
    _   -> if nearbyOccupied grid i j >= 4 then 'L' else '#'

nearbyOccupied grid i j =
  let (w, h) = getDimensions grid
      coords = getAdjacentCoords i j w h
  in
    length [1 | (x,y) <- coords, grid !! y !! x == '#']

getDimensions grid = (length (head grid), length grid)

occupiedCount :: [String] -> Int
occupiedCount grid =
  length $ filter (=='#') $ concat grid

getAdjacentCoords i j w h =
  [(x,y) | x <- [i-1, i, i+1],
           y <- [j-1, j, j+1],
           x >= 0, x < w, y >= 0, y < h,
           not (x == i && y == j)]
