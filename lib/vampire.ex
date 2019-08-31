defmodule Vampire do
  @moduledoc """
  Documentation for Vampire.
  """

  @doc """
  Hello world.

  ## Examples
      iex> Vampire.hello()
      :world

  """
  def hello do
    :world
  end

  def splitFactors(digit_list, len, i \\ 0, fac_list \\ [], a \\ -1) do
    b = Enum.at(digit_list, i)
    temp_list = List.delete_at(digit_list, i)
    {a, temp_list} = if(a > -1) do
      { String.to_integer(Enum.join([a |> to_string(), b |> to_string()], "")),
        temp_list}
    else
      {b, temp_list}
    end
    IO.puts(["a = ", Enum.join([a,""], "")])
    IO.puts(["b = ", Enum.join([b,""], "")])
    fac_list =
      if(((a |> Integer.digits() |> length()) + 1) == len) do
        fac_list ++ createFactors(a, temp_list, len)
      else
        fac_list
      end

    fac_list =
      if(((a |> Integer.digits() |> length()) + 1) < len) do
        fac_list ++ splitFactors(temp_list, len, 0, fac_list ,a)
      else
        fac_list
      end

    #    IO.puts("Im here first")
    #    fac_list = fac_list ++ tempfac_list
    #    Enum.each(fac_list, fn(s) -> IO.puts(s) end)
    #    IO.puts("Im here last")

    IO.puts("digit list")
    IO.puts(["a = ", Enum.join([a,""], "")])
    IO.puts(["b = ", Enum.join([b,""], "")])
    Enum.each(digit_list, fn(s) -> IO.puts(s) end)

    a = List.delete_at(a |> Integer.digits(), (a |> Integer.digits() |> length()) - 1 ) |> Integer.undigits()
    IO.puts(["Before rec fn a = ", Enum.join([a,""], "")])
    IO.puts(["i = ", Enum.join([i,""], "")])
    if(i < (length(digit_list) - 1)) do
      splitFactors(digit_list, len, (i + 1), fac_list, a)
    else
      fac_list
    end
  end



  def createFactors(left, right, len, fac_list \\ [], i \\ 0) do

    #    if(((left |> Integer.digits() |> length()) + 1) == len ) do
    n = String.to_integer(Enum.join([left |> to_string(), Enum.at(right, i) |> to_string()], ""))
    fac_list = fac_list ++ [n]
    IO.puts(n)
    #    end


    if(i < (length(right) - 1)) do
      createFactors(left, right, len, fac_list, (i + 1))
    else
      fac_list
    end
  end
end