module Part1 where

main = do
  ps <- readFile "input.txt"
  print $ maximum $ map decodePass $ lines ps

bin2dec :: Char -> Char -> String -> Int
bin2dec hi lo s = rec hi lo s 0
  where rec hi lo "" total = total
        rec hi lo (c:cs) total = rec hi lo cs (2*total + if c == hi then 1 else 0)

decodePass :: String -> Int
decodePass s = row * 8 + col
  where row = bin2dec 'B' 'F' $ take 7 s
        col = bin2dec 'R' 'L' $ drop 7 s
