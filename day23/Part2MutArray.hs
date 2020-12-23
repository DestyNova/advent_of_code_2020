module Main where

import Data.List ((\\), sortBy)
import Control.Monad.ST
import Data.Array.ST

main = do
  let cups = map (read . (:[])) "318946572"
  -- let cups = map (read . (:[])) "389125467"
  let cups' = cups ++ [(length cups + 1)..1000000]
  let xs = runST $ run 10000000 cups'
  print xs

run :: Int -> [Int] -> ST s (Int, Int)
run steps cups = do
  arr <- newArray (1,length cups) (-1)
  mapM_ (uncurry $ writeArray arr) ((last cups, head cups) : zip cups (tail cups))
  play (head cups) arr (length cups) steps (take 3 $ sortBy (flip compare) cups)

play :: Int -> STUArray s Int Int -> Int -> Int -> [Int] -> ST s (Int,Int)
play c cups cl moves m | moves == 0 = getResult cups cl
                       | otherwise = do
  h1 <- readArray cups c
  h2 <- readArray cups h1
  h3 <- readArray cups h2
  let hs = [h1,h2,h3]
  let skip = if (c-1) `elem` hs
                then if (c-2) `elem` hs
                    then if (c-3) `elem` hs
                          then 4
                            else 3
                    else 2
              else 1
  let dest = if c - skip < 1
                then if null (m \\ hs) then error ("WAT: " ++ show (m,hs,10000-moves,c)) else maximum (m \\ hs)
                else c - skip

  let dNext = h1
  cNext <- readArray cups h3
  h3Next <- readArray cups dest

  writeArray cups c cNext
  writeArray cups dest dNext
  writeArray cups h3 h3Next

  play cNext cups cl (moves-1) m

getResult :: STUArray s Int Int -> Int -> ST s (Int,Int)
getResult v cl = do
  a <- readArray v 1
  b <- readArray v a
  return (a,b)
