#  Caller Functions to assist the Worker GenServer

defmodule Caller do

  # Used to Split the digits to Generate the fangs of required length (Length/2)
  def splitDigits(digits_list, _len, i, factors_list, _a) when i == length(digits_list) do
    factors_list
  end
  def splitDigits(digits_list, len, i, factors_list \\ [], elem \\ -1) do
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

        # If the length matches with the factors length required (Length/2), Generates the factors
        factors_list =
          if((((elem |> Integer.digits() |> length()) + 1) == len)) do
            #            IO.puts("before createfactors for i = #{i}")
            factors_list ++ createFactors(elem, updatedDigits_list, len)
          else
            factors_list
          end

        #  If the length does not match with the factors length required, Recursively call the function and increase length by 1
        if((((elem |> Integer.digits() |> length()) + 1) < len)) do
          inner_tasks = Enum.map(0..length(updatedDigits_list), fn(i)->
            Caller.splitDigits(updatedDigits_list, len, i, factors_list, elem)
          end)

          factors_list = inner_tasks
        else
          factors_list
        end

      else
        factors_list
      end
    factors_list = factors_list |> List.flatten()
  end

  # Generates the list of Factors for a current Number
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

  # Calculates the fangs of the current Number from the list of factors generated
  def calculateFangs(num, rem_factorlist, a, i, j, fang_list) when length(rem_factorlist) == 0 do
    fang_list
  end
  def calculateFangs(num, rem_factorlist, a, i, j, fang_list \\ []) do


    fang_list = if(j >= i) do
      curr_elem = a

      # Chooses the mid value in the sorted factors list and decides to recursively go
      # lower or higher from that value to check for fangs or stops if it matches. (Logic of Binary Search)
      mid = (i + j) / 2 |> Float.ceil |> :erlang.trunc
      mid_factor = Enum.at(rem_factorlist,mid)

      fang_list = cond do
        ((curr_elem * mid_factor) == num) ->
          # Checks the condition for the two fangs to be truly the fangs of the number
          if((( (curr_elem |> Integer.digits) ++ (mid_factor |> Integer.digits) |> Enum.sort ) == ((num |> Integer.digits) |> Enum.sort))
          && !((curr_elem |> Integer.digits |> List.last()) == (mid_factor |> Integer.digits |> List.last()) == 0)) do

            fang_list = fang_list ++ [curr_elem] ++ [mid_factor]
            fang_list
          else
            fang_list
          end

        # Checks which side of the mid value to move to, to obtain the fang for the particular factor, if it exists
        ((curr_elem * mid_factor) < num) -> calculateFangs(num, rem_factorlist, a, (mid + 1), j, fang_list)
        ((curr_elem * mid_factor) > num) -> calculateFangs(num, rem_factorlist, a, i, (mid - 1), fang_list)
        true -> fang_list
      end
      fang_list
    else
      fang_list

    end
    fang_list

  end

end