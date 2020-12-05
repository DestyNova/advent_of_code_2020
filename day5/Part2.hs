module Part2 where

import Data.List (sort, (\\))

main = do
  ps <- readFile "input.txt"
  let seats = map decodePass $ lines ps
  let ids = [x | (x,_,_) <- seats]
  let missing = head $ [minimum ids..maximum ids] \\ ids
  putStrLn $ "Missing seat found: " ++ show missing
  putStrLn $ "Nearby seats: " ++ show (filter (\(x,_,_) -> x == missing - 1 || x == missing + 1) seats)

bin2dec :: Char -> Char -> String -> Int
bin2dec hi lo s = rec hi lo s 0
  where rec hi lo "" total = total
        rec hi lo (c:cs) total = rec hi lo cs (2*total + if c == hi then 1 else 0)

decodePass :: String -> (Int, Int, Int)
decodePass s = (row * 8 + col, row, col)
  where row = bin2dec 'B' 'F' $ take 7 s
        col = bin2dec 'R' 'L' $ drop 7 s
