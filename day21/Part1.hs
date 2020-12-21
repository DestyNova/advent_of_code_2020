module Main where

import Text.Parsec
import Data.Graph
import Data.Map (Map)
import qualified Data.Map as Map
import Data.List (intersect, nub)

main = do
  txt <- readFile "input.txt"
  -- let s = parse ruleParser "" txt
  -- print s
  let (Right (ingredientCounts, allergens)) = parse ruleParser "" txt
  putStrLn "Ingredients:"
  print ingredientCounts
  putStrLn "Allergens:"
  print allergens
  let safeIngredients = getSafeIngredients ingredientCounts allergens
  print safeIngredients
  print $ sum (map snd $ Map.toList safeIngredients)
  -- print $ sum [n | ingredient <- safeIngredients, (Just n) <- Map.lookup ingredientCounts]

getSafeIngredients :: Map String Int -> Map String [String] -> Map String Int
getSafeIngredients ingredientCounts allergens =
  let dodgyIngredients = nub $ concatMap snd (Map.toList allergens)
    in Map.filterWithKey (\k _ -> k `notElem` dodgyIngredients) ingredientCounts

graphHolds bags = let (g, node, vert) = graphFromEdges $ map (\(k, ks) -> ((), k, ks)) bags
                      (Just k) = vert "shiny gold"
                  in
                      length (reachable (transposeG g) k) - 1

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

