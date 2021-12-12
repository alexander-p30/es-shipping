defmodule EsShipping.Harbors.Commands.Create do
  @moduledoc false

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  defstruct ~w(id name is_active x_pos y_pos)a

  @impl true
  def new(%{} = params) do
    %__MODULE__{
      id: Ecto.UUID.generate(),
      name: params[:name],
      is_active: params[:is_active],
      x_pos: params[:x_pos],
      y_pos: params[:y_pos]
    }
  end
end
