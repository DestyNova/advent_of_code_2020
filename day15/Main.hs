module Main where

import Debug.Trace
import Data.Map (Map)
import qualified Data.Map as Map

main = do
  -- let ns = [0,3,6]
  let ns = [16,12,1,0,15,7,11]
  print ns
  print $ run 30000000 ns
  -- print $ run 2020 ns

run :: Int -> [Int] -> Int
run steps ns =
  let
      start = init ns
      x = last ns
      m = Map.fromList (zip start [1..])
  in (run' x (length ns + 1) steps m)

run' :: Int -> Int -> Int -> Map Int Int -> Int
run' x i steps m
                 | i > steps = x
                 | otherwise =
  case Map.lookup x m of
    Nothing ->
      run' 0 (i+1) steps (Map.insert x (i-1) m) 

    Just j ->
      let x' = i - 1 - j
      in run' x' (i+1) steps (Map.insert x (i-1) m) 
