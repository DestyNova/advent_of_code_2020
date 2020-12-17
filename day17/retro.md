# Day 17: [Conway Cubes](https://adventofcode.com/2020/day/17)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day17/Part1.hs) (01:41:04, rank 4018), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day17/Part2.hs) (02:18:16, rank 4343)*

There was an unfortunate omission from the instructions that was updated later to reduce confusion around this point: the sample input and outputs don't show the same window of 2D space! I spent at least 25 minutes just staring at the sample output, looking at my code, and re-reading the description to see how it could make sense. It turned out that the output view was for the region (0,1)-(2,3), as opposed to the (0,0)-(2,2) region for the input slice.

However, many other people apparently figured it out without any help, by looking at their own outputs and comparing against the sample output. In my case, I had a bug that I should have spotted earlier which meant the output was wrong anyway. If I'd fixed that earlier I might have noticed the pattern of shifted sample output and proceeded anyway. Also, at least one person told me they skipped straight to counting the active cubes and got the same result, so concluded (correctly) that their implementation was good.

Oh well. Also, once again I used Haskell in a kind of naieve way, producing a ton of nested lists constantly. Instead, it would have been better to maybe use a pair of mutable unboxed arrays, with a transformation function to project the 3 and 4D co-ordinates to and from a linear space.
