defmodule EsShipping.Command do
  @moduledoc """
  Specifies a command that must be followed by every command.
  Holds functions for validating and converting commands.
  """

  alias EsShipping.Command.{Events, Validation}
  alias EsShipping.Event
  alias EsShipping.Harbor

  @type t() :: Harbor.command()
  @type aggregate() :: Harbor.t()

  @doc """
  Builds a command with the received parameters.
  """
  @callback new(params :: map()) :: t()

  @doc """
  Check the command's values validity according to its validation changeset.
  """
  @spec validate(command :: t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  defdelegate validate(command), to: Validation

  @doc """
  Converts a command to its corresponding event.
  """
  @spec to_event(aggregate :: aggregate(), command :: t()) :: Event.t()
  def to_event(aggregate, command), do: Events.from_command(aggregate, command)
end
