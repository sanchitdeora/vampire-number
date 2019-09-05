defmodule Vampire do
#UNUSED FOR NOW
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
#    IO.puts(n)
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


#  VAMPIRE NUMBER CALCULATION USING GENSERVER
  def start_process(digits_list, len, i) when (i == length(digits_list)) do
    IO.puts("DONEEEEE")
    []
  end

  def start_process(digits_list, len) do

    {:ok, listener} = Listener.start_link([])

    pids = Enum.map(0..length(digits_list)-1, fn (i) -> ChildWorker.start_link([]) end)
    IO.inspect(pids)
    IO.inspect(listener)
#    {:ok, pids}  = ChildWorker.start_link([])
    Enum.map(0..length(digits_list) - 1, fn(i) ->
      currElem = Enum.at(digits_list, i)
      updatedDigits_list = List.delete_at(digits_list, i)
      {:ok, server_pid} = Enum.fetch!(pids, i)
      ChildWorker.split(server_pid,[len, currElem, updatedDigits_list, server_pid, listener])
    end)
#    ChildWorker.split(pids,[len, currElem, updatedDigits_list, pids, listener])

    Enum.map(0..length(digits_list) - 1, fn(i) ->
      {:ok, pid} = Enum.fetch!(pids, i)
      IO.inspect(pid)
      state_after_exec = :sys.get_state(pid, :infinity)
    end)

    result = Listener.get(listener)
    IO.inspect(result)
    IO.puts("Back Here")

#    IO.puts("Starting GenServer || i = #{i}")
#    Listener.start_link([i | digits_list])

#    IO.puts("Calling queue || i = #{i}")
#    IO.inspect(Listener.queue)
#    IO.puts("Calling Dequeue || i = #{i}")
#    IO.inspect(Listener.dequeue)
#    IO.puts("Calling queue || i = #{i}")
#    IO.inspect(Listener.queue)

  end

  def splitActors(first, last, pid) when last >= first do
    if(first == last) do
      ParentWorker.calculate(pid, first)
      IO.inspect(pid, label: "IS IT REALLY CONCURRENT?")
    else
      mid = (last + first)/2 |> Float.ceil |> :erlang.trunc
      IO.inspect(pid, label: "IN THIS PID")
      {:ok, pworker1_pid} = ParentWorker.start_link([])
      IO.inspect(pworker1_pid, label: "GOING IN")
      Vampire.splitActors(first, (mid - 1),pworker1_pid)

      {:ok, pworker2_pid} = ParentWorker.start_link([])
      IO.inspect(pworker2_pid, label: "GOING IN")
      Vampire.splitActors(mid, last,pworker1_pid)
    end

#    pworker_pids = Enum.map(0..(last - first), fn(i) ->
#      ParentWorker.start_link()
#    end)
    #  IO.inspect(pworker_pids)
    #  IO.inspect(plistener_pid)

#    Enum.map(0..(last - first), fn(i) ->
#      {:ok, parentserver_pid} = Enum.fetch!(pworker_pids, i)
#      #      IO.inspect(parentserver_pid)
#      ParentWorker.calculate(parentserver_pid, (i + first))
#    end)

#    Enum.map(0..(last - first), fn(i) ->
#      {:ok, parentserver_pid} = Enum.fetch!(pworker_pids, i)
#      #    IO.inspect(pworker_pids)
#      state_after_exec = :sys.get_state(parentserver_pid, :infinity)
#    end)
#      IO.puts("hi")

      state_after_exec = :sys.get_state(pid, :infinity)
      IO.inspect(pid, label: "GONNA STOP THIS ")
  end

end