module Main where

import Data.List (intersect, (\\), intercalate, sortOn)
import Data.Map (Map)
import qualified Data.Map as Map
import Text.Parsec

main = do
  txt <- readFile "input.txt"
  let (Right (ingredientCounts, allergens)) = parse ruleParser "" txt
  let canonicalAllergens = resolveMap allergens
  putStrLn $ intercalate "," $ snd <$> sortOn fst (Map.toList canonicalAllergens)

resolveMap :: Map String [String] -> Map String String
resolveMap m =
  resolveMap' m (Map.fromList [])

resolveMap' :: Map String [String] -> Map String String -> Map String String
resolveMap' m fs =
  let known = Map.filter (\xs -> length xs == 1) m
      unknown = Map.filter (\xs -> length xs > 1) m
      toDelete = Map.foldr (++) [] known
      m' = Map.map (\\ toDelete) m
  in
      if Map.size known == 0 then
        fs
      else
        resolveMap' m' (Map.union fs (Map.map head known))

ruleParser :: Parsec String () (Map String Int, Map String [String])
ruleParser = do
  ps <- sepEndBy (
          do
            ingredients <- sepEndBy1 (many1 lower) space
            string "(contains "
            allergens <- sepBy1 (many1 lower) (string ", ")
            char ')'

            let counts = zip ingredients (repeat 1)
            let allergenPairs = zip allergens (repeat ingredients)
            return (counts, allergenPairs)
        ) (string "\n")
  let counts = Map.fromListWith (+) $ concatMap fst ps
  let allergens = Map.fromListWith intersect (concatMap snd ps)
          -- map (\(code, tx) -> (code, [tx])) $ concatMap snd ps
  return (counts, allergens)
