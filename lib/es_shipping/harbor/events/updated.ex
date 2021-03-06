defmodule EsShipping.Harbor.Events.Updated do
  @moduledoc false

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          is_active: boolean(),
          x_pos: integer(),
          y_pos: integer(),
          updated_fields: list(atom())
        }

  @derive Jason.Encoder
  defstruct ~w(id name is_active x_pos y_pos updated_fields)a
end
