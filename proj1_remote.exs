#  Starting File

defmodule Proj1Remote do

  # Accepting Command Line Arguments
  [first, last] = System.argv
  {first, _} = Integer.parse(first)
  {last, _} = Integer.parse(last)
  #  :observer.start()

  node_list = [:"mac1@127.0.0.1", "m2@192.168.0.50"] # The address of remote nodes
  num_nodes = length(node_list) # Number of Nodes

  # Generates Node Names
  node_names = Enum.map(0..num_nodes-1, fn (i) ->
    "NodeNo" <> Integer.to_string(i) |> String.to_atom
  end)

  # Scales up the first argument if it is less than 1000
  first =
    if(first < 1000 && last >= 1000) do
      1000
    else
      first
    end

  # Initiates computing CPU Time (Runtime) and Real Time (Wall Clock)
  :erlang.statistics(:runtime)
  :erlang.statistics(:wall_clock)

  if(last >= first) do

    # Start a Listener GenServer
    {:ok, listener} = Listener.start_link([])

    # Spawns the Worker GenServer on all the Remote Nodes in the List using Node Names
    pids = Enum.map(0..num_nodes - 1, fn (i) ->
      node_name = Enum.fetch!(node_names, i)
      :rpc.call(Enum.fetch!(node_list, i), Worker, :start_link, [[name: node_name]])
    end)

    start_points = []
    end_points = []
    mid_points = []

    # Used to split the input data into chunks
    mid_points = if(num_nodes > 1) do
      Enum.map(1..num_nodes - 1, fn (i) ->
        mid = i * (last + first)/(num_nodes) |> Float.ceil |> :erlang.trunc
      end)
      else
        mid_points
    end

    start_points = if(num_nodes > 1) do
      start_points = Enum.map(0..num_nodes - 2, fn (i) ->
        Enum.at(mid_points,i)
      end)
    else
      start_points
    end

    end_points = if(num_nodes > 1) do
      end_points = Enum.map(0..num_nodes - 2, fn (i) ->
        (Enum.at(mid_points,i)-1)
      end)
      else
        end_points
    end

    start_points = List.insert_at(start_points, 0, first)
    end_points = end_points ++ [last]

    # Send the Arguments to Split into Further GenServers on each Remote Node in the List using Node Names
    Enum.map(0..num_nodes-1, fn (i) ->
      first = Enum.fetch!(start_points, i)
      last = Enum.fetch!(end_points, i)
      node_name = Enum.fetch!(node_names, i)
      node = Enum.fetch!(node_list, i)
      {:ok, pid} = Enum.fetch!(pids, i)
      Worker.splitRange({node_name, node}, [first, last, (last - first), pid, listener])
    end)

    # Waiting for the Worker GenServer on all the Remote Nodes in the List to complete the computation
    Enum.map(0..num_nodes-1, fn (i) ->
      {:ok, pid} = Enum.fetch!(pids, i)
      _state_after_exec = :sys.get_state(pid, :infinity)
    end)

    # Getting the final results from the Listener
    result = Listener.get(listener)

    # Prints the Output in the required format
    Enum.map(Map.keys(result), fn(k) ->
      IO.write("#{k} ")
      Enum.map(Map.get(result,k), fn(v) ->
        IO.write("#{v} ")
      end)
      IO.puts("")
    end)

    {_, t1} = :erlang.statistics(:runtime) # CPU time
    {_, t2} = :erlang.statistics(:wall_clock) # Real time

    # To check if the denominator is 0 or not
    t3 = if(t2 == 0) do
      0
    else
      t1/t2
    end
    IO.puts("CPU time: #{t1} ms Real time: #{t2} ms Ratio time: #{t3}")
  else
    IO.puts("INVALID INPUT. Second Number should be greater than the First Number.")
  end
end