defmodule EsShipping.Ship.Events.Moved do
  @moduledoc """
  Events emitted when ships coordinates are updated.
  """

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil,
          updated_coordinates: list(atom())
        }

  @derive Jason.Encoder
  defstruct ~w(id x_pos y_pos updated_coordinates)a
end
