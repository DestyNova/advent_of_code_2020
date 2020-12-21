# Day 21: [Allergen Assessment](https://adventofcode.com/2020/day/21)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day21/Part1.hs) (00:39:30, rank 1571), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day21/Part2.hs) (00:45:21, rank 1305)*

## Part 1
This was a really easy challenge, compared to yesterday's behemoth at least. Still, as usual parsing took me quite a while. If I could get comfortable with Parsec and not make silly mistakes (like forgetting the closing `)` at the end of each line), that would probably help a lot.

## Part 2
With part 1 solved, part 2 only took about 5 minutes since I was able to reuse the Sudoku-like map resolution code from [Day 16: Ticket Translation](https://github.com/DestyNova/advent_of_code_2020/blob/main/day16/retro.md). For a moment I suspected that backtracking might be needed, but it turned out to be solvable just by repeatedly eliminating any singleton values from all other allergen sets.
