module Main where

import Data.Map (Map)
import qualified Data.Map as Map

main = do
  [n1,n2] <- map read . lines <$> readFile "input.txt"
  print (n1,n2,n1+n2)
  print $ solve n1 n2

-- When I realised the brute force method wasn't going to work on the
-- real input data, I cheated at this point and used an online discrete
-- log calculator. A fitting end to the 25 days!
--
-- Seriously though, the calculator (https://www.alpertron.com.ar/DILOG.HTM)
-- uses the Pohlig-Hellmann algorithm, so I'll figure out how that works
-- and reimplement it here for completeness.
solve a b =
  let cc = brute a -- didn't complete, but should be 9374311
      cd = brute b -- ditto, 16650209
  in transform cc b

transform ls x = x^ls `mod` 20201227

-- This can solve the sample problem but not the real one which uses
-- a much larger loop size (x)
brute a =
  head $ filter (\x -> 7^x `mod` 20201227 == a) [1..]

pohlig n g md =
  0

euclid 0 b = (b, 0, 1)
euclid a b = (g, t - (b `div` a) * s, s)
    where (g, s, t) = euclid (b `mod` a) a
inv a m = let (_, i, _) = euclid a m in i `mod` m

-- loop size x
-- subject number n
-- pub = n^x mod 20201227
-- enc = pub^x mod 20201227
-- enc = pub2^x mod 20201227
-- pub^x mod 20201227 == pub2^x mod 20201227
