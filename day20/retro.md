# Day 20: [Jurassic Jigsaw](https://adventofcode.com/2020/day/20)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day20/Part1.hs) (01:04:54, rank 1553), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day20/Part2.hs) (10:45:22, rank 3080)*

## Part 1
This time parsing wasn't a problem so much as how to actually match up the pieces. I hit upon the idea quite quickly of converting each piece's edge (and its reverse in case of flips) to a binary number, since there are only two possible states for each cell. Since each grid edge is only 10 cells long, that means we have a possible 2^10 = 1024 possible edges. It seemed likely that something like this was the intended way to solve the problem, rather than brute forcing all permutations.

So during the parsing step, I create a map from the edge "code" to the set of all tiles that contain this edge in some orientation, backwards or forwards. Later, I just had to invert this relationship and find the tiles that only shared edge codes with two distinct other tiles.

## Part 2
Here is where it got incredibly tricky. After a leisurely hour on part 1 I figured this would be only another 15 or 20 minutes, but it took almost TEN MORE HOURS without breaks.

It turned out that my algorithm for part 1 could find the corners but wasn't sufficient to piece the rest of the tiles together. For this, I had to walk through all of the tiles and find one the connects to the left of the first, until we complete a row (by running out of pieces that can be placed to the left). Then we find the piece that goes under the rightmost piece in the previous row, and so on until all rows have been completed.

This sounds straightforward, but my logic for rotating tiles was wrong in several places and needed a lot of debugging. This is where it probably would have been good to pause and generate a few test cases, rather than plugging away in GHCi.
Once the rotations were fixed, I then had to strip all the borders (the source of another serious bug) and search for Nessie.

Although it took me many hours, the actual searching part was fast. I transformed the monster "sprite" into a sparse vector and walked through the full grid, checking for each position `(k,l)` whether a hash symbol can be found at the points formed by adding each monster coordinate to `(k,l)`. This is probably where Haskell's laziness is an advantage, since the first failed match short circuits the rest of the check -- although many other programming languages also implement short-circuiting boolean operations or folds like this.

By the end, I was relieved at having solved the puzzle, but really disheartened that it took almost eleven hours in total. For a while I was starting to fear that I just wouldn't be able to do it, or that I'd have to start again from scratch. Hopefully tomorrow's puzzle isn't so hard, since I have a long trip planned around noon. The puzzles unlock at 5am my time, so that should give me enough time unless it turns out like today did. Not sure if it's cumulative sleep deprivation or if my problem-solving / puzzling skills are just not up to scratch.
