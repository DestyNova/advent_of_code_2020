module Part2 where

import Text.Parsec
import Data.List (find)

main = do
  txt <- readFile "input.txt"
  let gs = map (parse ruleParser "") $ lines txt
  let bags = [rule | (Right rule) <- gs]
  print $ countHolding bags

countHolding :: [(String, [(String, Int)])] -> Int
countHolding bags = countHolds bags "shiny gold"

countHolds :: [(String, [(String, Int)])] -> String -> Int
countHolds bags bag =
  case find (\(b, h) -> b == bag) bags of
    Nothing -> 0
    Just (_, holding) -> sum $ map (\(innerBag, n) -> n + n * countHolds bags innerBag) holding

ruleParser :: Parsec String () (String,[(String, Int)])
ruleParser = do
  adj1 <- many1 lower
  space
  adj2 <- many1 lower
  space
  string "bags"
  space
  string "contain"
  space

  holds <- choice [try (string "no other bags" >> return []), try $ sepBy (do
    n <- many1 digit
    space
    inner1 <- many1 lower
    space
    inner2 <- many1 lower
    space
    choice $ map (try . string) ["bags", "bag"]
    return (inner1 ++ " " ++ inner2, read n)
    ) $ string ", "]

  char '.'

  return (adj1 ++ " " ++ adj2, holds)
