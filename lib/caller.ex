defmodule Caller do

  def splitFactors(digits_list, _len, i, factors_list, _a) when i == length(digits_list) do
    factors_list
  end

  def splitFactors(digits_list, len, i, factors_list \\ [], elem \\ -1) do
#    IO.puts("reached splitfactors for i = #{i}")
#    newTask = Task.async(Vampire, :splitFactors, [digits_list, len, (i + 1), factors_list, elem])
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
#        IO.puts("a = #{elem} temp = #{Enum.join(updatedDigits_list,"")}")
        factors_list =
          if((((elem |> Integer.digits() |> length()) + 1) == len) && elem != 0) do
#            IO.puts("before createfactors for i = #{i}")
            factors_list ++ createFactors(elem, updatedDigits_list, len)

          else
            factors_list
          end
#        IO.inspect(factors_list)

        if((((elem |> Integer.digits() |> length()) + 1) < len) && elem != 0) do
          inner_tasks = Enum.map(0..length(updatedDigits_list), fn(i)->
            Task.async(Caller, :splitFactors, [updatedDigits_list, len, i, factors_list, elem])
          end)
          factors_list = Enum.map(inner_tasks, &Task.await(&1, 100000))
#          splitFactors(updatedDigits_list, len, 0, factors_list ,elem)
        else
#          IO.inspect(factors_list)
          factors_list
        end
      else
        factors_list
      end
#    IO.puts("ending splitfactors for i = #{i}")
    factors_list = factors_list |> List.flatten()


  end


  defp createFactors(_elem, modDigits_list, _len, factors_list, i) when i == (length(modDigits_list) )do
    factors_list
  end
  defp createFactors(elem, modDigits_list, len, factors_list \\ [], i \\ 0) do

    n = (elem * 10) + Enum.at(modDigits_list, i)
    factors_list = factors_list ++ [n]
#        IO.puts(n)
#    IO.inspect(factors_list)
    if(i < (length(modDigits_list))) do
      createFactors(elem, modDigits_list, len, factors_list, (i + 1))
    end
  end

  def calculateVampire(num, factors_list, i \\ 0, j \\ 1, fang_list \\ []) do

    #    IO.puts("Index i = #{i} || j = #{j}")
    #    Enum.each(factors_list, fn(x) -> IO.puts(x) end)
    prev_factor = Enum.at(factors_list, i)
    next_factor = Enum.at(factors_list, j)
    #    IO.puts("#{prev_factor} x #{next_factor}")
    digittemp = Enum.sort(Integer.digits(prev_factor) ++ Integer.digits(next_factor))
    #    IO.puts("#{prev_factor} x #{next_factor}")
    #    IO.inspect(digittemp)
    fang_list =
      if(digittemp == Enum.sort(Integer.digits(num))) do

        temp = prev_factor * next_factor
        #      IO.puts("temp = #{temp} || num = #{num}")

        fang_list =
          if(temp == num) do
            fang_list ++ [prev_factor] ++ [next_factor]
          else
            fang_list
          end
        #        IO.puts(prev_factor)
        #        IO.inspect(fang_list)
      else
        fang_list
      end

    cond do
      (j < length(factors_list) - 1) -> calculateVampire(num, factors_list, i, (j + 1), fang_list)
      (i < length(factors_list) - 2) -> calculateVampire(num, factors_list, i + 1, (i + 2), fang_list)
      true -> fang_list
    end
  end


  def hello(a) do
    IO.puts("Hello" <> a)
    "Hello" <> a
  end



end
