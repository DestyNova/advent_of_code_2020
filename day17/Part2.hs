module Main where

main = do
  let steps = 6
  grid <- expandGrid steps <$> readData
  printG grid
  let grid' = update grid steps
  putStrLn "grid':"
  print $ occupiedCount grid'

printG :: [[[String]]] -> IO ()
printG grid =
  mapM_ (\l -> do
        putStrLn $ "w = " ++ show l
        mapM_ (\k -> do
              putStrLn $ "z = " ++ show k
              putStrLn $ unlines $ grid !! l !! k) [a + (length grid `div` 2) | a <- [-1, 0, 1]]
        ) [a + (length grid `div` 2) | a <- [-1, 0, 1]]

expandGrid steps grid = let g = length grid
                            d = g + 2 * steps
                            g' =
                              [[[[c | i <- [0..(d-1)], let c = copyFromSmallGrid i j k l]
                              | j <- [0..(d-1)]] | k <- [0..(d-1)]] | l <- [0..(d-1)]]

                            copyFromSmallGrid x y z w =
                              if inGridRange x' y' z w
                                 then grid !! y' !! x'
                                 else '.'
                              where
                                x' = x - offset
                                y' = y - offset
                                offset = (d - g) `div` 2
                                inGridRange i j k l = k == d `div` 2 && l == d `div` 2 &&
                                                      i >= 0 && j >= 0 &&
                                                      i < g && j < g

                            in g'
readData = do
  txt <- readFile "input.txt"
  return $ lines txt

update grid n | n == 0 = grid
              | otherwise =

  let d = length grid
      grid' = [[[[updateCube grid i j k l | i <- [0..(d-1)]] | j <- [0..(d-1)]] | k <- [0..(d-1)]] | l <- [0..(d-1)]]
      in
        update grid' (n-1)

updateCube grid x y z w =
  let activeNeighbours = nearbyActive grid x y z w
  in
    case grid !! w !! z !! y !! x of
        '.' -> if activeNeighbours == 3 then '#' else '.'
        '#' -> if activeNeighbours == 2 || activeNeighbours == 3 then '#' else '.'
        _   -> '?'

nearbyActive grid i j k l =
  let d = length grid
      coords = getAdjacentCoords i j k l d
  in
    length [1 | (x,y,z,w) <- coords, grid !! w !! z !! y !! x == '#']

occupiedCount :: [[[String]]] -> Int
occupiedCount = length . filter (=='#') . concat . concat . concat

getAdjacentCoords i j k l d =
  [(x,y,z,w) | x <- [i-1, i, i+1],
               y <- [j-1, j, j+1],
               z <- [k-1, k, k+1],
               w <- [l-1, l, l+1],
               x >= 0, x < d,
               y >= 0, y < d,
               z >= 0, z < d,
               w >= 0, w < d,
               not (x == i && y == j && z == k && w == l)]
