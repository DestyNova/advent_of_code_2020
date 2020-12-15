# Day 14: [Docking Data](https://adventofcode.com/2020/day/14)

*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day14/Part1.hs) (00:41:38, rank 3890), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day14/Part1.hs) (01:10:22, rank 2883)*

This is much more like the Intcode virtual machine challenges I remember from last year. As usual, parsing took a little time (maybe about 7 or 8 minutes -- I really have to start getting good at that since the leaderboard champions tend to complete entire challenges in that long).

As soon as I read the spec it was apparent that this was going to be very mutation heavy, but I still suspected that Haskell could handle it fine with `Data.Map`, and that proved to be the case. The hardest part was just understanding what was supposed to happen in part 2 with the floating bits -- again, maybe it's just too early in the morning! Anyway, no real problems other than how long it took. Might be good to revisit this one in Python and see if it's more natural.
