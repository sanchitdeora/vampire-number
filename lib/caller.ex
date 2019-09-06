defmodule Caller do

  def splitFactors(digits_list, _len, i, factors_list, _a) when i == length(digits_list) do
    factors_list
  end
  def splitFactors(digits_list, len, i, factors_list \\ [], elem \\ -1) do
    currElem = Enum.at(digits_list, i)
    updatedDigits_list = List.delete_at(digits_list, i)

    factors_list =
      if((elem == -1 && currElem != 0) || elem != -1) do

        elem =
          if(elem > -1) do
            elem*10 + currElem
          else
            currElem
          end

        factors_list =
          if((((elem |> Integer.digits() |> length()) + 1) == len)) do
            #            IO.puts("before createfactors for i = #{i}")
            factors_list ++ createFactors(elem, updatedDigits_list, len)
          else
            factors_list
          end

        if((((elem |> Integer.digits() |> length()) + 1) < len)) do
          inner_tasks = Enum.map(0..length(updatedDigits_list), fn(i)->
            #Task.async(Caller, :splitFactors, [updatedDigits_list, len, i, factors_list, elem])
            Caller.splitFactors(updatedDigits_list, len, i, factors_list, elem)
          end)

          factors_list = inner_tasks
          #          factors_list = Enum.map(inner_tasks, &Task.await(&1, 100000))
        else
          factors_list
        end

      else
        factors_list
      end
    factors_list = factors_list |> List.flatten()


  end

  defp createFactors(_elem, modDigits_list, _len, factors_list, i) when i == (length(modDigits_list) )do
    factors_list
  end
  defp createFactors(elem, modDigits_list, len, factors_list \\ [], i \\ 0) do

    n = (elem * 10) + Enum.at(modDigits_list, i)
    factors_list = factors_list ++ [n]
    #    IO.puts(n)
    #    IO.inspect(factors_list)
    if(i < (length(modDigits_list))) do
      createFactors(elem, modDigits_list, len, factors_list, (i + 1))
    end
  end

  def calculateVampire(num, rem_factorlist, a, i, j, fang_list) when length(rem_factorlist) == 0 do
    fang_list
  end
  def calculateVampire(num, rem_factorlist, a, i, j, fang_list \\ []) do

    fang_list = if(j >= i) do
      curr_elem = a
      mid = (i + j) / 2 |> Float.ceil |> :erlang.trunc
      mid_factor = Enum.at(rem_factorlist,mid)
      #    IO.inspect(mid_factor, label: "mid_factor")


      fang_list = cond do
        ((curr_elem * mid_factor) == num) ->

          if((( (curr_elem |> Integer.digits) ++ (mid_factor |> Integer.digits) |> Enum.sort ) == ((num |> Integer.digits) |> Enum.sort))
          && !((curr_elem |> Integer.digits |> List.last()) == (mid_factor |> Integer.digits |> List.last()) == 0)) do

            fang_list = fang_list ++ [curr_elem] ++ [mid_factor]
            fang_list
          else
            fang_list
          end

        ((curr_elem * mid_factor) < num) -> calculateVampire(num, rem_factorlist, a, (mid + 1), j, fang_list)
        ((curr_elem * mid_factor) > num) -> calculateVampire(num, rem_factorlist, a, i, (mid - 1), fang_list)
        true -> fang_list
      end
      fang_list
    else
      fang_list

    end
    fang_list

  end

  def scaleUp(num) do
    num = cond do
      (rem((num |> Integer.digits |> length),2) == 1 ) -> :math.pow(10, (num |> Integer.digits |> length))
      true -> num
    end
    num = num |> :erlang.trunc
    #    IO.inspect(num,label: "scaleUp")
  end

  def scaleDown(num) do
    num = cond do
      (rem((num |> Integer.digits |> length),2) == 1 ) -> (:math.pow(10, (num |> Integer.digits |> length) - 1) - 1)
      true -> num
    end
    num = num |> :erlang.trunc
  end
end