defmodule EsShipping.Harbor do
  @moduledoc """
  Aggregate module for harbor-related commands.
  """

  alias EsShipping.Command
  alias EsShipping.Harbors.Commands.CreateHarbor
  alias EsShipping.Harbors.Events.HarborCreated

  @type t :: %__MODULE__{
          name: String.t() | nil,
          is_active: boolean() | nil,
          x_pos: integer() | nil,
          y_pos: integer() | nil
        }

  @type harbor_command :: CreateHarbor.t()
  @type harbor_event :: HarborCreated.t()

  defstruct ~w(name x_pos y_pos is_active)a

  @spec execute(t(), harbor_command()) :: harbor_event() | {:error, atom()}
  def execute(%__MODULE__{name: nil}, %CreateHarbor{} = command) do
    case Command.validate(command) do
      {:ok, command} -> Command.to_event(command)
      {:error, changeset} -> {:error, Command.parse_error(changeset)}
    end
  end
end
