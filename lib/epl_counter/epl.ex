defmodule EPLCounter.EPL do

  @behaviour :cowboy_websocket_handler

  ## EPL plugin callbacks

  def start_link(_) do
    {:ok, spawn(
        fn ->
          receive do
            _ -> :ok
          end
        end)
      }
  end

  def init(_) do
    {:ok, []}
  end

  ## :cowboy_websocket_handler callbacks

  def init({:tcp, :http}, _, _) do
    EPLCounter.subscribe()
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_, req, _) do
    {:ok, req, :undefined_state}
  end

  def websocket_handle(_, req, state) do
    data = :epl_json.encode(%{hello: "Elixir"}, "counter")
    {:reply, {:text, data}, req, state}
  end

  def websocket_info({:data, data}, req, state) do
    {:reply, {:text, data}, req, state}
  end

  def websocket_terminate(_, _, _) do
    EPLCounter.unsubscribe()
    :ok
  end
end
