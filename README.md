# Vampire Numbers

**Problem definition**

**An interesting kind of number in mathematics is vampire number. A vampire number is a composite (Links to an external site.) natural number with an even number of digits, that can be factored into two natural numbers each with half as many digits as the original number and not both with trailing zeroes, where the two factors contain precisely all the digits of the original number, in any order, counting multiplicity.
A classic example is: 1260 = 21 x 60.**

**A vampire number can have multiple distinct pairs of fangs. A vampire numbers with 2 pairs of fangs is: 125460 = 204 × 615 = 246 × 510.**

**The goal of this first project is to use Elixir and the actor model to build a good solution to this problem that runs well on multi-core machines.**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `vampire` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vampire, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/vampire](https://hexdocs.pm/vampire).

