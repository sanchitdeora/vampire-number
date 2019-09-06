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

  def handle_cast({:splitActors, args}, state) do
    [first, last, range, pid, listener] = args
    first = Caller.scaleUp(first)
    last = Caller.scaleDown(last)

    if(last - first <= range) do
      Enum.map(first..last, fn(x) ->
        #       IO.inspect([[[x | pid] | first] | last], label: "SINGLE NUMBER")
        ParentWorker.calculate(pid,[x, listener])
      end)
    else
      mid = (last + first)/2 |> Float.ceil |> :erlang.trunc

      {:ok, pworker1_pid} = ParentWorker.start_link([])
      ParentWorker.splitActors(pworker1_pid,[first, mid - 1, range, pworker1_pid, listener])

      {:ok, pworker2_pid} = ParentWorker.start_link([])
      ParentWorker.splitActors(pworker2_pid,[mid, last, range, pworker2_pid, listener])

      state_after_exec = :sys.get_state(pworker1_pid, :infinity)
      state_after_exec = :sys.get_state(pworker2_pid, :infinity)
    end
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
        IO.puts("ROOT EXIST for #{num}")
        fang_list = fang_list ++ [root] ++ [root]
      end
      if(fang_list != []) do
        ParentListener.update(listener, [num, fang_list])
      end
    end
    {:noreply, state}
  end
end