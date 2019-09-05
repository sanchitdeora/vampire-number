# Vampire Numbers

## Problem definition

An interesting kind of number in mathematics is vampire number. A vampire number is a composite (Links to an external site.) natural number with an even number of digits, that can be factored into two natural numbers each with half as many digits as the original number and not both with trailing zeroes, where the two factors contain precisely all the digits of the original number, in any order, counting multiplicity.
A classic example is: 1260 = 21 x 60.

A vampire number can have multiple distinct pairs of fangs. A vampire numbers with 2 pairs of fangs is: 125460 = 204 × 615 = 246 × 510.

The goal of this project is to use Elixir and the actor model to build a good solution to this problem that runs well on multi-core machines.

### Actor modeling:
In this project, we exclusively used the actor facility in Elixir. In particular, we defined worker actors that are given a range of problems to solve and a boss that keeps track of all the problems and perform the job assignment.
