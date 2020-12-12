module Main where

main = do
  rs <- readFile "input.txt"
  let ds = grok <$> lines rs
  let (x,y) = walk ds
  print (x, y, abs x + abs y)

grok (dir:n) = (dir, read n)
grok [] = ('F', 0)

data Dir = N | E | S | W deriving (Show, Eq)

walk ds = walk' ds 0 0 10 1

-- x,y = ship position, i,j = waypoint position
walk' [] x y i j = (x,y)
walk' ((d, n):ds) x y i j =
  let (x', y', i', j') = case d of
                         'F' -> (x+n*i, y+n*j, i, j)

                         'N' -> (x, y, i  , j+n)
                         'E' -> (x, y, i+n, j  )
                         'S' -> (x, y, i  , j-n)
                         'W' -> (x, y, i-n, j  )

                         _ -> let (rotatedI, rotatedJ) = turn i j d n
                                   in (x, y, rotatedI, rotatedJ)

  in walk' ds x' y' i' j'

turn i j dir angle =
  let steps = ((angle `div` 90) * (if dir == 'L' then (-1) else 1) + 4) `mod` 4
  in
      case steps of
        1 -> (j, -i)
        2 -> (-i, -j)
        3 -> (-j, i)
