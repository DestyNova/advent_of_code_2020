module Main where

main = do
  txt <- readFile "input.txt"
  let nums = read <$> lines txt
  print $ findSum nums 2020

findSum nums n = head [ x*y*z | x <- nums, y <- nums, z <- nums, x+y+z == n ]
