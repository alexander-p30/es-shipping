defmodule EsShipping.Ship.Commands.Create do
  @moduledoc false
  use Ecto.Schema

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          is_docked: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID
    field :name, :string

    field :is_active, :boolean
    field :is_docked, :boolean

    field :x_pos, :integer
    field :y_pos, :integer
  end

  @impl true
  def new(%{} = params) do
    %__MODULE__{
      id: Ecto.UUID.generate(),
      name: params[:name],
      is_active: params[:is_active],
      is_docked: true,
      x_pos: params[:x_pos],
      y_pos: params[:y_pos]
    }
  end
end

defimpl EsShipping.Command.Validation, for: EsShipping.Ship.Commands.Create do
  import Ecto.Changeset

  alias Ecto.Changeset
  alias EsShipping.Ship.Commands.Create
  alias EsShipping.Harbor.Repository, as: HarborRepository

  @fields ~w(id name is_active is_docked x_pos y_pos)a

  @spec validate(command :: Create.t()) :: {:ok, Create.t()} | {:error, Ecto.Changeset.t()}
  def validate(command) do
    params = Map.from_struct(command)

    %Create{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_change(:is_docked, &validate_docked_status/2)
    |> validate_number(:x_pos, greater_than_or_equal_to: 0)
    |> validate_number(:y_pos, greater_than_or_equal_to: 0)
    |> validate_harbor_in_position()
    |> case do
      %Changeset{valid?: true} = changeset -> {:ok, apply_changes(changeset)}
      %Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end

  @spec validate_harbor_in_position(changeset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_harbor_in_position(%Ecto.Changeset{valid?: true} = changeset) do
    x_pos = get_change(changeset, :x_pos)
    y_pos = get_change(changeset, :y_pos)

    case HarborRepository.get_by(is_active: true, x_pos: x_pos, y_pos: y_pos) do
      [_harbor] ->
        changeset

      [] ->
        Enum.reduce(
          [:x_pos, :y_pos],
          changeset,
          &add_error(&2, &1, "no active harbor in coordinate pair")
        )
    end
  end

  defp validate_harbor_in_position(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  @spec validate_docked_status(field :: atom(), is_docked? :: boolean()) :: Keyword.t()
  defp validate_docked_status(_, true = _is_docked?), do: []

  defp validate_docked_status(_, false = _is_docked?),
    do: [is_docked: "ship must be docked on creation"]
end

defimpl EsShipping.Command.Conversion, for: EsShipping.Ship.Commands.Create do
  alias EsShipping.Ship
  alias EsShipping.Ship.Commands.Create
  alias EsShipping.Ship.Events.Created

  @spec to_event(command :: Create.t(), aggregate :: Ship.t()) :: Created.t()
  def to_event(command, _) do
    %Created{
      id: command.id,
      name: command.name,
      is_active: command.is_active,
      is_docked: command.is_docked,
      x_pos: command.x_pos,
      y_pos: command.y_pos
    }
  end
end
