#  Starting File

defmodule Proj1 do

  # Accepting Command Line Arguments
  [first, last] = System.argv
  {first, _} = Integer.parse(first)
  {last, _} = Integer.parse(last)
#  :observer.start()

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

    # Spawn the Main Worker GenServer
    {:ok, worker_pid} = Worker.start_link([])

    # Send the Arguments to Split into Further GenServers
    Worker.splitRange(worker_pid,[first, last, (last - first), worker_pid,listener])

    # Waiting for the Main Worker GenServer to complete the computation
    Process.sleep(1)
    _state_after_exec = :sys.get_state(worker_pid, :infinity)

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
#    Process.sleep(150000)
    IO.puts("CPU time: #{t1} ms Real time: #{t2} ms Ratio time: #{t3}")
  else
    IO.puts("INVALID INPUT. Second Number should be greater than the First Number.")
  end
end