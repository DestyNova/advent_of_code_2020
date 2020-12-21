module Main where

import Data.List (intersect, nub)
import Data.Map (Map)
import qualified Data.Map as Map
import Text.Parsec

main = do
  txt <- readFile "input.txt"
  let (Right (ingredientCounts, allergens)) = parse ruleParser "" txt
  let safeIngredients = getSafeIngredients ingredientCounts allergens
  print $ sum $ snd <$> Map.toList safeIngredients

getSafeIngredients :: Map String Int -> Map String [String] -> Map String Int
getSafeIngredients ingredientCounts allergens =
  let dodgyIngredients = nub $ concatMap snd (Map.toList allergens)
    in Map.filterWithKey (\k _ -> k `notElem` dodgyIngredients) ingredientCounts

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
  return (counts, allergens)
