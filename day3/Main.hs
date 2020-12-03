module Day3 where

main = do
  txt <- readFile "input.txt"
  let rs = lines txt
  print $ countTrees rs 3 1

isTree rs x y = (rs !! y) !! (x `mod` length (head rs)) == '#'

countTrees rs w h = length $
                    filter (uncurry (isTree rs)) $
                    takeWhile ((< length rs) . snd) $
                    iterate (\(x,y) -> (x+w, y+h)) (0,0)
