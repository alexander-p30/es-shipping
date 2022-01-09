defmodule EsShipping.Ship.Commands.Move do
  @moduledoc """
  Command for updating a ship's position.
  """
  use Ecto.Schema

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil,
          received_coordinates: list(atom())
        }

  @fields ~w(x_pos y_pos)a

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID

    field :x_pos, :integer
    field :y_pos, :integer

    field :received_coordinates, {:array, :string}
  end

  @impl true
  def new(%{} = params) do
    %__MODULE__{
      id: params[:id],
      x_pos: params[:x_pos],
      y_pos: params[:y_pos],
      received_coordinates: Enum.filter(@fields, &Map.has_key?(params, &1))
    }
  end
end

defimpl EsShipping.Command.Validation, for: EsShipping.Ship.Commands.Move do
  import Ecto.Changeset

  alias Ecto.Changeset
  alias EsShipping.Ship.Commands.Move

  @spec validate(command :: Move.t()) :: {:ok, Move.t()} | {:error, Ecto.Changeset.t()}
  def validate(%{received_coordinates: received_coordinates} = command) do
    params = Map.from_struct(command)

    %Move{}
    |> cast(params, [:id | received_coordinates])
    |> validate_required(received_coordinates)
    |> validate_coordinates(received_coordinates)
    |> case do
      %Changeset{valid?: true} = changeset ->
        {:ok,
         changeset
         |> apply_changes()
         |> Map.put(:received_coordinates, received_coordinates)}

      %Changeset{valid?: false} = changeset ->
        {:error, changeset}
    end
  end

  @spec validate_coordinates(Ecto.Changeset.t(), list(atom())) :: Ecto.Changeset.t()
  defp validate_coordinates(changeset, received_coordinates) do
    Enum.reduce(received_coordinates, changeset, fn coordinate, changeset ->
      validate_number(changeset, coordinate, greater_than_or_equal_to: 0)
    end)
  end
end

defimpl EsShipping.Command.Conversion, for: EsShipping.Ship.Commands.Move do
  alias EsShipping.Ship
  alias EsShipping.Ship.Commands.Move
  alias EsShipping.Ship.Events.Moved

  @spec to_event(command :: Move.t(), aggregate :: Ship.t()) :: Moved.t()
  def to_event(%{received_coordinates: received_coordinates} = command, aggregate) do
    ~w(x_pos y_pos)a
    |> Enum.reduce(%Moved{}, fn field, event ->
      data_origin = if field in received_coordinates, do: command, else: aggregate
      Map.put(event, field, Map.fetch!(data_origin, field))
    end)
    |> Map.put(:updated_coordinates, received_coordinates)
    |> Map.put(:id, aggregate.id)
  end
end
