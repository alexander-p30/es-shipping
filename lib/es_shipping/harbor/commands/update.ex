defmodule EsShipping.Harbor.Commands.Update do
  @moduledoc false
  use Ecto.Schema

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          is_active: boolean(),
          x_pos: integer(),
          y_pos: integer(),
          received_fields: list(atom())
        }

  @fields ~w(name is_active x_pos y_pos)a

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID
    field :received_fields, {:array, :string}

    field :name, :string
    field :is_active, :boolean

    field :x_pos, :integer
    field :y_pos, :integer
  end

  @impl true
  def new(%{} = params) do
    %__MODULE__{
      id: params[:id],
      name: params[:name],
      is_active: params[:is_active],
      x_pos: params[:x_pos],
      y_pos: params[:y_pos],
      received_fields: Enum.filter(@fields, &Map.has_key?(params, &1))
    }
  end
end

defimpl EsShipping.Command.Validation, for: EsShipping.Harbor.Commands.Update do
  import Ecto.Changeset

  alias Ecto.Changeset
  alias EsShipping.Harbor.Commands.Update
  alias EsShipping.Harbor.Repository

  @spec validate(command :: Update.t()) :: {:ok, Update.t()} | {:error, Ecto.Changeset.t()}
  def validate(command) do
    params = Map.from_struct(command)

    %Update{}
    |> cast(params, command.received_fields)
    |> validate_required(command.received_fields)
    |> validate_coordinates()
    |> case do
      %Changeset{valid?: true} = changeset ->
        {:ok, changeset |> apply_changes() |> Map.put(:received_fields, command.received_fields)}

      %Changeset{valid?: false} = changeset ->
        {:error, changeset}
    end
  end

  @spec validate_coordinates(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_coordinates(changeset) do
    coordinates = get_coordinates(changeset)

    case Enum.count(coordinates) do
      2 ->
        changeset
        |> validate_number(:x_pos, greater_than_or_equal_to: 0)
        |> validate_number(:y_pos, greater_than_or_equal_to: 0)
        |> validate_unique_position(coordinates)

      1 ->
        present_coordinate = coordinates |> Map.keys() |> List.first()
        add_error(changeset, present_coordinate, "coordinates must come in pairs")

      _ ->
        changeset
    end
  end

  @spec validate_unique_position(changeset :: Ecto.Changeset.t(), coordinates :: map()) ::
          Ecto.Changeset.t()
  defp validate_unique_position(%Changeset{valid?: false} = changeset, _), do: changeset

  defp validate_unique_position(changeset, %{x_pos: x_pos, y_pos: y_pos}) do
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

  @spec get_coordinates(changeset :: Ecto.Changeset.t()) :: map()
  defp get_coordinates(changeset), do: Map.take(changeset.changes, [:x_pos, :y_pos])
end

defimpl EsShipping.Command.Conversion, for: EsShipping.Harbor.Commands.Update do
  alias EsShipping.Harbor
  alias EsShipping.Harbor.Commands.Update
  alias EsShipping.Harbor.Events.Updated

  @spec to_event(command :: Update.t(), aggregate :: Harbor.t()) :: Updated.t()
  def to_event(command, _) do
    %Updated{
      id: command.id,
      name: command.name,
      is_active: command.is_active,
      x_pos: command.x_pos,
      y_pos: command.y_pos
    }
  end
end
