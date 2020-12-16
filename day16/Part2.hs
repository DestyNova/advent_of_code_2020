module Main where

import Text.Parsec
import Data.List (transpose, (\\), isPrefixOf)
import Data.Map (Map)
import qualified Data.Map as Map

main = do
  rs <- lines <$> readFile "input.txt"

  let ruleData = takeWhile (/="") rs
  let i = length ruleData + 1
  let myTicketData = head $ drop (i+1) rs
  let nearbyTicketData = drop (i+4) rs

  let (Right rules) = parse ruleParser "" (unlines ruleData)
  let (Right myTicket) = parse ticketParser "" myTicketData
  let nearbyTickets = [ticket | (Right ticket) <- parse ticketParser "" <$> nearbyTicketData]

  let validTickets = discardInvalid nearbyTickets rules
  let fieldMapping = getFieldMapping validTickets rules
  let fieldColumns = resolveMap fieldMapping
  print fieldColumns
  print $ product $ getDepartureFields myTicket fieldColumns

getDepartureFields ticket m =
  let fields = Map.filterWithKey (\k a -> "departure" `isPrefixOf` k) m
  in
    Map.foldr (\field acc -> (ticket !! field) : acc) [] fields

resolveMap :: Map String [Int] -> Map String Int
resolveMap m =
  resolveMap' m (Map.fromList [])

resolveMap' :: Map String [Int] -> Map String Int -> Map String Int
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

getFieldMapping tickets rules =
  let tx = transpose tickets
      numFields = length tx
  in
    Map.map (\(a,b,c,d) -> [i | i <- [0..numFields-1], isValid (a,b,c,d) (tx !! i)]) rules

isValid (a,b,c,d) xs = and [x `elem` [a..b] || x `elem` [c..d] | x <- xs]

discardInvalid tickets rules =
  concat $ zipWith (\a b -> [b | null a]) (map (filter (`isInvalid` rules)) tickets) tickets

isInvalid :: Int -> Map String (Int,Int,Int,Int) -> Bool
isInvalid field rules =
  not $
  Map.foldr (\(a,b,c,d) v -> v || field `elem` [a..b] || field `elem` [c..d]) False rules

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
