defmodule EsShipping.Harbors.Commands.CreateHarbor do
  @moduledoc """
  Command for creating harbors.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @castable_fields ~w(name is_active x_pos y_pos)a

  embedded_schema do
    field :name, :string
    field :is_active, :boolean

    field :x_pos, :integer
    field :y_pos, :integer
  end

  @spec changeset(command :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(command \\ %__MODULE__{}, params) do
    params = Map.from_struct(params)

    command
    |> cast(params, @castable_fields)
    |> validate_required(@castable_fields)
    |> validate_number(:x_pos, greater_than_or_equal_to: 0)
    |> validate_number(:y_pos, greater_than_or_equal_to: 0)
    |> validate_unique_position()
  end

  @spec validate_unique_position(changeset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_unique_position(changeset) do
    changeset
  end
end
