defmodule ParentListener do
  use GenServer

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def update(listener_pid, args) do
    GenServer.call(listener_pid, {:update, args})
  end

  def get(listener_pid) do
    GenServer.call(listener_pid, {:get})
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:update, args}, _from, state) do
    [num, fang_list] = args
    state = Map.put(state,num, fang_list)
#    IO.inspect(state)
    {:reply, state, state}
  end
end
