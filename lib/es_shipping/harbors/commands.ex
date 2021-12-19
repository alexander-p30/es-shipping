defmodule EsShipping.Harbors.Commands do
  @moduledoc """
  Harbor-related commands. Exposes functions
  to validate harbor commands.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Get
  alias EsShipping.Harbors.Commands.Update
  alias EsShipping.Harbors.Repository

  @type t() :: Create.t() | Update.t() | Get.t()

  @create_fields ~w(id name is_active x_pos y_pos)a
  @get_fields ~w(id)a

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID

    field :name, :string
    field :is_active, :boolean

    field :x_pos, :integer
    field :y_pos, :integer

    field :command, Ecto.Enum, values: ~w(create update get)a
  end

  @spec validate(command :: t()) :: Ecto.Changeset.t()
  def validate(%Create{} = command) do
    command
    |> init_changeset(@create_fields)
    |> validate_common_fields()
  end

  def validate(%Update{received_fields: [_ | _]} = command) do
    command
    |> init_changeset(command.received_fields)
    |> validate_common_fields()
  end

  def validate(%Get{} = command), do: init_changeset(command, @get_fields)

  @spec init_changeset(command :: t(), cast_fields :: list(atom())) :: Ecto.Changeset.t()
  defp init_changeset(command, cast_fields), do: init_changeset(command, cast_fields, cast_fields)

  @spec init_changeset(
          command :: t(),
          cast_fields :: list(atom()),
          required_fields :: list(atom())
        ) :: Ecto.Changeset.t()
  defp init_changeset(command, cast_fields, required_fields) do
    params = Map.from_struct(command)

    %__MODULE__{}
    |> cast(params, cast_fields)
    |> validate_required(required_fields)
    |> put_command(command)
  end

  @spec validate_common_fields(chagneset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_common_fields(changeset) do
    changeset
    |> validate_number(:x_pos, greater_than_or_equal_to: 0)
    |> validate_number(:y_pos, greater_than_or_equal_to: 0)
    |> validate_unique_position()
  end

  @spec put_command(changeset :: Ecto.Changeset.t(), command :: t()) :: Ecto.Changeset.t()
  defp put_command(changeset, %Create{}), do: put_change(changeset, :command, :create)
  defp put_command(changeset, %Get{}), do: put_change(changeset, :command, :get)
  defp put_command(changeset, %Update{}), do: put_change(changeset, :command, :update)

  @spec validate_unique_position(changeset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_unique_position(%Ecto.Changeset{valid?: true} = changeset) do
    [x_pos: get_change(changeset, :x_pos), y_pos: get_change(changeset, :y_pos), is_active: true]
    |> Repository.get_by()
    |> case do
      [] ->
        changeset

      _ ->
        Enum.reduce(
          [:x_pos, :y_pos],
          changeset,
          &add_error(&2, &1, "x, y combination already taken")
        )
    end
  end

  defp validate_unique_position(changeset), do: changeset
end
