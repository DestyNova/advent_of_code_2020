module Part1 where

import Text.Parsec
import Data.List (union, nub, intersect)

main = do
  txt <- readFile "input.txt"
  let gs = map (parse ruleParser "") $ lines txt
  let bags = [rule | (Right rule) <- gs]
  print $ length $ whatHolds bags

whatHolds bags = whatHolds' bags ["shiny gold"]

whatHolds' bags needed = rec bags needed 0
  where rec bags needed len = let holders = nub [b | (b, holds) <- bags, needed `intersect` holds /= []]
                              in if length holders == len then
                                    holders
                                 else
                                    rec bags (nub $ holders `union` needed) (length holders)

ruleParser :: Parsec String () (String,[String])
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
    return $ inner1 ++ " " ++ inner2
    ) $ string ", "]

  char '.'

  return (adj1 ++ " " ++ adj2, holds)
