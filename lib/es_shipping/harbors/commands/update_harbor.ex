defmodule EsShipping.Harbors.Commands.UpdateHarbor do
  @moduledoc """
  Command for creating harbors.
  """

  @type t :: %__MODULE__{
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  defstruct ~w(name is_active x_pos y_pos)a
end
