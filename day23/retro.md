# Day 23: [Crab Cups](https://adventofcode.com/2020/day/23)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day23/Part1.hs) (00:40:59, rank 1618), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day23/Part2.hs) (08:32:42, rank 4854)*

## Part 1
This part was fairly straightforward and just required paying careful attention to the rules and walking through the example input.

## Part 2
I was absolutely stumped by this for quite a while, and went down several rabbit holes trying to work around the computational infeasibility of my approach by hacking in mutation of various sorts. The fundamental problem was that I was trying to slide almost every element in the array left 3 spaces to fill in the "gap" left by moving three cups (which I've been mentally calling the holdout set). There's no easy way to get away from the fact that this is takes on the order of N*M operations where N is the number of cups and M is the number of moves -- in this case 1 million multiplied by 10 million is just too much even for a modern computer (which I don't have).

Many hours of confusion and fighting the compiler followed, partly since Haskell makes it really hard to debug some things like "what are the contents of my cup array right now?". You can see some of the leftover exasperated hackery in `Part2TooSlow.hs`.

A couple of people in my private leaderboard chat room hinted that it wasn't necessary to move every element like this. So I sat down and thought for a while, and realised that we really just need to have a circular linked list or similar structure. For convenience I went for a map where the key is a cup's number and the corresponding value is the number of the next cup in the circle. In practice this meant `IntMap Int`. Then I just had to create updated "pointers" and insert them all into the map before recursing for the next move. The code was not only about 30,000 times faster than the "slide the world" approach, but also much simpler and easier to read / fix.

This produced the correct output after about 7 minutes running time (having compiled the program with `ghc -O2`). At first I ran it for smaller numbers of moves, and it seemed like the full run should have completed in just 2 or 3 minutes, but I suspect that after a certain amount of time the GC became overloaded with work and bottlenecked somewhat.

After that I was curious as to whether an unboxed mutable array would be better, where the value at index `i` is the number of the cup following cup `i`. Surprisingly, the changes were very easy after rewriting the program to use `IntMap`, and it produced the same output after 2.8 seconds. I expected it to be faster but not by this much!
