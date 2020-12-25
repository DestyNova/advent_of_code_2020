module Main where

import Debug.Trace
import Data.List (nub)

main = do
  [n1,n2] <- map read . lines <$> readFile "input.txt"
  print (n1,n2,n1+n2)
  let cc = pohlig 7 n1 20201227
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

transform x ls = (x^ls) `mod` 20201227

brute a b p qe | trace ("brute: " ++ show (a,b,p,qe)) False = undefined
               | otherwise =
  head $ filter (\x -> a^x `mod` p == b `mod` p) [0..qe]

pohlig :: Integer -> Integer -> Integer -> Integer
pohlig g h p | trace ("Pohlig: " ++ show (g,h,p)) False = undefined
             | otherwise =
  let fs = factors (p-1)
      qe = map (\x -> (x, toInteger $ length [1 | y <- fs, y==x])) $ nub fs
      rs = map (\(q,e) ->
                brute (g^((p-1) `div` q^e) `mod` p) (h^((p-1) `div` q^e) `mod` p) p (q^e)) qe
      cs = zip (map (uncurry (^)) qe) rs
  in crt cs

euclid 0 b = (b, 0, 1)
euclid a b = (g, t - (b `div` a) * s, s)
    where (g, s, t) = euclid (b `mod` a) a
inv a m = let (_, i, _) = euclid a m in i `mod` m

crt ns | trace ("crt: " ++ show ns) False = undefined
       | otherwise =
  sum yokes `mod` prod
  where prod = product xs
        xs = map fst ns
        yokes = zipWith3 (\a b c -> a*b*c) rems pps invs
        rems = map snd ns
        pps = map (prod `div`) xs
        invs = zipWith inv pps xs
