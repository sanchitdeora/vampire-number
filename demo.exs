defmodule Demo do
  [first, last] = System.argv
  {first, _} = Integer.parse(first)
  {last, _} = Integer.parse(last)
#  :observer.start()
  IO.puts(first)
  IO.puts(last)

  :erlang.statistics(:runtime)
  :erlang.statistics(:wall_clock)
  {:ok, plistener_pid} = ParentListener.start_link([])

#  {:ok, splitter_pid} = Splitter.start_link([])
  {:ok, pworkerMain_pid} = ParentWorker.start_link([])
  IO.inspect(pworkerMain_pid, label: "MAIN ACTOR")
  ParentWorker.splitActors(pworkerMain_pid,[first, last, pworkerMain_pid])
#  ParentWorker.calculate(pworkerMain_pid,first)
  {_, t1} = :erlang.statistics(:runtime) # CPU time
  {_, t2} = :erlang.statistics(:wall_clock) # Real time
  IO.inspect(pworkerMain_pid, label: "WAITING FOR THIS ")
#  Process.sleep(5000)
  state_after_exec = :sys.get_state(pworkerMain_pid, :infinity)
  IO.inspect(state_after_exec, label: "State After Execution")
  IO.inspect(pworkerMain_pid, label: "GONNA STOP THIS ")

  IO.puts("CPU time: #{t1} ms Real time: #{t2} ms ")
#  result = Listener.get(listener)
#  IO.inspect(result)
#  IO.puts("Back Here")
end