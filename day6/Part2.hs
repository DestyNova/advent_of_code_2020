module Part2 where

import Data.Char (isAlpha)
import Data.List (intersect)

main = do
  txt <- readFile "input.txt"
  let ps = splitGroups txt
  print $ sum $ map (length . foldl1 intersect . lines) ps

splitGroups s = reverse $ rec s "" []
  where rec "" ps acc = reverse ps : acc
        rec ('\n':'\n':rest) ps acc = rec rest "" (reverse ps : acc)
        rec (x:rest) ps acc = rec rest (x:ps) acc
