module Main where

import Data.List (elemIndex)
import Text.Parsec

main = do
  rs <- lines <$> readFile "input.txt"
  let earliest = (read :: String -> Int) $ head rs
  print rs
  let ps = parse busParser "" <$> tail rs
  let routes = head [route | (Right route) <- ps]
  print routes
  print $ uncurry (*) $ minimum $ map (\x -> (x - (mod earliest x),x)) routes

busParser :: Parsec String () [Int]
busParser = do
  ns <- sepBy (do
          n <- try (many1 digit) <|> try (string "x")
          let x = case n of
                    "x" -> -1
                    _ -> read n
          return x
        ) $ char ','
  return $ filter (>=0) ns
