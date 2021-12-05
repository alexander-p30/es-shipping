defmodule EsShipping.EventSourcing.Supervisor do
  @moduledoc """
  Supervisor used for managing event sourcing specific
  applications, such as dependencies applications and
  event handlers.
  """
  use Supervisor

  alias EsShipping.EventSourcing.CommandedApp

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [CommandedApp]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
