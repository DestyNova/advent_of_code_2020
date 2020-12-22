module Main where

import Text.Parsec

main = do
  txt <- readFile "input.txt"
  let (Right (myCards, crabCards)) = parse deckParser "" txt
  let (p1,p2) = play myCards crabCards
  print $ getScore (p1++p2)


play [] xs = ([], xs)
play xs [] = (xs, [])
play (x:xs) (y:ys) = case compare x y of
                          GT -> play (xs ++ [x,y]) ys
                          LT -> play xs (ys ++ [y,x])
                          _ -> error $ "DRAW! " ++ show (x,xs,y,ys)

getScore xs = sum $ zipWith (*) (reverse xs) [1..]

deckParser :: Parsec String () ([Int], [Int])
deckParser = do
  [a,b] <- sepEndBy (
            do
              string "Player "
              digit
              string ":\n"

              map read <$> sepEndBy1 (many1 digit) (char '\n')
          ) (string "\n")
  return (a, b)
