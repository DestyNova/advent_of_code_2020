module Main where

import Text.Parsec

main = do
  txt <- readFile "input.txt"
  let (Right (myCards, crabCards)) = parse deckParser "" txt
  let (p1,p2,px,py) = play myCards crabCards [] []
  print $ getScore (p1++p2)

play [] xs pastXs pastYs = ([], xs, pastXs, pastYs)
play xs [] pastXs pastYs = (xs, [], pastXs, pastYs)
play p1@(x:xs) p2@(y:ys) pastXs pastYs
  | p1 `elem` pastXs && p2 `elem` pastYs = (p1, [], pastXs, pastYs)
  | otherwise =
  let pastXs' = p1 : pastXs
      pastYs' = p2 : pastYs
      in
        if length xs >= x && length ys >= y
           then -- subgame
              let (a,b, px, py) = play (take x xs) (take y ys) [] []
                in case a of
                        [] -> play xs (ys ++ [y,x]) (px++pastXs') (py++pastYs')
                        _ -> play (xs ++ [x,y]) ys (px++pastXs') (py++pastYs')
           else
                case compare x y of
                    GT -> play (xs ++ [x,y]) ys pastXs' pastYs'
                    LT -> play xs (ys ++ [y,x]) pastXs' pastYs'
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
