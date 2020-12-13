### Day 11: [Seating System](https://adventofcode.com/2020/day/11)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day11/Part1.hs), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day11/Part1.hs)*

This one took about 2 hours for the two parts, and it's the point where I decided it was probably not a great idea for me to try with Haskell first for mutating matrix problems. The amount of nested mapping and transformation was quite awkward, and the method of accessing elements of the matrix was very inefficient. It would have been faster to use `Data.Array`, but that felt quite cumbersome to use. However, I'll probably rewrite this later to do that just as an experiment.
Running the program on the full input inside GHCi took about a minute on my laptop, but the compiled version completes in about 16 seconds.
