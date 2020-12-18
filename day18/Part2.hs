module Main where

import Text.Parsec
import Data.Map (Map)
import qualified Data.Map as Map

data Token = LParen | RParen | OpMul | OpPlus | OpMinus | NumVal Int | Nop
           deriving (Show, Eq)

main = do
  rs <- readFile "input.txt"
  let (Right exprs) = parse exprParser "" rs
  let res = map calculate exprs
  print $ sum res

calculate :: [Token] -> Int
calculate (x:xs) = calc $ calculate' (x:xs) [] []
calculate _ = error "Empty input"

calculate' :: [Token] -> [Token] -> [Token] -> [Token]
calculate' [] queue ops = reverse ops ++ queue
calculate' (x:xs) queue ops =
  case x of
       NumVal n -> calculate' xs (x : queue) ops
       RParen -> let pops = takeWhile (/= LParen) ops
                     pCount = length pops
                     ops' = drop pCount ops
                     ops'' = if [LParen] == take 1 ops'
                                then drop 1 ops'
                                else ops'
                     queue' = (reverse pops ++ queue)
                 in
                   calculate' xs queue' ops''

       LParen -> calculate' xs queue (x : ops)
       OpMul -> let pluses = takeWhile (`elem` [OpPlus, OpMinus]) ops
                    pCount = length pluses
                    ops' = OpMul : drop pCount ops
                    queue' = reverse pluses ++ queue
                 in
                   calculate' xs queue' ops'
       _ -> calculate' xs queue (x : ops)

calc xs = calc' (reverse xs) []

calc' :: [Token] -> [Token] -> Int
calc' [] [NumVal x] = x
calc' (NumVal x:qs) stack = calc' qs (NumVal x : stack)
calc' (op:qs) (NumVal a:NumVal b:xs) =
  let x = case op of
               OpMul -> a * b
               OpPlus -> a + b
               OpMinus -> a - b
               _ -> error $ "Bad content in calc stack: " ++ show (a,op,b)
      in calc' qs (NumVal x:xs)
calc' xs stack = error $ "Ran out of stack" ++ show (xs, stack)

exprParser :: Parsec String () [[Token]]
exprParser =
  sepEndBy (sepBy1 (do
      token <- count 1 (oneOf "()+-*") <|> many1 digit
      return $ case token of
                    "(" -> LParen
                    ")" -> RParen
                    "*" -> OpMul
                    "+" -> OpPlus
                    "-" -> OpMinus
                    x -> NumVal $ read x
    ) (string " " <|> string "")) (char '\n')

