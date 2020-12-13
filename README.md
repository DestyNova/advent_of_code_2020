# Advent of Code 2020

I'm trying to solve [Advent of Code 2020](https://adventofcode.com/2020/) programming puzzles. For most of them I'll be using Haskell, but for things that are more naturally suited to heavily-mutative solutions (at least, based on my fairly basic Haskell / pure functional problem-solving knowledge) I might use Python.

## Retrospectives

### Day 13: [Shuttle Search](https://adventofcode.com/2020/day/13)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day13/Part1.hs), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day13/Part1.hs)*

This one was really nice. I wasted a bit of time in part 1 just fumbling the parsing, despite the very simple syntax. Parsec is really powerful, but I still stumble with parses that require backtracking. That seems to be required whenever you use the `choice` or `<|>` operator, but I guess there are some scenarios where it isn't needed, and since it's relatively expensive, you have to do it explicitly.

For part 2, I got stuck for at least an hour just trying to figure out the relationship between the route numbers (a.k.a. arrival intervals) and the result. I worked out a few very simple cases using a brute-force test like this:
```haskell
let a=5;b=9 in find (\x -> mod (x+1) b == 0) $ map (*a) [0..500]

-- => Just 35
```
(Actually I used something worse than this, but anyway)

So I wanted to figure out what function `f` produces values like the following:
```
f 3 5 = 9
f 3 7 = 6
f 5 7 = 20
```
And so on. After a long time of not really getting it, I remembered that we were dealing with modular arithmetic, and did some web searching for phrases like "solve multiple modulo". Thanks to the magic of the internet, I was directed almost instantly to some Stack Overflow questions whose answers discussed the [Chinese remainder theorem](https://nrich.maths.org/5466).

Embarrassingly, I learned about this theorem in my undergraduate cryptography module, but that was about 14 years ago. Still, the fact that all the shuttle numbers in the input data were coprime (in fact, I think all of them were prime numbers) should have been a clue.
Anyway, from this point, all that was needed was to reformulate the problem in terms of modular arithmetic: if we want to solve for input `5,9`, then we're trying find a value for `x` such that:
```
x `mod` 5 == 0 && (x+1) `mod` 9 == 0
```
To use the Chinese remainder theorem, we need to manipulate it slightly so that we're finding the modulo relative to the same number:
```
x `mod 5 == 0 && x `mod` 9 == (9)-1
```
With some more guidance from the internet (see comments in the part 2 source), I ended up with a function `crt` which takes a list of pairs `(interval, timeOffset)`, for example in this case we'd have `[(5, 0), (9, -1)]`. Since we filter out the wildcard values earlier, we're left with just the relevant modulo constraints.

Overall, this was a fun challenge that (re-)taught me some useful number theory.

### Day 12: [Rain Risk](https://adventofcode.com/2020/day/12)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day12/Part1.hs), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day12/Part1.hs)*

Much easier than many of the recent problems, the only difficulty was in handling the waypoint rotation in part 2, but that's helped by the fact that you can drop all the logic for managing ship orientation.

### Day 11: [Seating System](https://adventofcode.com/2020/day/11)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day11/Part1.hs), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day11/Part1.hs)*

This one took about 2 hours for the two parts, and it's the point where I decided it was probably not a great idea for me to try with Haskell first for mutating matrix problems. The amount of nested mapping and transformation was quite awkward, and the method of accessing elements of the matrix was very inefficient. It would have been faster to use `Data.Array`, but that felt quite cumbersome to use. However, I'll probably rewrite this later to do that just as an experiment.
Running the program on the full input inside GHCi took about a minute on my laptop, but the compiled version completes in about 16 seconds.

### Day 10: [Adapter Array](https://adventofcode.com/2020/day/10)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day10/Part1.hs), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day10/Part1.hs)*

I had a really hard time with this and felt quite stupid at several points. Part 1 took only 10 minutes to solve, but part 2 took literally 5 hours straight. Initially I spent a long time struggling with the combinatory approach before realising that it would never work due to the time complexity required to enumerate all solutions.
Eventually, I realised that you can walk over the sorted list of adapter values and look at a window of five elements. If the difference between the first and last is 4, that means the five elements are all sequential numbers, and that you can drop any combination of the middle elements _except_ all three of them, which would violate the "maximum adapter difference = 3" rule. That means, considering it as a boolean problem with three bits that can take any value other than 111, there are seven possible combinations. However, if you _don't_ have five sequential adapter values, then you should just look at whether one element can be dropped without violating the rule, before sliding the window forward by one element and continuing until you've reached the end.

Afterwards, I looked at a couple of other people's solutions (if I remember which ones were good, I'll post them here) and saw a mention of [dynamic programming](https://en.wikipedia.org/wiki/Dynamic_programming) as a more general method of solving it. I don't remember covering DP in undergrad compsci back in the 2000s, but we did do a fair bit of graph theory which would also probably have been a good way to approach this. After a few struggles like today, I'm seeing a recurring issue I tend to into with these problems: I don't follow a systematic method of understanding and solving them, and instead have to reason about each one from scratch, which usually means coming up with quite inefficient and naieve solutions that need lots of trial and error and head-scratching to manipulate into a useful program.

In my experience of programming in industry, about 95% of my time is spent either in meetings, searching for information, or configuring and wiring things together (e.g. editing Kubernetes YAML manifests), rather than writing "pure" problem-solving code like this, which means it's possible to go through your career without ever really developing good skills for the core problems of computation. This situation feels very unfulfilling, so I'm going to start regularly exercising these problems and going through more of the algorithmic and computational problem-solving literature.
