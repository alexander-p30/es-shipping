defmodule EsShipping.Command do
  @moduledoc """
  Specifies a command that must be followed by every command.
  Holds functions for validating and converting commands.
  """

  alias EsShipping.Command.{Errors, Events}
  alias EsShipping.Event
  alias EsShipping.Harbor

  @doc """
  Changeset for command validation.
  """
  @callback changeset(command :: struct(), params :: struct()) :: Ecto.Changeset.t()

  @type t() :: Harbor.harbor_command()

  @doc """
  Check the command's values validity according to its modules changeset.
  """
  @spec validate(command :: t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def validate(%command_module{} = command) do
    command
    |> command_module.changeset()
    |> case do
      %Ecto.Changeset{valid?: true} -> {:ok, command}
      %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end

  @doc """
  Converts a changeset's first error to an atom message.
  """
  @spec parse_error(changeset :: Ecto.Changeset.t()) :: atom()
  defdelegate parse_error(changeset), to: Errors

  @doc """
  Converts a command to its corresponding event.
  """
  @spec to_event(command :: t()) :: Event.t()
  def to_event(command), do: Events.from_command(command)
end
