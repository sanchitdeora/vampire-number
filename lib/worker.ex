#  Worker GenServer

defmodule Worker do
  use GenServer

  #  CLIENT SIDE
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def calculate(pserver_pid, args) do
    GenServer.cast(pserver_pid, {:calculate, args})
  end

  def splitRange(pserver_pid, args) do
    GenServer.cast(pserver_pid, {:splitRange, args})
  end

  #  SERVER SIDE
  def init(:ok), do: {:ok, %{}}

  def handle_cast({:splitRange, args}, state) do
    [first, last, global_range, pid, listener] = args
    splitRangeWorker(first, last, global_range, pid, listener)
    {:noreply, state}
  end

  defp splitRangeWorker(first, last, global_range, pid, listener) do
    # ScaleUp and ScaleDown removes the odd digit numbers encountered in the range
    first = scaleUp(first)
    last = scaleDown(last)

    # Dynamically generates range with higher number of digits gets a less ranged assigned
    # and vice versa to balance workloads between actors
    local_range = last |> Integer.digits |> length
    local_range = :math.pow(10,local_range - 2 ) |> :erlang.trunc
    range = div(global_range,local_range)

    # Passes the range to Calculate the process range of inputs if less than the assigned range
    if(last - first <= range) do
      # Iteratively passes each number in the range to the current Worker
      Enum.map(first..last, fn(x) ->
        Worker.calculate(pid,[x, listener])
      end)

    # Else it splits the range into two
    else
      mid = (last + first)/2 |> Float.ceil |> :erlang.trunc

      # Spawns a Worker GenServer for the first range
      {:ok, pworker1_pid} = Worker.start_link([])
      Worker.splitRange(pworker1_pid,[first, mid - 1, global_range, pworker1_pid, listener])

      # Recursively Calls the function on the same Worker
      splitRangeWorker(mid, last, global_range, pid, listener)

      state_after_exec = :sys.get_state(pworker1_pid, :infinity)
    end
  end


  def handle_cast({:calculate, args}, state) do
    [num, listener] = args
    digits_list = Integer.digits(num)
    numLength = length(digits_list)
    factors_list = []
#    if(rem(numLength,2) == 0) do

    # Splits Digits of the current Number and Generates Factors
    tasks = Enum.map(0..length(digits_list)-1, &Task.async(Caller, :splitDigits, [digits_list, div(numLength,2), &1]))
    factors_list = Enum.map(tasks, &Task.await(&1, 100000))
    factors_list = List.flatten(factors_list) |> Enum.uniq |> Enum.sort()

    # Generates Fangs of the current Number
    ctasks = Enum.map(0..(length(factors_list)-1), fn(i) ->
      a = Enum.at(factors_list, i)
      rem_factorlist = List.delete_at(factors_list, i)
      Task.async(Caller, :calculateFangs, [num, rem_factorlist, a, 0, (length(rem_factorlist)-1)])
    end)
    fang_list = Enum.map(ctasks, &Task.await(&1, 100000))
    fang_list = fang_list |> List.flatten |> Enum.uniq

    # To check for cases if the Vampire Number is a perfect square
    root = :math.sqrt(num)
    root_int = root |> :erlang.trunc
    root_digits = root_int |> Integer.digits
    if( (root == root_int) && (Enum.member?(factors_list,root_int)) &&
      ( ((root_digits ++ root_digits) |> Enum.sort) == (digits_list |> Enum.sort)) ) do
      fang_list = fang_list ++ [root] ++ [root]
    end

    # If fangs exist, Listener is updated
    if(fang_list != []) do
      Listener.update(listener, [num, fang_list])
    end
#    end
    {:noreply, state}
  end

  # ScaleUp and ScaleDown removes the odd digit numbers encountered in the range
  defp scaleUp(num) do
    num = cond do
      (rem((num |> Integer.digits |> length),2) == 1 ) -> :math.pow(10, (num |> Integer.digits |> length))
      true -> num
    end
    num = num |> :erlang.trunc
  end

  defp scaleDown(num) do
    num = cond do
      (rem((num |> Integer.digits |> length),2) == 1 ) -> (:math.pow(10, (num |> Integer.digits |> length) - 1) - 1)
      true -> num
    end
    num = num |> :erlang.trunc
  end
end