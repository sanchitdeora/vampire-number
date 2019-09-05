defmodule Proj1 do
#STARTING POINT
  [first, last] = System.argv
  {first, _} = Integer.parse(first)
  {last, _} = Integer.parse(last)
#  :observer.start()
  IO.puts(first)
  IO.puts(last)

  :erlang.statistics(:runtime)
  :erlang.statistics(:wall_clock)

  if(last >= first) do
    {:ok, plistener_pid} = ParentListener.start_link()

    #  {:ok, splitter_pid} = Splitter.start_link([])
    {:ok, pworkerMain_pid} = ParentWorker.start_link([])
    IO.inspect(pworkerMain_pid, label: "MAIN ACTOR")
    ParentWorker.splitActors(pworkerMain_pid,[first, last, pworkerMain_pid,plistener_pid])
    #  ParentWorker.calculate(pworkerMain_pid,first)

#    IO.inspect(pworkerMain_pid, label: "WAITING FOR THIS ")
    #  Process.sleep(5000)
    state_after_exec = :sys.get_state(pworkerMain_pid, :infinity)
    IO.inspect(state_after_exec, label: "State After Execution")
    IO.inspect(pworkerMain_pid, label: "GONNA STOP THIS ")

#    state_after_exec1 = :sys.get_state(plistener_pid, :infinity)
#    IO.inspect(state_after_exec1, label: "State After Execution Listener")
      result = ParentListener.get(plistener_pid)
#      IO.inspect(result)
    Enum.map(Map.keys(result), fn(k) ->
      IO.write("#{k} ")
      Enum.map(Map.get(result,k), fn(v) ->
        IO.write("#{v} ")
      end)
      IO.puts("")
    end)
    {_, t1} = :erlang.statistics(:runtime) # CPU time
    {_, t2} = :erlang.statistics(:wall_clock) # Real time
    t3 = if(t1 == 0 || t2 == 0) do
      0
    else
      t1/t2
    end
    IO.puts("CPU time: #{t1} ms Real time: #{t2} ms Ratio time: #{t3}")
  else
    IO.puts("INVALID INPUT. Second Number should be greater than the First Number.")
  end

end