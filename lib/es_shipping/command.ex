defmodule EsShipping.Command do
  @moduledoc """
  Specifies a command that must be followed by every command.
  Holds functions for validating and converting commands.
  """

  alias EsShipping.Command.{Errors, Events, Validations}
  alias EsShipping.Event
  alias EsShipping.Harbor
  alias EsShipping.Harbors.Commands, as: HarborsCommands

  @type t() :: HarborsCommands.t()
  @type aggregate() :: Harbor.t()

  @doc """
  Builds a command with the received parameters.
  """
  @callback new(params :: map()) :: t()

  @doc """
  Check the command's values validity according to its validation changeset.
  """
  @spec validate(command :: t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  defdelegate validate(command), to: Validations

  @doc """
  Converts a changeset's first error to an atom message.
  """
  @spec parse_errors(changeset :: Ecto.Changeset.t()) :: list(atom())
  def parse_errors(changeset), do: Errors.parse(changeset)

  @doc """
  Converts a command to its corresponding event.
  """
  @spec to_event(aggregate :: aggregate(), command :: t()) :: Event.t()
  def to_event(aggregate, command), do: Events.from_command(aggregate, command)
end
