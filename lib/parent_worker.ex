 defmodule ParentWorker do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def calculate(pserver_pid, num) do
#    IO.inspect(num,label: "VALUE")
    GenServer.cast(pserver_pid, {:calculate, num})
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
    [first, last, pid] = args
    if(first == last) do
#      IO.inspect(pid, label: "SINGLE NUMBER")
      ParentWorker.calculate(pid,first)
    else
      mid = (last + first)/2 |> Float.ceil |> :erlang.trunc
#      IO.inspect(pid, label: "IN THIS PID")
      {:ok, pworker1_pid} = ParentWorker.start_link([])
#      IO.inspect(pworker1_pid, label: "GOING IN")
      ParentWorker.splitActors(pworker1_pid,[first, mid - 1, pworker1_pid])

      {:ok, pworker2_pid} = ParentWorker.start_link([])
#      IO.inspect(pworker2_pid, label: "GOING IN")
      ParentWorker.splitActors(pworker2_pid,[mid, last, pworker2_pid])
      state_after_exec = :sys.get_state(pworker1_pid, :infinity)
      state_after_exec = :sys.get_state(pworker2_pid, :infinity)
    end
#    IO.inspect(pid, label: "GOING TO STOP THIS ")
    {:noreply, state}
  end

  def handle_cast({:calculate, num}, state) do
#    IO.puts("CALCULATE HANDLE CAST")
#    IO.puts(num)
    digits_list = Integer.digits(num)
#    IO.inspect(digits_list)
    numLength = length(digits_list)
    factors_list = []
    if(rem(numLength,2) == 0) do
      #    root = :math.sqrt(num)
      tasks = Enum.map(0..length(digits_list), &Task.async(Caller, :splitFactors, [digits_list, div(numLength,2), &1]))
      factors_list = Enum.map(tasks, &Task.await(&1, 100000))
#      IO.inspect((factors_list))
#          IO.puts("HELLO ")
#      IO.inspect(tasks)
#      IO.puts("hey there again")
#      factors_list = Caller.splitFactors(digits_list, div(numLength,2))
      factors_list = List.flatten(factors_list)
      factors_list = Enum.uniq(factors_list)
      factors_list = Enum.sort(factors_list)
#    Enum.each((factors_list), fn(s) -> IO.puts(s) end)
#      IO.inspect((factors_list))
      IO.inspect((factors_list))
#      IO.inspect(length(factors_list))
#      fang_list = Vampire.calculateVampire(num, factors_list)
#      Enum.each((fang_list), fn(s) -> IO.puts(s) end)
#      IO.inspect(fang_list)
#    Vampire.start_process(digits_list, div(numLength,2))
    else
      IO.puts("Not a Vampire Number")
    end
    {:noreply, state}
  end
end