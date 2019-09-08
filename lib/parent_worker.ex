defmodule ParentWorker do
  use GenServer

  #  CLIENT SIDE
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def calculate(pserver_pid, args) do
    #    IO.inspect(args,label: "VALUE")
    GenServer.cast(pserver_pid, {:calculate, args})
  end

  def splitActors(pserver_pid, args) do
    GenServer.cast(pserver_pid, {:splitActors, args})
  end

  #  SERVER SIDE
  def init(state), do: {:ok, state}

  def splitActorWork(first, last, global_range, pid, listener) do
    first = Caller.scaleUp(first)
    last = Caller.scaleDown(last)
    #    IO.inspect([first | last], label: "FIRST and LAST")
    local_range = last |> Integer.digits |> length
    #    IO.inspect(local_range, label: "DIGITS")
    local_range = :math.pow(10,local_range - 2 ) |> :erlang.trunc
    #    IO.inspect([local_range | global_range], label: "LOCAL RANGE")
    range = div(global_range,local_range)
    #    IO.inspect([[first | last] | range])
    if(last - first <= range) do
      Enum.map(first..last, fn(x) ->
        #       IO.inspect([[[x | pid] | first] | last], label: "SINGLE NUMBER")
        ParentWorker.calculate(pid,[x, listener])
      end)
    else
      mid = (last + first)/2 |> Float.ceil |> :erlang.trunc

      {:ok, pworker1_pid} = ParentWorker.start_link([])
      ParentWorker.splitActors(pworker1_pid,[first, mid - 1, global_range, pworker1_pid, listener])

      #      {:ok, pworker2_pid} = ParentWorker.start_link([])
      #      ParentWorker.splitActors(pworker2_pid,[mid, last, global_range, pworker2_pid, listener])
      splitActorWork(mid, last, global_range, pid, listener)

      state_after_exec = :sys.get_state(pworker1_pid, :infinity)
      #      state_after_exec = :sys.get_state(pworker2_pid, :infinity)
    end
  end

  def handle_cast({:splitActors, args}, state) do
    [first, last, global_range, pid, listener] = args
    splitActorWork(first, last, global_range, pid, listener)
    {:noreply, state}
  end

  def handle_cast({:calculate, args}, state) do
    [num, listener] = args
    #    IO.puts("CALCULATE HANDLE CAST")
    #    IO.puts(num)
    digits_list = Integer.digits(num)
    #    IO.inspect(digits_list)
    numLength = length(digits_list)
    factors_list = []
    if(rem(numLength,2) == 0) do
      tasks = Enum.map(0..length(digits_list)-1, &Task.async(Caller, :splitFactors, [digits_list, div(numLength,2), &1]))
      factors_list = Enum.map(tasks, &Task.await(&1, 100000))

      factors_list = List.flatten(factors_list) |> Enum.uniq |> Enum.sort()
      #      IO.inspect((factors_list))
      #      IO.inspect(length(factors_list))

      ctasks = Enum.map(0..(length(factors_list)-1), fn(i) ->
        a = Enum.at(factors_list, i)
        rem_factorlist = List.delete_at(factors_list, i)
        Task.async(Caller, :calculateVampire, [num, rem_factorlist, a, 0, (length(rem_factorlist)-1)])
      end)
      fang_list = Enum.map(ctasks, &Task.await(&1, 100000))

      fang_list = fang_list |> List.flatten |> Enum.uniq
      root = :math.sqrt(num)
      root_int = root |> :erlang.trunc
      root_digits = root_int |> Integer.digits
      if( (root == root_int) && (Enum.member?(factors_list,root_int)) &&
        ( ((root_digits ++ root_digits) |> Enum.sort) == (digits_list |> Enum.sort)) ) do
        #        IO.puts("ROOT EXIST for #{num}")
        fang_list = fang_list ++ [root] ++ [root]
      end
      if(fang_list != []) do
        Listener.update(listener, [num, fang_list])
      end
    end
    {:noreply, state}
  end
end