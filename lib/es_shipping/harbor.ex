defmodule EsShipping.Harbor do
  @moduledoc """
  Harbor state manager.
  """

  alias EsShipping.Command
  alias EsShipping.Harbor.Commands.Create
  alias EsShipping.Harbor.Commands.Get
  alias EsShipping.Harbor.Commands.Update
  alias EsShipping.Harbor.Events.Created
  alias EsShipping.Harbor.Events.Got
  alias EsShipping.Harbor.Events.Updated

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  # TODO: consider changing this error format
  @typep error :: {:validation, Ecto.Changeset.t()} | {:internal, atom()}
  @type command :: Create.t() | Get.t() | Update.t()
  @type command_execution :: {:ok, t()} | {:error, error()}
  @type event :: Created.t() | Updated.t() | Got.t()

  @struct_fields ~w(id name x_pos y_pos is_active)a

  @derive {Jason.Encoder, only: @struct_fields}
  defstruct @struct_fields

  @spec execute(t(), command()) :: event() | {:error, error()}
  def execute(%__MODULE__{id: nil} = aggregate, %Create{} = command),
    do: do_execute(aggregate, command)

  def execute(%__MODULE__{} = aggregate, %Update{} = command)
      when not is_nil(aggregate.id) and aggregate.id == command.id,
      do: do_execute(aggregate, command)

  def execute(%__MODULE__{}, %Update{}), do: {:error, {:internal, :harbor_not_found}}

  def execute(%__MODULE__{} = aggregate, %Get{} = command)
      when aggregate.id == command.id,
      do: do_execute(aggregate, command)

  def execute(%__MODULE__{}, %Get{}), do: {:error, {:internal, :harbor_not_found}}

  @spec apply(t(), event()) :: t()
  def apply(%__MODULE__{} = harbor, %Created{} = event) do
    %__MODULE__{
      harbor
      | id: event.id,
        name: event.name,
        is_active: event.is_active,
        x_pos: event.x_pos,
        y_pos: event.y_pos
    }
  end

  def apply(%__MODULE__{} = harbor, %Updated{} = event) do
    %__MODULE__{
      harbor
      | name: event.name,
        is_active: event.is_active,
        x_pos: event.x_pos,
        y_pos: event.y_pos
    }
  end

  def apply(%__MODULE__{} = harbor, %Got{}), do: harbor

  @spec do_execute(aggregate :: t(), command :: command()) :: {:ok, event()} | {:error, error()}
  defp do_execute(aggregate, command) do
    case Command.validate(command) do
      {:ok, command} -> Command.to_event(command, aggregate)
      {:error, changeset} -> {:error, {:validation, changeset}}
    end
  end
end
