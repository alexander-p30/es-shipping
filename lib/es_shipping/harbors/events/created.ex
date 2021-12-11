defmodule EsShipping.Harbors.Events.Created do
  @moduledoc """
  Events emitted when harbors are created.
  """

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @derive Jason.Encoder
  defstruct ~w(id name is_active x_pos y_pos)a
end
