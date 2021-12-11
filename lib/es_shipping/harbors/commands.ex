defmodule EsShipping.Harbors.Commands do
  @moduledoc """
  Harbor-related commands. Exposes functions
  to validate harbor commands.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Update

  @type t() :: Create.t() | Update.t()

  @create_fields ~w(id name is_active x_pos y_pos)a
  @update_fields ~w(name is_active x_pos y_pos)a

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID

    field :name, :string
    field :is_active, :boolean

    field :x_pos, :integer
    field :y_pos, :integer

    field :command, Ecto.Enum, values: ~w(create update)a
  end

  @spec validate(command :: t()) :: Ecto.Changeset.t()
  def validate(%Create{} = command), do: do_validate(command, @create_fields)
  def validate(%Update{} = command), do: do_validate(command, @update_fields)

  @spec do_validate(command :: t(), fields :: list(atom())) :: Ecto.Changeset.t()
  defp do_validate(command, fields) do
    params = Map.from_struct(command)

    %__MODULE__{}
    |> cast(params, fields)
    |> put_command(command)
    |> validate_required(fields)
    |> validate_number(:x_pos, greater_than_or_equal_to: 0)
    |> validate_number(:y_pos, greater_than_or_equal_to: 0)
    |> validate_unique_position()
  end

  @spec put_command(changeset :: Ecto.Changeset.t(), command :: t()) :: Ecto.Changeset.t()
  defp put_command(changeset, %Create{}), do: put_change(changeset, :command, :create)
  defp put_command(changeset, %Update{}), do: put_change(changeset, :command, :update)

  @spec validate_unique_position(changeset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_unique_position(changeset) do
    # TODO: validate if position is unique (will probably need a db query)
    changeset
  end
end