# Day 25: [Combo Breaker](https://adventofcode.com/2020/day/25)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day25/Part1.hs) (01:17:19, rank 3530), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day25/Part2.hs) (01:18:49, rank 2842)*

## First steps
This was really just a pretext for solving the discrete logarithm problem. I tried a brute-force approach at first and realised that, although this is fine for the sample case, the actual input numbers correspond to a much larger "loop size" or `x`. This meant that trying to reverse the expression by trial exponentiation would take far too long.

I started trying to implement Pollard's Rho method, then gave up and found a Javascript/WebAssembly calculator online that found the result in literally less than a second, which was quite amazing, especially on this old laptop.

## Doing it right
After submitting the "solution", I came back and implemented the Pohlig-Hellmann algorithm which is what the online calculator used. It took quite a lot of debugging because my knowledge of modular arithmetic and group theory is quite rusty (despite covering all of this in a cryptography module during my undergraduate studies). Eventually after implementing it, I was very confused to discover that the version compiled with `ghc -O2` still took 26 minutes to run -- even just the last step of transforming the result (`mod (8790390^9374311) 20201227`) takes longer than the Javascript/WebAssembly program took to reverse the logarithm in my browser!

## Modular explosion, and really doing it right
At first I thought there might be some other clever optimisations in the applet's implementation of the algorithm, but it didn't seem likely that this could lead to it being thousands, or tens of thousands of times faster. Instead, it seemed likely that many exponentiation operations were generating absolutely gigantic numbers that needed to be allocated and garbage collected later, even though we immediately apply modulo operations that would reduce them to a tiny size.

So I set about implementing a faster modulo exponentiation algorithm. First, I tried the naieve `mod (base*base) (power-1)` recursive approach, but this was also really slow since it requires `O(n)` time where `n` is the exponent, and we're dealing with quite large exponents.

Then I remembered that exponentiation can be done in logarithmic time by dividing the exponent by 2 whenever it's even and multiplying by larger base values -- see [this article](https://dev-notes.eu/2019/12/Fast-Modular-Exponentiation/) for an explanation.

With this implemented, I changed all modular exponentiation steps to use this function and the resulting optimised binary produced the same result in 0.35 seconds. Wow!

Well, that's a good way to end what's been a thoroughly enjoyable Advent of Code 2020. If you haven't tried the puzzles, I can highly recommend them as a nice way to learn a new programming language and improve upon missing parts of your computer science knowledge. It turns out I had, and still have a lot of improvement to do, so this was an exciting eye-opener.

Happy Christmas, and let's hope 2021 is fun!
