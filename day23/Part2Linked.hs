module Main where

import Debug.Trace
import Data.List (elemIndex, (\\), sortBy)
import qualified Data.IntMap.Strict as IntMap
import Data.IntMap.Strict (IntMap, (!))

main = do
  let cups = map (read . (:[])) "318946572"
  -- let cups = map (read . (:[])) "389125467"
  let cups' = cups ++ [(length cups + 1)..1000000]
  let xs = run 10000000 cups'
  print xs

run steps cups =
  let mv = IntMap.insert (last cups) (head cups) $ IntMap.fromList (zip cups (tail cups))
      in play (head cups) mv (length cups) steps (take 3 $ sortBy (flip compare) cups)

play :: Int -> IntMap Int -> Int -> Int -> [Int] -> (Int,Int)
play c cupVals cl moves m | moves == 0 = getResult cupVals cl
                          | otherwise =
  let h1 = cupVals ! c
      h2 = cupVals ! h1
      h3 = cupVals ! h2
      hs = [h1,h2,h3]
      skip = if (c-1) `elem` hs
                then if (c-2) `elem` hs
                    then if (c-3) `elem` hs
                          then 4
                            else 3
                    else 2
              else 1
      dest = if c - skip < 1
                then maximum (m \\ hs)
                else c - skip

      cNext = cupVals ! h3
      dNext = h1
      h3Next = cupVals ! dest

      cupVals' = IntMap.insert c cNext $
                 IntMap.insert dest dNext $
                 IntMap.insert h3 h3Next cupVals
      in play cNext cupVals' cl (moves-1) m

getResult :: IntMap Int -> Int -> (Int,Int)
getResult vals cl =
  let a = vals ! 1
      b = vals ! a
      in (a,b)
