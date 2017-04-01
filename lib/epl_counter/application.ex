defmodule EPLCounter.Application do
  @moduledoc false

  def start(_, _) do
    import Supervisor.Spec, warn: false

    children = [
      worker(EPLCounter, [])
    ]

    opts = [strategy: :one_for_one, name: EPLCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
