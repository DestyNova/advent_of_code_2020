module Main where

import Debug.Trace
import Data.List (elemIndex, (\\), sortBy)
import Control.Monad.ST
import Data.Array.ST

main = do
  -- let cups = map (read . (:[])) "318946572"
  let cups = map (read . (:[])) "389125467"
  let cups' = cups ++ [(length cups + 1)..20]
  putStrLn "right"
  xs <- mapM (\x -> pure $ (x, runST $ run x cups')) [i | i <- [2..2000]]
  print xs
  return xs

run :: Int -> [Int] -> ST s (Int,Int)
run steps cups = do
  let cl = length cups
  arr <- newArray (0,cl) (-1) :: ST s (STUArray s Int Int)
  mapM_ (uncurry $ writeArray arr) (zip [0..] cups)
  play 0 arr cl steps (take 3 $ sortBy (flip compare) cups)

play :: Int -> STUArray s Int Int -> Int -> Int -> [Int] -> ST s (Int,Int)
-- play ci cups cl moves m | trace ("play: " ++ show (10000-moves, getResult cups cl)) False = undefined
play ci cups cl moves m | moves == 0 = getResult cups cl
                        | otherwise = do
  c <- readArray cups ci
  let holdIndices = map (\i -> (ci+i) `mod` cl) [1,2,3]
  h1 <- readArray cups (holdIndices !! 0)
  h2 <- readArray cups (holdIndices !! 1)
  h3 <- readArray cups (holdIndices !! 2)
  let hs = [h1,h2,h3]
  let skip = if (c-1) `elem` hs
                then if (c-2) `elem` hs
                       then if (c-3) `elem` hs
                              then 4
                              else 3
                       else 2
                else 1
  let dest = if c - skip < 1
                then maximum (m \\ hs)
                else c - skip
  ci' <- updateCups dest hs cups cl c ci
      -- c'' = tmp c' (take 4 $ getCupsAfter cups' 1)
  play ci' cups cl (moves-1) m

getResult cups cl = do
  i <- findArray cups 1
  a <- readArray cups ((i+1) `mod` cl)
  b <- readArray cups ((i+2) `mod` cl)
  return (a,b)

findArray :: STUArray s Int Int -> Int -> ST s Int
findArray cups n = findArray' cups n 0
-- findArray cups n = spam (findArray' cups n 0) cups [] 0

spam fa cups acc i | i == 9 && trace ("fA: " ++ show (reverse acc)) False = undefined
spam fa cups acc i = do
  if i == 9
     then fa
     else do
       x <- readArray cups i
       spam fa cups (x:acc) (i+1)

findArray' cups n i = do
  x <- readArray cups i
  if x == n
     then pure i
     else findArray' cups n (i+1)

updateCups :: Int -> [Int] -> STUArray s Int Int -> Int -> Int -> Int -> ST s Int
-- updateCups dest hs cups cl c ci | trace ("update " ++ show (dest,hs,cl,c,ci)) False = undefined
updateCups dest hs cups cl c ci = do
  -- ci' <- findArray cups dest
  -- let ci'' = if ci' == -1 then 999 else ci
  insertPoint <- shiftLeft (ci+1) dest cups cl
  let [r1,r2,r3] = map (\j -> (insertPoint + j) `mod` cl) [1,2,3]
  -- 3. write hs to subsequent 3 elements
  writeArray cups r1 (hs !! 0)
  writeArray cups r2 (hs !! 1)
  writeArray cups r3 (hs !! 2)
  return $ (ci + 1) `mod` cl

shiftLeft :: Int -> Int -> STUArray s Int Int -> Int -> ST s Int
-- shiftLeft i dest cups cl | trace ("shift: " ++ show (i,dest,cl)) False = undefined
shiftLeft i dest cups cl = do
  let j = (i+3) `mod` cl
  let i' = (i+1) `mod` cl
  y <- readArray cups j
  writeArray cups (i `mod` cl) y
  if y == dest
     then return i
     else shiftLeft i' dest cups cl
  
-- getCupsAfter cups x i =
--   take (length cups - 1) (tail $ dropWhile (/=x) (cups ++ cups))

tmp c cups | trace (show (c,cups)) False = undefined
           | otherwise = c
