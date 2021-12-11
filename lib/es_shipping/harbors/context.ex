defmodule EsShipping.Harbors.Context do
  @moduledoc """
  Holds functions for manipulating harbors.
  This context can create, update, and delete
  database projections of harbors.
  """

  alias EsShipping.EventSourcing.CommandedApp
  alias EsShipping.Harbor
  alias EsShipping.Harbors.Commands.CreateHarbor

  @spec create_harbor(params :: map()) :: {:ok, Harbor.t()}
  def create_harbor(params) do
    CreateHarbor
    |> build_command(Ecto.UUID.generate(), params)
    |> CommandedApp.dispatch(returning: :aggregate_state)
  end

  @spec build_command(command :: module(), id :: Ecto.UUID.t(), params :: map()) ::
          CreateHarbor.t()
  defp build_command(CreateHarbor, id, params),
    do: %CreateHarbor{
      id: id,
      name: params["name"],
      is_active: params["is_active"],
      x_pos: params["x_pos"],
      y_pos: params["y_pos"]
    }
end
