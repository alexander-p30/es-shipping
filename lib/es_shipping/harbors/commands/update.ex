defmodule EsShipping.Harbors.Commands.Update do
  @moduledoc false

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          is_active: boolean(),
          x_pos: integer(),
          y_pos: integer(),
          received_fields: list(atom())
        }

  @fields ~w(name is_active x_pos y_pos)a

  defstruct [:id, :received_fields | @fields]

  @impl true
  def new(%{} = params) do
    %__MODULE__{
      id: params[:id],
      name: params[:name],
      is_active: params[:is_active],
      x_pos: params[:x_pos],
      y_pos: params[:y_pos],
      received_fields: Enum.filter(@fields, &Map.has_key?(params, &1))
    }
  end
end
