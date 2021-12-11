defmodule EsShipping.Harbors.Commands.Create do
  @moduledoc false

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  defstruct ~w(id name is_active x_pos y_pos)a
end
