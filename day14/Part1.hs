module Main where

import Text.Parsec
import Data.Bits (setBit, clearBit)
import Data.List (elemIndices, union)
import Data.Map (Map)
import qualified Data.Map as Map

data Instruction = SetMask String | WriteMem Int Int deriving (Show, Eq)

main = do
  rs <- lines <$> readFile "input.txt"
  print rs
  let ps = concat [insn | (Right insn) <- parse insnParser "" <$> rs]
  print ps
  let res = run ps
  print $ Map.foldr (+) 0 res

run prog = run' prog "" (Map.fromList [(i, 0) | i <- [0..10]])

run' :: [Instruction] -> String -> Map Int Int -> Map Int Int
run' [] _ acc = acc
run' (insn:xs) mask acc =
  case insn of
    SetMask m -> run' xs m acc
    WriteMem addr x -> 
      let x' = applyMask x mask
          acc' = Map.insert addr x' acc
      in
          run' xs mask acc'

applyMask x mask =
  let zeroes = map (35-) $ elemIndices '0' mask
      ones = map (35-) $ elemIndices '1' mask
      x2 = foldr (flip setBit) x ones
      x3 = foldr (flip clearBit) x2 zeroes
  in
      x3

insnParser :: Parsec String () [Instruction]
insnParser =
  sepEndBy (choice [
    try (do
      string "mask = "
      mask <- many1 $ oneOf "01X"
      return $ SetMask mask
      ),
    try (do
      string "mem["
      addr <- many1 digit
      string "] = "
      x <- many1 digit
      return (WriteMem (read addr) (read x))
    )]) $ char '\n'
