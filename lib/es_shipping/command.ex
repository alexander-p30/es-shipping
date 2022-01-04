defmodule EsShipping.Command do
  @moduledoc """
  Specifies a command that must be followed by every command.
  Holds functions for validating and converting commands.
  """

  alias EsShipping.Command.{Conversion, Validation}
  alias EsShipping.Event
  alias EsShipping.{Harbor, Ship}

  @type t() :: Harbor.command() | Ship.command()
  @type aggregate() :: Harbor.t() | Ship.t()

  @doc """
  Builds a command with the received parameters.
  """
  @callback new(params :: map()) :: t()

  @doc """
  Check the command's values validity.
  """
  @spec validate(command :: t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  defdelegate validate(command), to: Validation

  @doc """
  Converts a command to its corresponding event(s).
  """
  @spec to_event(command :: t(), aggregate :: aggregate()) :: Event.t()
  defdelegate to_event(command, aggregate), to: Conversion
end
