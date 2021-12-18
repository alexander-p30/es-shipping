defmodule EsShipping.Harbors.Projection do
  @moduledoc false

  use Ecto.Schema

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          x_pos: non_neg_integer(),
          y_pos: non_neg_integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "harbors" do
    field :name, :string
    field :is_active, :boolean

    field :x_pos, :integer
    field :y_pos, :integer

    timestamps()
  end
end
