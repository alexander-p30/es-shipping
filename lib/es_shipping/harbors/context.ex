defmodule EsShipping.Harbors.Context do
  @moduledoc """
  Holds functions for manipulating harbors.
  This context can create, update, and delete
  database projections of harbors.
  """

  alias EsShipping.EventSourcing.CommandedApp
  alias EsShipping.Harbor
  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Update

  @spec create_harbor(params :: map()) :: {:ok, Harbor.t()} | {:error, atom()}
  def create_harbor(params) do
    params
    |> Map.put("id", Ecto.UUID.generate())
    |> then(&build_command(Create, &1))
    |> CommandedApp.dispatch(returning: :aggregate_state)
  end

  @spec update_harbor(params :: map()) :: {:ok, Harbor.t()} | {:error, atom()}
  def update_harbor(params) do
    Update
    |> build_command(params)
    |> CommandedApp.dispatch(returning: :aggregate_state)
  end

  @spec build_command(command :: module(), params :: map()) ::
          Create.t()
  defp build_command(Create, params),
    do: %Create{
      id: params["id"],
      name: params["name"],
      is_active: params["is_active"],
      x_pos: params["x_pos"],
      y_pos: params["y_pos"]
    }

  defp build_command(Update, params),
    do: %Update{
      name: params["name"],
      is_active: params["is_active"],
      x_pos: params["x_pos"],
      y_pos: params["y_pos"]
    }
end
