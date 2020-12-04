module Day3 where

import Data.List (isInfixOf)

main = do
  txt <- readFile "input.txt"
  let ps = splitPassports txt

  print $ length $ filter isValid ps

splitPassports s = rec s "" []
  where rec "" ps acc = reverse ps : acc
        rec ('\n':'\n':rest) ps acc = rec rest "" (reverse ps : acc)
        rec (x:rest) ps acc = rec rest (x:ps) acc


isValid :: String -> Bool
isValid passport = all (`isInfixOf` passport) keys
  where keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
