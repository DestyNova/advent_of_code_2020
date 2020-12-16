module Main where

import Text.Parsec
import Data.Map (Map)
import qualified Data.Map as Map

main = do
  rs <- lines <$> readFile "input.txt"

  let ruleData = takeWhile (/="") rs
  let i = length ruleData + 1
  let myTicket = head $ drop (i+1) rs
  let nearbyTicketData = drop (i+4) rs

  let (Right rules) = parse ruleParser "" (unlines ruleData)
  let nearbyTickets = [ticket | (Right ticket) <- parse ticketParser "" <$> nearbyTicketData]

  print $ countErrors nearbyTickets rules

countErrors tickets rules =
  sum $ concatMap (filter (`isInvalid` rules)) tickets

isInvalid :: Int -> Map String (Int,Int,Int,Int) -> Bool
isInvalid field =
  not . any (\(a,b,c,d) -> field `elem` ([a..b] ++ [c..d]))

ruleParser :: Parsec String () (Map String (Int,Int,Int,Int))
ruleParser = do
  rules <-
    sepEndBy (do
      field <- many1 $ letter <|> char ' '
      string ": "
      a <- many1 digit
      char '-'
      b <- many1 digit
      string " or "
      c <- many1 digit
      char '-'
      d <- many1 digit

      return (field, (read a, read b, read c, read d))
   ) $ char '\n'

  return $ Map.fromList rules

ticketParser :: Parsec String () [Int]
ticketParser = sepBy (read <$> many1 digit) (char ',')
