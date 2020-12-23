module Main where

import Debug.Trace
import Data.List (elemIndex, (\\))

main = do
  let cups = map (read . (:[])) "318946572" -- "389125467"
  let xs = play (head cups) cups [] 100
  putStrLn $ concatMap show xs

play c cups _ moves | moves == 0 = getCupsAfter cups 1
                    | otherwise =
  let bigCups = cups ++ cups
      (Just i) = elemIndex c cups
      cl = length cups
      takeOut = [cups !! x | x <- map (`mod` length cups) [i+1,i+2,i+3]]
      rest = cups \\ takeOut
      dest = case [d | d <- rest, d < c] of
                  [] -> maximum $ filter (>c) rest
                  xs -> maximum xs
      (a,_:b) = span (/=dest) rest
      cups' = a ++ [dest] ++ takeOut ++ b
      c' = head $ getCupsAfter cups' c
      in play c' cups' takeOut (moves-1)

getCupsAfter cups x =
  take (length cups - 1) (tail $ dropWhile (/=x) (cups ++ cups))
