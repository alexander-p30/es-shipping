defmodule EsShipping.Harbors.Context do
  @moduledoc """
  Holds functions for manipulating harbors.
  This context can create, update, and delete
  database projections of harbors.
  """

  alias EsShipping.EventSourcing.CommandedApp
  alias EsShipping.Harbor
  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Get
  alias EsShipping.Harbors.Commands.Update

  @typep command_execution :: {:ok, Harbor.t()} | {:error, atom()}

  @spec create_harbor(params :: map()) :: command_execution()
  def create_harbor(params), do: build_and_dispatch(Create, params)

  @spec update_harbor(params :: map()) :: command_execution()
  def update_harbor(params), do: build_and_dispatch(Update, params)

  @spec get_harbor(id :: Ecto.UUID.t()) :: command_execution()
  def get_harbor(id), do: build_and_dispatch(Get, %{id: id})

  @spec build_and_dispatch(command :: module(), params :: map()) ::
          {:ok, Harbor.t()} | {:error, atom()}
  defp build_and_dispatch(command, params) do
    params
    |> adjust_params()
    |> command.new()
    |> CommandedApp.dispatch(returning: :aggregate_state, consistency: :strong)
  end

  @spec adjust_params(params :: map()) :: map()
  defp adjust_params(%{} = params) do
    Map.new(params, fn
      {"" <> _ = k, v} -> {String.to_existing_atom(k), v}
      {k, _} = kv when is_atom(k) -> kv
    end)
  end
end
