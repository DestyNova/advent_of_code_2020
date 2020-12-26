module Main where

import Debug.Trace
import Data.List (nub)

main = do
  [n1,n2] <- map read . lines <$> readFile "input.txt"
  print (n1,n2,n1+n2)
  let cc = bruteForce 7 n1 20201227
  putStrLn ("Card loop size: " ++ show cc)
  putStrLn ("Encryption key: " ++ show (transform n2 cc))

factors :: Integer -> [Integer]
factors n = reverse $ factors' n 2 []

factors' n f acc | f*f > n = if n /= 1 then (n:acc) else acc
                 | otherwise =
  if n `mod` f == 0
     then factors' (n `div` f) f (f:acc)
     else factors' n f' acc

  where f' = if f == 2 then 3 else f+2

transform x ls = modExp x ls 20201227

bruteForce a b p | trace ("brute: " ++ show (a,b,p)) False = undefined
               | otherwise =
  head $ filter (\x -> modExp a x p == b `mod` p) [0..p]

modExp b e m = modExp' b e m (if odd e then b else 1)

modExp' b e m r | e == 0 = r
                | otherwise =
  let e' = e `div` 2
      b' = (b*b) `mod` m
      r' = if odd e' then (r*b') `mod` m else r
      in modExp' b' e' m r'
