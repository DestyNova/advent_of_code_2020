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
calculate (x:xs) = fst $ calculate' (x:xs) []
calculate _ = error "Empty input"

calculate' :: [Token] -> [Token] -> (Int, [Token])
calculate' [] acc = (extractValue $ calc acc, [])
calculate' (x:xs) acc =
  case x of
       NumVal n -> calculate' xs (calc (NumVal n : acc))
       LParen -> let (acc', rest) = calculate' xs []
                 in
                   calculate' rest (calc (NumVal acc' : acc))
       RParen -> (extractValue acc, xs)
       OpMul -> let (acc', rest) = calculate' xs []
                 in
                   calculate' rest (calc (NumVal acc' : OpMul : acc))
       _ -> calculate' xs (x : acc)

extractValue [NumVal y] = y
extractValue xs = error $ "Bad value in acc: " ++ show xs
calc (NumVal b:op:NumVal a:xs) =
  let res = NumVal $
            case op of
                OpMul -> a * b
                OpPlus -> a + b
                OpMinus -> a - b
                _ -> error $ "Bad content in calc: " ++ show (a,op,b)
  in [res]
calc xs = xs

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

