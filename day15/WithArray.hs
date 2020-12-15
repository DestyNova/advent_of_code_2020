module Main where

import Data.Map (Map)
import qualified Data.Map as Map
import Control.Monad.ST
import Data.Array.ST

main = do
  let ns = [16,12,1,0,15,7,11]
  print $ runST $ run 30000000 ns

run :: Int -> [Int] -> ST s Int
run steps ns = do
  arr <- newArray (0,steps+2) (-1)
  let start = init ns
  let x = last ns
  mapM_ (uncurry $ writeArray arr) (zip start [1..])
  run' x (length ns + 1) steps arr

run' :: Int -> Int -> Int -> STUArray s Int Int -> ST s Int
run' x i steps m
                 | i > steps = pure x
                 | otherwise = do
  j <- readArray m x
  case j of
    (-1) -> do
      writeArray m x (i-1)
      run' 0 (i+1) steps m 

    _ -> do
      writeArray m x (i-1)
      run' (i - j - 1) (i+1) steps m
