module Part2 where

import Text.Parsec

main = do
  txt <- readFile "input.txt"
  let ps = parse instructionParser "" <$> lines txt
  print $ run [insn | (Right insn) <- ps]

instructionParser :: Parsec String () (String,Int)
instructionParser = do
  op <- many1 lower
  space
  sign <- char '+' <|> char '-'
  val <- many1 digit

  return (op, read val * if sign == '-' then (-1) else 1)

run prog =
  head $ dropWhile (\(acc, ok) -> not ok) $ map (run' prog 0 0 []) [0..length prog]

run' prog acc pc executed flipPc | pc >= length prog = (acc, True)
                                 | pc `elem` executed = (acc, False) -- looped
                                 | otherwise =
  let (insn, val) = prog !! pc
      flippedInsn = case (insn, pc == flipPc) of
                      ("nop", True) -> "jmp"
                      ("jmp", True) -> "nop"
                      _ -> insn
      executed' = pc : executed
  in case flippedInsn of
      "acc" -> run' prog (acc + val) (pc+1) executed' flipPc
      "jmp" -> run' prog acc (pc+val) executed' flipPc
      _ -> run' prog acc (pc+1) executed' flipPc
