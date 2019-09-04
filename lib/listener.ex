#  VAMPIRE NUMBER CALCULATION USING GENSERVERs

defmodule Listener do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def update(listener_pid, result) do
    GenServer.call(listener_pid, {:update, result})
  end

  def get(listener_pid) do
    GenServer.call(listener_pid, {:get})
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:update, result}, _from, state) do
    state = state ++ result
    IO.inspect(state)
    {:reply, result, state}
  end

end