module Main where

main = do
  txt <- readFile "input.txt"
  let nums = read <$> lines txt
  let bad = snd $ findBad nums 25
  let (lo,hi) = findContiguous nums bad
  print (bad, lo, hi, lo+hi)

findBad nums preamble =
  let bad = map (findBad' (reverse nums) preamble) [0..length nums - 1]
  in head $ dropWhile (not . fst) $ drop preamble $ reverse bad

findBad' :: [Int] -> Int -> Int -> (Bool, Int)
findBad' nums preamble i =
  let window = take (preamble + 1) $ drop i nums
      n = head window
      s = tail window
  in
      (all (\x -> x == n || abs (x - n) `notElem` s) window, n)

findContiguous nums bad =
  findContiguous' nums bad 0 1

findContiguous' nums bad lo hi =
  let w = take (hi-lo) $ drop lo nums
      x = sum w
  in
      if x == bad then
        (minimum w, maximum w)
      else if x > bad then
        findContiguous' nums bad (lo+1) hi
      else
        findContiguous' nums bad lo (hi+1)
