module Main where

import Text.Parsec
import Data.List (intercalate)
import Data.Map (Map)
import qualified Data.Map as Map

data Rule = Choice [Int] [Int] | Expr [Int] | Lit Char deriving (Show)

-- Note, this just prints the huge regex that I can use with egrep later, because Haskell has no regexes built in!
main = do
  rs <- readFile "input.txt"
  let [ruleData, messages] = splitGroups rs
  let (Right rules) = parse rulesParser "" ruleData
  -- print $ rules
  print $ expandRules rules

expandRules rules =
  '^' : regex ++ "$"
  where regex = expandRules' rules 0

expandRules' rules i =
  case Map.lookup i rules of
       (Just (Lit c)) -> [c]
       (Just (Expr xs)) -> explode xs
       (Just (Choice xs ys)) -> '(' : (explode xs) ++ "|" ++ (explode ys) ++ ")"
       _ -> error $ "Bad input for rule " ++ show i
  where
    explode = concatMap (expandRules' rules)

rulesParser :: Parsec String () (Map Int Rule)
rulesParser = do
  rs <- sepEndBy (do
           ruleNum <- try $ many1 digit
           string ": "

           rule <-
            choice [try $ do
                        char '"'
                        x <- letter
                        char '"'
                        return $ Lit x
                  , try $ do
                        exprs <- sepBy (sepEndBy (try $ many1 digit) (try $ char ' ')) (string "| ")
                        return $ if length exprs == 1
                                    then Expr $ map read $ head exprs
                                    else let [a,b] = exprs in Choice (map read a) (map read b)
                   ]

           return (read ruleNum, rule)
           ) (char '\n')
  return $ Map.fromList rs

splitGroups s = reverse $ rec s "" []
  where rec "" ps acc = reverse ps : acc
        rec ('\n':'\n':rest) ps acc = rec rest "" (reverse ps : acc)
        rec (x:rest) ps acc = rec rest (x:ps) acc
