# Day 24: [Lobby Layout](https://adventofcode.com/2020/day/24)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day24/Part1.hs) (00:46:08, rank 2588), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day24/Part2.hs) (01:32:54, rank 2509)*

## Part 1
This was a really enjoyable puzzle. I hadn't worked with hexagonal grids before, other than playing some board games that used them. The parsing step was very easy since it's a pretty simple format, and I've had quite a bit of practice over the last 24 days.

I thought I'd devised a very neat way to quickly arrive at an answer, by each line into a list of tile coordinates described by folding over each line's steps and summing coordinates on each step starting with `(0,0)`. At first I wasn't clear about whether each line flips just one tile, or every tile along the path, but it turned out to be just the last tile in the path, which was actually explained in the text, but I didn't realise until later.

After describing the paths of all lines and taking the final tile coordinate from each, I tack on a count of 1 to each, and concatenate them all together and use `Map.fromListWith (+)` to sum together counts where we saw the same tile multiple times. This lets us get the total number of black tiles by counting the number of odd values in the map.

Where I got stuck for a while was my understanding of hex grid coordinate systems -- namely that a tiles neighbours are not all the combinations of adding `[-1,0,+1]` to the x and y coordinates (this only makes sense for square grids). I didn't notice this error until I searched for some example hex grid images with numbered coordinates. Whoops!

## Part 2
This part was also really fun. I knew pretty quickly how it might be solved, and set about mapping over every coordinate and getting the count of neighbours with odd values. However, I was again stuck here for a little while because I totally forgot that mapping over the tile map meant I was only updating tiles that were already seen from the beginning. This meant adjacent tiles that should flip were not being flipped.

The fix was to expand the map at each iteration by adding all the possible neighbours of each tile with a default value of 0. This felt a bit inefficient since I was then evaluating the same operation again almost immediately, to check the neighbours of each tile in the expanded graph. As a result, the program took 22 seconds to run when compiled with `ghc -O2`. I'm sure there are massively more efficient ways to do this, even while still using immutable data structures. I'll probably take a look at live stream recordings of some other people solving it, to get some ideas about that.

All in all, this was one of my favourites of the Advent of Code 2020 collection.
