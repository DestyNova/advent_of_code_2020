# Day 15: [Rambunctious Recitation](https://adventofcode.com/2020/day/15)

*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day15/Part1.hs) (00:38:33, rank 4277), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day15/Part1.hs) (01:07:30, rank 4462)*

This one got a little silly. I decided to use `Data.Map` again, which was fine for part 1, although I made a few errors with indices and such that took a while to figure out.

As soon as I read the spec for part 2, I assumed brute force would be intractable and started looking for patterns in the first 100 numbers that might allow working out the 30000000th number very quickly. However, if I'd just started the program running while I was thinking, it would have finished after a minute or two. That's a lesson for future me.
The other obvious takeaway here is that this really is not a problem well-suited to a purely functional dictionary structure. Instead, an unboxed array would have sufficed, since I did notice from inspecting the numbers that, excluding the starting numbers, none of the other values up to index `i` seem be greater than `i` -- in fact the maximum at index `i` seemed to be around `0.944*i`. So instead of generating a new map 30 million times (facepalm), I could just update the array (`nums[nextNum] = i`). I might make that change now, just to see the difference in performance.
