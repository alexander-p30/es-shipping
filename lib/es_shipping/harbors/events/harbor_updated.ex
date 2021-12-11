defmodule EsShipping.Harbors.Events.HarborUpdated do
  @moduledoc """
  Events emitted when harbors are created.
  """

  @type t :: %__MODULE__{
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @derive Jason.Encoder
  defstruct ~w(name is_active x_pos y_pos)a
end
