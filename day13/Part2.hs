module Main where

import Data.List (elemIndex)
import Text.Parsec

main = do
  rs <- lines <$> readFile "input2.txt"
  let ps = parse busParser "" <$> rs
  let routes = head [route | (Right route) <- ps]
  let offsets = filter (\(r, i) -> r /= 0) (zip routes [0..])
  print offsets
  print $ crt [(x, negate i) | (x, i) <- offsets]

busParser :: Parsec String () [Int]
busParser =
  sepBy (do
          n <- try (many1 digit) <|> try (string "x")
          let x = case n of
                    "x" -> 0
                    _ -> read n
          return x
        ) $ char ','

-- algorithmic description of Chinese remainder theorem found here:
-- https://www.geeksforgeeks.org/chinese-remainder-theorem-set-2-implementation
crt ns = sum yokes `mod` prod
  where prod = product xs
        xs = map fst ns
        yokes = zipWith3 (\a b c -> a*b*c) rems pps invs
        rems = map snd ns
        pps = map (prod `div`) xs
        invs = zipWith inv pps xs

-- Euclid's extended algorithm "inspired by":
-- https://stackoverflow.com/a/35529381/2161072
-- It also provides a more elegant solution to the CRT, but I didn't want
-- to steal the entire thing.
euclid 0 b = (b, 0, 1)
euclid a b = (g, t - (b `div` a) * s, s)
    where (g, s, t) = euclid (b `mod` a) a
inv a m = let (_, i, _) = euclid a m in i `mod` m

-- Notes, trying to figure out the relationship for two consecutive values:
-- f 67 7 = 335
-- f 67 9 = 134
-- f 3 5 = 9
-- f 3 7 = 6
-- f 5 7 = 20
-- f 5 9 = 35
-- f 7 13 = 77
-- f 5 13 = 25
-- Chinese remainder?
-- find n | n mod 3 == 0 && (n+1) mod 5 == 0
--                          ^ equivalent to n mod 5 = (5-1)
-- generally: find n | n mod a == 0 && n mod b == (b-b_gap) ...
-- ... ∑ (rem[i]*pp[i]*inv[i]) ) % prod
