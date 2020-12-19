# Day 19: [Monster Messages](https://adventofcode.com/2020/day/19)
*Haskell: [Part 1](https://github.com/DestyNova/advent_of_code_2020/blob/main/day19/Part1.hs) (01:17:40, rank 2306), [Part 2](https://github.com/DestyNova/advent_of_code_2020/blob/main/day19/Part2.hs) (01:42:10, rank 1409)*

## Part 1
After the usual 40 minutes spent fighting with Parsec due to partially-consumed failed parses, the actual logical part of this was really straightforward:

1. Build a dictionary of `rule id -> rule`, where the rule is one of a literal character, a single expression formed by concatenating several rules, or a choice between two such concatenations. This dictionary represents a hierarchical rule tree.
2. Do a depth-first traversal of the rule tree starting from rule 0.
  * Base case: a literal just takes its own value as a string.
  * Recursive case: an expression takes the value of concatenating all evaluated sub-rules.
  * Recursive case: a choice expression takes the value of `(concat left|concat right)`, where left and right represent the evaluated left and right expressions.
3. Cheat by outputting the resulting regex to the console and using `egrep` and `wc` to count matching lines.

The last step was a bit surprising as I expected Haskell would include a built-in regex engine -- I mean, it support for directed graphs in the standard library so why not regexes, which are likely to be of more use in most programs?

## Part 2
This one was actually not bad at all despite the initial shock. Rule 8 is very easily handled by simply expanding the left side and wrapping it in `(...)+`.

Rule 11 is much more of a problem since it's not possible to solve using standard DFA-based regex (this is one of the memories that stuck around from my computational complexity course back in college, taught by [this very entertaining professor](https://www.dfki.de/en/web/about-us/employee/person/jova02/) before he left Ireland). Rather than mess about with AWK or PCRE or some other slightly-more-powerful regex engine that could cause all sorts of confusion and delay, I decided that given the size of the input, it was unlikely that __too__ many expansions of the inner rule could appear. So instead, I expanded it to a depth of 5 which turned out to be sufficient, ending up with an expression like `(ab|aabb|aaabbb|...)` where `a` and `b` are the expanded subexpressions for rules 42 and 31 respectively.

I ran into a problem just trying to copy and paste the output at this point, so decided to write the resulting regex to a file which could then be used like so:

```
egrep `cat output2.txt` input2.txt | wc -l
```
