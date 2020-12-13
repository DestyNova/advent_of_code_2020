# Day 7: [Handy Haversacks](https://adventofcode.com/2020/day/7)

## Part 1
This one a bit of time just to properly parse the input format. Once that was done, I wasn't sure of the best approach, and kept flip-flopping between some kind of tree traversal, and brute-force set operations. In the end, brute-force set operations won: keep doing unions on the set of all bags that can contain the shiny gold bag, recursively, until the holding set stops growing. It takes about a second to run on my machine with the full input.

## Part 2
The second part was quite easy in comparison, although this is perhaps not the most optimal solution.

## Postscript: Part 1 with graphs
[Someone at work](https://github.com/ethercrow) tipped me off that Haskell has a [Data.Graph](https://hackage.haskell.org/package/containers-0.6.4.1/docs/Data-Graph.html) module in the standard library which could solve this type of problem. So I came back almost a week later and tried to solve part 1 again using `Data.Graph`, and was amazed to get it working in just a few minutes. The input format for constructing the graph is almost the same as the `[(String, [String])]` type I'm producing in the parsing step -- all that was required was adding a third element to the tuple, representing the node's value (not of interest in this scenario, so I used `()`). This is a directed acyclic graph, so the way to ask "how many bags can contain the shiny gold bag?" is to find the set of reachable nodes from the shiny gold bag in the transpose of the graph (otherwise, we only get the bags that can be contained by the shiny gold bag).

To solve part 2 with this approach, I think we'd need weighted edges which aren't supported in `Data.Graph`. Maybe a separate lookup table of bag counts could be constructed and consulted during a traversal. Anyway, it definitely seems less useful for this task so I'll leave it for now.
