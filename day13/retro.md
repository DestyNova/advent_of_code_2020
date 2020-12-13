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
