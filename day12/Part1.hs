module Main where

import Data.List (elemIndex)

main = do
  rs <- readFile "input.txt"
  let ds = grok <$> lines rs
  let (x,y) = walk ds
  print (x, y, abs x + abs y)

grok (dir:n) = (dir, read n)
grok [] = ('F', 0)

data Dir = N | E | S | W deriving (Show, Eq)

walk ds = walk' ds E 0 0

walk' [] _ x y = (x,y)
walk' ((d, n):ds) dir x y =
  let (dir', x', y') = case (d, dir) of
                         ('F', N) -> (dir, x  , y+n)
                         ('F', E) -> (dir, x+n, y  )
                         ('F', S) -> (dir, x  , y-n)
                         ('F', W) -> (dir, x-n, y  )

                         ('N', _) -> (dir, x  , y+n)
                         ('E', _) -> (dir, x+n, y  )
                         ('S', _) -> (dir, x  , y-n)
                         ('W', _) -> (dir, x-n, y  )

                         (_, _) -> (turn dir d n, x, y)
  in walk' ds dir' x' y'

turn pointing dir angle =
  let steps = (angle `div` 90) * (if dir == 'L' then (-1) else 1)
      dirs = cycle [N,E,S,W]
      (Just i) = elemIndex pointing dirs
  in
      dirs !! (i+steps+4)
