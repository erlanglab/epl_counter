defmodule EPLCounter do
  @moduledoc false

  use GenServer

  ## API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def subscribe do
    GenServer.cast(__MODULE__, {:subscribe, self()})
  end

  def unsubscribe do
    GenServer.cast(__MODULE__, {:unsubscribe, self()})
  end

  ## GenServer callbacks

  def init([]) do
    :ok = :epl.subscribe()
    {:ok, %{subscribers: [], counter: 0}}
  end

  def handle_cast({:subscribe, pid}, state) do
    {:noreply, %{state | subscribers: [pid | state.subscribers]}}
  end

  def handle_cast({:unsubscribe, pid}, state) do
    subs = List.delete(state.subscribers, pid)
    {:noreply, %{state | subscribers: subs}}
  end

  def handle_info({:data, _, _}, state) do
    data = :epl_json.encode(%{counter: state.counter}, "counter")
    for sub <- state.subscribers do
      send sub, {:data, data}
    end
    {:noreply, %{state | counter: state.counter + 1}}
  end
end
