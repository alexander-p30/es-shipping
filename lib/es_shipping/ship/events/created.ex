defmodule EsShipping.Ship.Events.Created do
  @moduledoc """
  Events emitted when ships are created.
  """

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          is_docked: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @derive Jason.Encoder
  defstruct ~w(id name is_active is_docked x_pos y_pos)a
end
