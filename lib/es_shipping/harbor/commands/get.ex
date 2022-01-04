defmodule EsShipping.Harbor.Commands.Get do
  @moduledoc false
  use Ecto.Schema

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{id: Ecto.UUID.t()}

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID
  end

  @impl true
  def new(%{id: id}), do: %__MODULE__{id: id}
end

defimpl EsShipping.Command.Validation, for: EsShipping.Harbor.Commands.Get do
  import Ecto.Changeset

  alias Ecto.Changeset
  alias EsShipping.Harbor.Commands.Get

  @fields ~w(id)a

  @spec validate(command :: Get.t()) :: {:ok, Get.t()} | {:error, Ecto.Changeset.t()}
  def validate(command) do
    params = Map.from_struct(command)

    %Get{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> case do
      %Changeset{valid?: true} = changeset -> {:ok, apply_changes(changeset)}
      %Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end
end

defimpl EsShipping.Command.Conversion, for: EsShipping.Harbor.Commands.Get do
  alias EsShipping.Harbor
  alias EsShipping.Harbor.Commands.Get
  alias EsShipping.Harbor.Events.Got

  @spec to_event(command :: Get.t(), aggregate :: Harbor.t()) :: Got.t()
  def to_event(command, aggregate) do
    %Got{
      id: command.id,
      name: aggregate.name,
      is_active: aggregate.is_active,
      x_pos: aggregate.x_pos,
      y_pos: aggregate.y_pos
    }
  end
end
