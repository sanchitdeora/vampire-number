defmodule Splitter do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def splitActors(pserver_pid, args) do
    GenServer.cast(pserver_pid, {:splitActors, args})
  end

  def handle_cast({:splitActors, args}, state) do
    [first, last, pid] = args
    if(first == last) do
      IO.inspect(pid, label: "SINGLE NUMBER")
      ParentWorker.calculate(pid,first)
    else
      mid = (last + first)/2 |> Float.ceil |> :erlang.trunc
      IO.inspect(pid, label: "IN THIS PID :1")
      {:ok, pworker1_pid} = ParentWorker.start_link([])
      IO.inspect(pworker1_pid, label: "GOING IN")
      ParentWorker.splitActors(pworker1_pid,[first, mid - 1, pworker1_pid])

      IO.inspect(pid, label: "IN THIS PID :2")
      {:ok, pworker2_pid} = ParentWorker.start_link([])
      IO.inspect(pworker2_pid, label: "GOING IN")
      ParentWorker.splitActors(pworker2_pid,[mid, last, pworker2_pid])
    end
    state_after_exec = :sys.get_state(pid, :infinity)
    IO.inspect(pid, label: "GOING TO STOP THIS ")
    {:noreply, state}
  end
end