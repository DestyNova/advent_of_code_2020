module Main where

import Text.Parsec
import Data.List (nub, transpose)
import Data.Map (Map)
import qualified Data.Map as Map

data Side = N | E | S | W deriving (Show, Eq)
data Flip = None | H | V | HV deriving (Show, Eq)

main = do
  rs <- readFile "sample.txt"
  let (Right photos) = parse photosParser "" rs
  -- print $ photos
  let corners = getCorners photos
  print corners
  print $ product $ Map.keys corners
  -- print $ expandPhotos photos

getCorners photos =
  let connections =
        Map.fromListWith (\a b -> nub (a ++ b)) $
        concat $
        (\xs -> (\(pid, _, _) -> (pid, (\(a,_,_) -> a) <$> xs)) <$> xs) <$>
        (snd <$> (Map.toList $ Map.filter (\xs -> length xs == 2) photos))
      lengths = Map.map length connections
      in Map.filter (==3) lengths

photosParser :: Parsec String () (Map Int [(Int, Side, Flip)])
photosParser = do
  ps <- sepEndBy (
          do
            string "Tile "
            photoId <- try $ many1 digit
            let pid = read photoId
            string ":\n"

            grid <- sepEndBy1 (count 10 $ char '#' <|> char '.') (char '\n')
            let grid' = transpose grid

            let top = bin2dec (head grid)
            let topH = bin2dec (reverse $ head grid)
            let bottom = bin2dec (last grid)
            let bottomH = bin2dec (reverse $ last grid)

            let left = bin2dec (head grid')
            let leftV = bin2dec (reverse $ head grid')
            let right = bin2dec (last grid')
            let rightV = bin2dec (reverse $ last grid')

            return [(top, (pid, N, None))
                   ,(topH, (pid, N, H))
                   ,(right, (pid, E, None))
                   ,(rightV, (pid, E, V))
                   ,(bottom, (pid, S, None))
                   ,(bottomH, (pid, S, H))
                   ,(left, (pid, W, None))
                   ,(leftV, (pid, W, V))]
           ) (string "\n")
  return $ Map.fromListWith (++) $ map (\(code, tx) -> (code, [tx])) $ concat ps

bin2dec :: String -> Int
bin2dec s = rec '#' '.' s 0
  where rec hi lo "" total = total
        rec hi lo (c:cs) total = rec hi lo cs (2*total + if c == hi then 1 else 0)
