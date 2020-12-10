module Part1 where

import Data.List (sort)

main = do
  txt <- readFile "input.txt"
  let nums = (read <$> lines txt) :: [Int]
  print $ jolts nums


jolts nums = let xs = sort nums ++ [maximum nums + 3]
                 ps = zip xs (0 : xs)
                 js = map (\(a,b) -> abs (a - b)) ps
             in
                 -- (xs,ps, js)
-- TODO: 1s*3s
                 map length [filter (==1) js, filter (==2) js, filter (==3) js]
