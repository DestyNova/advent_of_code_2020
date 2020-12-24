module Main where

import Text.Parsec
import Data.Map (Map)
import qualified Data.Map as Map

main = do
  rs <- readFile "input.txt"
  let (Right tiles) = parse tilesParser "" rs
  let odds = Map.filter odd tiles
  print $ Map.size odds

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
                                                   "ne" -> (x+1,y+1)
                                                   "nw" -> (x,y+1)
                                                   "se" -> (x,y-1)
                                                   "sw" -> (x-1,y-1)
                                              : tiles) [(0,0)]
