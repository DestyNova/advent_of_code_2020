module Main where

main = do
  let steps = 6
  grid <- expandGrid steps <$> readData
  printG grid
  -- print $ map (\(x,y,z) -> nearbyActive grid x y z) [(2,2,1)]
  let grid' = update grid 6
  printG grid'
  print $ occupiedCount grid'

printG :: [[String]] -> IO ()
printG grid =
  mapM_ (\i -> do
        putStrLn $ "Layer " ++ show i
        putStrLn $ unlines $ grid !! i) [0..length grid-1]

expandGrid steps grid = let g = length grid
                            d = g + 2 * steps
                            g' =
                              [[[c | i <- [0..(d-1)], let c = copyFromSmallGrid i j k]
                              | j <- [0..(d-1)]] | k <- [0..(d-1)]]

                            copyFromSmallGrid x y z =
                              if inGridRange x' y' z
                                 then grid !! y' !! x'
                                 else '.'
                              where
                                x' = x - offset
                                y' = y - offset
                                offset = (d - g) `div` 2
                                inGridRange i j k = k == offset && i >= 0 && j >= 0 &&
                                                    i < g && j < g

                            in g'
readData = do
  txt <- readFile "input.txt"
  return $ lines txt

update grid n | n == 0 = grid
              | otherwise =

  let d = length grid + 0 -- need to increase later maybe
      grid' = [[[updateCube grid i j k | i <- [0..(d-1)]] | j <- [0..(d-1)]] | k <- [0..(d-1)]]
      in
        update grid' (n-1)

updateCube grid x y z =
  let activeNeighbours = nearbyActive grid x y z
  in
    case grid !! z !! y !! x of
        '.' -> if activeNeighbours == 3 then '#' else '.'
        '#' -> if activeNeighbours == 2 || activeNeighbours == 3 then '#' else '.'
        _   -> '?'

nearbyActive grid i j k =
  let d = length grid
      coords = getAdjacentCoords i j k d
  in
    length [1 | (x,y,z) <- coords, grid !! z !! y !! x == '#']

getDimensions grid = (length (head grid), length grid)

occupiedCount :: [[String]] -> Int
occupiedCount = length . filter (=='#') . concat . concat

getAdjacentCoords i j k d =
  [(x,y,z) | x <- [i-1, i, i+1],
             y <- [j-1, j, j+1],
             z <- [k-1, k, k+1],
             x >= 0, x < d,
             y >= 0, y < d,
             z >= 0, z < d,
             not (x == i && y == j && z == k)]
