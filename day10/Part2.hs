module Part1 where

import Data.List (nub, sort)

main = do
  txt <- readFile "input.txt"
  let nums = read <$> lines txt
  print $ 0 : sort nums ++ [maximum nums + 3]
  print $ jolts nums


jolts nums = let xs = 0 : sort nums ++ [maximum nums + 3]
             in
                 product $ combos xs

combos (a:b:c:d:e:xs) | e-a == 4 = 7 : combos (d:e:xs)
                      | otherwise = ca : combos (b:c:d:e:xs)
                      where ca = if c-a <= 3 then 2 else 1
                            db = if d-b <= 3 then 2 else 1
combos _ = [1]
