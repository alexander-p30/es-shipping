defmodule EsShipping.Command do
  @moduledoc """
  Specifies a command that must be followed by every command.
  Holds functions for validating and converting commands.
  """

  alias EsShipping.Command.{Errors, Events, Validations}
  alias EsShipping.Event
  alias EsShipping.Harbors.Commands, as: HarborsCommands

  @type t() :: HarborsCommands.t()

  @doc """
  Check the command's values validity according to its validation changeset.
  """
  @spec validate(command :: t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  defdelegate validate(command), to: Validations

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
