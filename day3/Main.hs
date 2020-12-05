module Main where

main = do
  txt <- readFile "input.txt"
  let rs = lines txt
  let slopes = [(1,1), (3,1), (5,1), (7,1), (1,2)]
  print $ product $ map (uncurry (countTrees rs)) slopes

isTree rs x y = (rs !! y) !! (x `mod` length (head rs)) == '#'

countTrees rs w h = length $
                    filter (uncurry (isTree rs)) $
                    takeWhile ((< length rs) . snd) $
                    iterate (\(x,y) -> (x+w, y+h)) (0,0)
