defmodule EsShipping.Harbors.Projection do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "harbors" do
    field :name, :string
    field :is_active, :boolean

    field :x_pos, :integer
    field :y_pos, :integer

    timestamps()
  end
end
