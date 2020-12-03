module Day2 where

import qualified Text.Parsec as Parsec
import qualified Data.Text as Text
import qualified Data.Text.IO as Text

main = do
  ls <- fmap Text.lines (Text.readFile "input.txt")
  print $ length $ filter (validPassword2 . parsePassword) ls

parsePassword s = Parsec.parse passwordParser "password" (Text.unpack s)

validPassword (Right (min, max, c, password)) =
  let count = length $ filter (==c) password
  in
    min <= count && count <= max
validPassword _ = False

validPassword2 (Right (a, b, c, password)) =
  (password !! (a-1) == c) /= (password !! (b-1) == c)
validPassword2 _ = False

passwordParser :: Parsec.Parsec String () (Int,Int,Char,String)
passwordParser = do
    min <- Parsec.many1 Parsec.digit
    Parsec.char '-'
    max <- Parsec.many1 Parsec.digit
    Parsec.string " "
    c <- Parsec.lower
    Parsec.string ": "
    password <- Parsec.many1 Parsec.lower

    return (read min, read max, c, password)
