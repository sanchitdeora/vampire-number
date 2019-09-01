defmodule Vampire do

  def splitFactors(digits_list, _len, i, factors_list, _a) when i == length(digits_list) do
    factors_list
  end
  def splitFactors(digits_list, len, i \\ 0, factors_list \\ [], elem \\ -1) do

    newTask = Task.async(Vampire, :splitFactors, [digits_list, len, (i + 1), factors_list, elem])
    currElem = Enum.at(digits_list, i)
    updatedDigits_list = List.delete_at(digits_list, i)

    factors_list =
      if((elem == -1 && currElem != 0) || elem != -1) do

        {elem, updatedDigits_list} =
          if(elem > -1) do
            { (elem*10 + currElem), updatedDigits_list}
          else
            {currElem, updatedDigits_list}
          end

        factors_list =
          if((((elem |> Integer.digits() |> length()) + 1) == len) && elem != 0) do
            factors_list ++ createFactors(elem, updatedDigits_list, len)
          else
            factors_list
          end

          if((((elem |> Integer.digits() |> length()) + 1) < len) && elem != 0) do
            splitFactors(updatedDigits_list, len, 0, factors_list ,elem)
          else
            factors_list
          end

      else
        factors_list
      end
    factors_list++Task.await(newTask)

  end

  defp createFactors(_elem, modDigits_list, _len, factors_list, i) when i == (length(modDigits_list) )do
    factors_list
  end
  defp createFactors(elem, modDigits_list, len, factors_list \\ [], i \\ 0) do

    n = (elem * 10) + Enum.at(modDigits_list, i)
    factors_list = factors_list ++ [n]
    if(i < (length(modDigits_list))) do
      createFactors(elem, modDigits_list, len, factors_list, (i + 1))
    end
  end

  def calculateVampire(num, factors_list, i \\ 0, j \\ 1, fang_list \\ []) do

#    IO.puts("Index i = #{i} || j = #{j}")
    prev_factor = Enum.at(factors_list, i)
    next_factor = Enum.at(factors_list, j)

    digittemp = Enum.sort(Integer.digits(prev_factor) ++ Integer.digits(next_factor))
    IO.puts("#{prev_factor} x #{next_factor}")
#    IO.inspect(digittemp)
    fang_list =
    if(digittemp == Enum.sort(Integer.digits(num))) do

      temp = prev_factor * next_factor
      IO.puts("temp = #{temp} || num = #{num}")

      fang_list =
        if(temp == num) do
          fang_list ++ [prev_factor] ++ [next_factor]
        else
        fang_list
        end
        IO.puts(prev_factor)
        IO.inspect(fang_list)
    else
      fang_list
    end

    cond do
      (j < length(factors_list) - 1) -> calculateVampire(num, factors_list, i, (j + 1), fang_list)
      (i < length(factors_list) - 2) -> calculateVampire(num, factors_list, i + 1, (i + 2), fang_list)
      true -> fang_list
    end
  end



end