 defmodule ParentWorker do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def calculate(pserver_pid, args) do
#    IO.inspect(args,label: "VALUE")
    GenServer.cast(pserver_pid, {:calculate, args})
  end

  def splitActors(pserver_pid, args) do
    GenServer.cast(pserver_pid, {:splitActors, args})
  end

  def get(listener_pid) do
    GenServer.call(listener_pid, {:get})
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:splitActors, args}, state) do
    [first, last, pid, listener] = args
    first = Caller.scaleUp(first)
    last = Caller.scaleDown(last)
    if(first == last) do
#      IO.inspect(first, label: "SINGLE NUMBER")
      ParentWorker.calculate(pid,[first, listener])
    else
      mid = (last + first)/2 |> Float.ceil |> :erlang.trunc
#      IO.inspect(pid, label: "IN THIS PID")
      {:ok, pworker1_pid} = ParentWorker.start_link([])
#      IO.inspect(pworker1_pid, label: "GOING IN")
      ParentWorker.splitActors(pworker1_pid,[first, mid - 1, pworker1_pid, listener])

      {:ok, pworker2_pid} = ParentWorker.start_link([])
#      IO.inspect(pworker2_pid, label: "GOING IN")
      ParentWorker.splitActors(pworker2_pid,[mid, last, pworker2_pid, listener])
      state_after_exec = :sys.get_state(pworker1_pid, :infinity)
      state_after_exec = :sys.get_state(pworker2_pid, :infinity)
    end
#    IO.inspect(pid, label: "GOING TO STOP THIS ")
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