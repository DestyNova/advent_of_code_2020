module Main where

import Text.Parsec
import Data.Bits (setBit, clearBit)
import Data.List (elemIndices)
import Data.Map (Map)
import qualified Data.Map as Map

data Instruction = SetMask String | WriteMem Int Int deriving (Show, Eq)

main = do
  rs <- readFile "sample2.txt"
  let (Right prog) = parse insnParser "" rs
  print $ Map.foldr (+) 0 (run prog)

run prog = run' prog "" (Map.fromList [(i, 0) | i <- [0..10]])

run' :: [Instruction] -> String -> Map Int Int -> Map Int Int
run' [] _ acc = acc
run' (insn:xs) mask acc =
  case insn of
    SetMask m -> run' xs m acc
    WriteMem addr x -> 
      let addrs = applyMask addr mask
          acc' = foldr (\addr' m -> Map.insert addr' x m) acc addrs
      in
          run' xs mask acc'

applyMask addr mask =
  let floatingBits = map (35-) $ elemIndices 'X' mask
      ones = map (35-) $ elemIndices '1' mask
      addr' = foldr (flip setBit) addr ones
      addrs = expandFloating addr' floatingBits
  in
      addrs

expandFloating addr [] = [addr]
expandFloating addr (i:xs) =
  let bitOn = setBit addr i
      bitOff = clearBit addr i
  in
      expandFloating bitOff xs ++ expandFloating bitOn xs

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
