# Day 22: [Crab Combat](https://adventofcode.com/2020/day/22)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day22/Part1.hs) (00:12:33, rank 1592), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day22/Part2.hs) (00:39:04, rank 802)*

## Part 1
Another fairly straightforward challenge -- I guess there's a trend that the super-hard challenges are kept for weekends to avoid ruining people's workdays. That's really considerate, given how long I spent on day 20.

Writing the parser didn't take long since the format is so simple and I'm starting to get a little more comfortable with Parsec (for easy formats at least).

The loop for playing the game was a very short recursive function. I added an error check that bails if there's a draw since that didn't seem to be specified in the spec, but a draw never happened in the sample or full input. I'm not going to check now, but I'm guessing the input is designed so that every card has a unique value, avoiding the possibility of a draw.

## Part 2
The main time sink for part 2 was just reading through the new rules. The subgames part turned out to be very easy to implement, since in Haskell it's not natural to use mutation anyway, meaning there was no risk of trashing important game state when recursing into the subgame. That said, it wasn't completely clear to me if the set of seen deck configurations should either be passed down to the subgame or passed back from it. A couple of trial and error attempts confirmed that the subgame should start with an empty slate, but we need to append its final set of seen configurations to the current game's set after the subgame finishes.

The other thing that tripped me up slightly was the runtime of the game. I sort of assumed that it would take almost no time to run, since part 1 completed instantly. When that didn't happen in part 2, I assumed there was an infinite loop and checked all the recursion and termination logic again. Thanks to the halting problem, I decided to just compile the program instead of running it in `ghci` and the game completed on the full input data in 42 seconds.

On a meta note, this is the first challenge in which I've managed to land within the top 1,000 players. This doesn't sound like a great achievement, but it feels nice after some of the previous disastrous attempts -- day 20 especially left me a bit daunted and disappointed.
