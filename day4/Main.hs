module Main where

import Data.List (isInfixOf)
import Data.Ix (inRange)
import Control.Monad (guard, void)
import Text.Parsec
import qualified Data.Text as Text
import qualified Data.Text.IO as Text

main = do
  txt <- readFile "input.txt"
  let ps = splitPassports txt
  print $ sum [1 | (Right _) <- parse passportValidator "" <$> ps]

passportValidator :: Parsec String () ()
passportValidator = do
  ks <- many1 $ do
    k <- count 3 lower
    char ':'
    case k of
      "byr" -> validateYear 1920 2002
      "iyr" -> validateYear 2010 2020
      "eyr" -> validateYear 2020 2030
      "hgt" -> do
        ds <- many1 digit
        unit <- string "cm" <|> string "in"
        guard $
          inRange (if unit == "cm" then (150,193) else (59,76)) $ read ds
      "hcl" -> do
        char '#'
        void $ count 6 $ oneOf "0123456789abcdef"
      "ecl" -> void $ choice $
        map (try . string) ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
      "pid" -> void $ count 9 digit
      "cid" -> void $ many1 digit
    spaces
    return k

  guard $ all (`elem` ks) ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

validateYear :: Int -> Int -> Parsec String () ()
validateYear a b = do
  year <- count 4 digit
  guard $ inRange (a,b) $ read year

splitPassports s = reverse $ rec s "" []
  where rec "" ps acc = reverse ps : acc
        rec ('\n':'\n':rest) ps acc = rec rest "" (reverse ps : acc)
        rec (x:rest) ps acc = rec rest (x:ps) acc
