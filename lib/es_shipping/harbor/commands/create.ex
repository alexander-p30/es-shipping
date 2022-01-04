defmodule EsShipping.Harbor.Commands.Create do
  @moduledoc false
  use Ecto.Schema

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID

    field :name, :string
    field :is_active, :boolean

    field :x_pos, :integer
    field :y_pos, :integer
  end

  @impl true
  def new(%{} = params) do
    %__MODULE__{
      id: Ecto.UUID.generate(),
      name: params[:name],
      is_active: params[:is_active],
      x_pos: params[:x_pos],
      y_pos: params[:y_pos]
    }
  end
end

defimpl EsShipping.Command.Validation, for: EsShipping.Harbor.Commands.Create do
  import Ecto.Changeset

  alias Ecto.Changeset
  alias EsShipping.Harbor.Commands.Create
  alias EsShipping.Harbor.Repository

  @fields ~w(id name is_active x_pos y_pos)a

  @spec validate(command :: Create.t()) :: {:ok, Create.t()} | {:error, Ecto.Changeset.t()}
  def validate(command) do
    params = Map.from_struct(command)

    %Create{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:x_pos, greater_than_or_equal_to: 0)
    |> validate_number(:y_pos, greater_than_or_equal_to: 0)
    |> validate_unique_position()
    |> case do
      %Changeset{valid?: true} = changeset -> {:ok, apply_changes(changeset)}
      %Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end

  @spec validate_unique_position(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_unique_position(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_unique_position(changeset) do
    %{x_pos: x_pos, y_pos: y_pos} = Map.take(changeset.changes, [:x_pos, :y_pos])

    if Repository.unique_position?(x_pos, y_pos) do
      changeset
    else
      Enum.reduce(
        [:x_pos, :y_pos],
        changeset,
        &add_error(&2, &1, "x, y combination already taken")
      )
    end
  end
end

defimpl EsShipping.Command.Conversion, for: EsShipping.Harbor.Commands.Create do
  alias EsShipping.Harbor
  alias EsShipping.Harbor.Commands.Create
  alias EsShipping.Harbor.Events.Created

  @spec to_event(command :: Create.t(), aggregate :: Harbor.t()) :: Created.t()
  def to_event(command, _) do
    %Created{
      id: command.id,
      name: command.name,
      is_active: command.is_active,
      x_pos: command.x_pos,
      y_pos: command.y_pos
    }
  end
end
