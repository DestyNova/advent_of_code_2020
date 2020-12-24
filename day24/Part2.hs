module Main where

import Text.Parsec
import Data.Map (Map)
import qualified Data.Map as Map

main = do
  rs <- readFile "input.txt"
  let (Right tiles) = parse tilesParser "" rs
  let odds = Map.filter odd tiles
  let n = runDays 100 odds
  print n

runDays n tiles | n == 0 = Map.size $ Map.filter odd tiles
                | otherwise =
  let expandedMap = expandMap tiles
  in runDays (n-1) (Map.mapWithKey (updateNearby expandedMap) expandedMap)

updateNearby :: Map (Int,Int) Int -> (Int,Int) -> Int -> Int
updateNearby tiles (x,y) side
  | odd side = if nearbyBlack == 0 || nearbyBlack > 2 then 0 else 1
  | otherwise = if nearbyBlack == 2 then 1 else 0
    where
      nearbyBlack = length $ filter odd nearby
      nearby = map (\c -> Map.findWithDefault 0 c tiles) neighbours
      neighbours = getNeighbours x y

getNeighbours x y = map (\(a,b) -> (x+a,y+b)) [(1,0),(0,1),(-1,1),(-1,0),(0,-1),(1,-1)]

expandMap tiles =
  let more = Map.fromList (concatMap (\(x,y) -> [(c,0) | c <- getNeighbours x y]) (Map.keys tiles))
      in Map.unionWith (+) more tiles

tilesParser :: Parsec String () (Map (Int,Int) Int)
tilesParser = do
  ps <- sepEndBy (
          do
            dirs <- many1 (choice $ map (try . string) ["e","se","sw","w","nw","ne"])
            return $ head $ buildPath dirs
           ) (string "\n")
  return $ Map.fromListWith (+) $ map (\pos -> (pos, 1)) ps

buildPath = foldl (\tiles@((x,y):_) d -> case d of
                                                   "e" -> (x+1,y)
                                                   "w" -> (x-1,y)
                                                   "ne" -> (x+1,y-1)
                                                   "nw" -> (x,y-1)
                                                   "se" -> (x,y+1)
                                                   "sw" -> (x-1,y+1)
                                              : tiles) [(0,0)]
