defmodule EsShipping.Ship do
  @moduledoc """
  Ship state manager.
  """

  alias EsShipping.Command
  alias EsShipping.Ship.Commands.Create
  alias EsShipping.Ship.Events.Created

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          is_docked: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @typep error :: {:validation, Ecto.Changeset.t()} | {:internal, atom()}
  @type command :: Create.t()
  @type command_execution :: {:ok, t()} | {:error, error()}
  @type event :: Created.t()

  @struct_fields ~w(id name is_active is_docked x_pos y_pos )a

  @derive {Jason.Encoder, only: @struct_fields}
  defstruct @struct_fields

  @spec execute(t(), command()) :: event() | {:error, error()}
  def execute(%__MODULE__{id: nil} = aggregate, %Create{} = command),
    do: do_execute(aggregate, command)

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

  @spec do_execute(aggregate :: t(), command :: command()) :: {:ok, event()} | {:error, error()}
  defp do_execute(aggregate, command) do
    case Command.validate(command) do
      {:ok, command} -> Command.to_event(command, aggregate)
      {:error, changeset} -> {:error, {:validation, changeset}}
    end
  end
end
