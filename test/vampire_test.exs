defmodule VampireTest do
  use ExUnit.Case
  doctest Vampire

  test "greets the world" do
    assert Vampire.hello() == :world
  end
end
