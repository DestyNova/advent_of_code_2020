module Day2 where

import qualified Text.Parsec as Parsec
import Text.Parsec ((<?>))
import Control.Monad.Identity (Identity)
import qualified Data.Text as Text
import qualified Data.Text.IO as Text

main = do
  ls <- fmap Text.lines (Text.readFile "input.txt")
  print $ head $ tail ls
  let numValid = length $ filter (validPassword2 . parsePassword) ls
  print numValid

parsePassword s = Parsec.parse passwordParser "password" (Text.unpack s)

validPassword (Left s) = False
validPassword (Right (min, max, c, password)) =
  let count = length $ filter (==c) password
  in
    min <= count && count <= max

validPassword2 (Left s) = False
validPassword2 (Right (a, b, c, password)) =
  (password !! (a-1) == c) `xor` (password !! (b-1) == c)
    where xor x y = not (x && y) && (x || y)

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
