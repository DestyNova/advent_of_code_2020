module Part1 where

import Text.Parsec

main = do
  txt <- readFile "input.txt"
  let gs = parse instructionParser "" <$> lines txt
  let prog = [insn | (Right insn) <- gs]
  print $ run prog

instructionParser :: Parsec String () (String,Int)
instructionParser = do
  op <- many1 lower
  space
  sign <- char '+' <|> char '-'
  val <- many1 digit

  return (op, read val * if sign == '-' then (-1) else 1)

run prog = run' prog 0 0 []

run' prog acc pc executed | pc >= length prog = acc
                          | pc `elem` executed = acc
                          | otherwise =
  let (insn, val) = prog !! pc
      executed' = pc : executed
  in case insn of
      "acc" -> run' prog (acc + val) (pc  +1) executed'
      "jmp" -> run' prog acc (pc + val) executed'
      _ -> run' prog acc (pc + 1) executed'
