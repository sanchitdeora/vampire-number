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

  def splitFactors(digit_list, len, i , fac_list, a) when i == length(digit_list) do
    fac_list
  end

  def splitFactors(digit_list, len, i \\ 0, fac_list \\ [], a \\ -1) do
    IO.puts("#{a} #{inspect digit_list} #{i} #{inspect fac_list}")
    if(i < (length(digit_list))) do
      t = Task.async(Vampire, :splitFactors, [digit_list, len, (i + 1), fac_list, a])
      #      IO.inspect(t)
      b = Enum.at(digit_list, i)
      temp_list = List.delete_at(digit_list, i)
      IO.puts("Here #{b} #{a}")
      fac_list=
        if((a == -1 && b != 0) || a != -1) do
          {a, temp_list} = if(a > -1) do
            { (a*10 + b),
              temp_list}
          else
            {b, temp_list}
          end
          #          IO.puts(["a = ", Enum.join([a,""], "")])
          #          IO.puts(["b = ", Enum.join([b,""], "")])
          fac_list=
            if((((a |> Integer.digits() |> length()) + 1) == len) && a != 0) do
              IO.inspect("CreateFactor called")
              fac_list ++ createFactors(a, temp_list, len)
            else
              fac_list
            end

          fac_list=
            if((((a |> Integer.digits() |> length()) + 1) < len) && a != 0) do
              IO.inspect("SplitFactor called")
              fac_list ++ splitFactors(temp_list, len, 0, fac_list ,a)
            else
              fac_list
            end
        else
          fac_list
        end
      IO.puts("#{b} #{a}")
      IO.inspect(fac_list)
      fac_list++Task.await(t)
      #
    else
      fac_list
    end
  end

  def createFactors(left, right, len, fac_list \\ [], i \\ 0) do

    n = left*10 + Enum.at(right, i)
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