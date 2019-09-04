#  VAMPIRE NUMBER CALCULATION USING GENSERVER

defmodule ChildWorker do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def split(server_pid, args) do
    IO.puts("Inside Split")
    IO.inspect(server_pid)
    GenServer.cast(server_pid, {:split, args})
  end

  def generate(server_pid, args) do
    IO.puts("Inside Create")
    IO.inspect(server_pid)
    GenServer.cast(server_pid, {:generate, args})
  end

  def dequeue, do: GenServer.call(__MODULE__, :dequeue)

  def handle_cast({:split, args}, state) do
    [len, elem, updatedDigits_list, server_pid, listener] = args
    IO.puts("Inside Split Handle Cast")
    IO.inspect(server_pid)
#    if((((elem |> Integer.digits() |> length()) + 1) == len) && elem != 0) do
      generate(server_pid, [len, elem, updatedDigits_list, server_pid, listener])
#    end
    {:noreply, state}
  end

  def handle_cast({:generate, args}, state) do
    [len, elem, modDigits_list, server_pid, listener] = args
    IO.puts("Inside Create Handle Cast")
    IO.inspect(server_pid)
    state = Enum.map(0..length(modDigits_list)-1, fn(i) -> (elem * 10) + Enum.at(modDigits_list, i) end)
    IO.inspect(state)
    Listener.update(listener, state)
    {:noreply, state}
  end

  def handle_call(:queue, _from, state) do
    {:reply, state, state}
  end

end

