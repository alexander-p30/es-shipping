defmodule EsShipping.Harbor do
  @moduledoc """
  Aggregate module for harbor-related commands.
  """

  alias EsShipping.Command
  alias EsShipping.Harbors.Commands
  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Update
  alias EsShipping.Harbors.Events.Created
  alias EsShipping.Harbors.Events.Updated

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @type harbor_command :: Commands.t()
  @type harbor_event :: Created.t()

  @struct_fields ~w(id name x_pos y_pos is_active)a

  @derive {Jason.Encoder, only: @struct_fields}
  defstruct @struct_fields

  @spec execute(t(), harbor_command()) :: harbor_event() | {:error, atom()}
  def execute(%__MODULE__{id: nil}, %Create{} = command) do
    do_execute(command)
  end

  def execute(%__MODULE__{id: aggregate_id}, %Update{} = command)
      when not is_nil(aggregate_id) and aggregate_id == command.id do
    do_execute(command)
  end

  @spec apply(t(), harbor_event()) :: t()
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

  @spec do_execute(command :: harbor_command()) :: {:ok, harbor_event()} | {:error, atom()}
  defp do_execute(command) do
    case Command.validate(command) do
      {:ok, command} -> Command.to_event(command)
      {:error, changeset} -> {:error, Command.parse_error(changeset)}
    end
  end
end
