defmodule EsShipping.Command.Events do
  @moduledoc """
  Resolves command to event conversion.
  """

  alias EsShipping.Command
  alias EsShipping.Event

  alias EsShipping.Harbors.Commands.Create, as: CH
  alias EsShipping.Harbors.Commands.Update, as: UH
  alias EsShipping.Harbors.Events.Created, as: HC
  alias EsShipping.Harbors.Events.Updated, as: HU

  @spec from_command(command :: Command.t()) :: Event.t()
  def from_command(%CH{} = cmd),
    do: %HC{
      id: cmd.id,
      name: cmd.name,
      is_active: cmd.is_active,
      x_pos: cmd.x_pos,
      y_pos: cmd.y_pos
    }

  def from_command(%UH{} = cmd),
    do: %HU{
      name: cmd.name,
      is_active: cmd.is_active,
      x_pos: cmd.x_pos,
      y_pos: cmd.y_pos
    }
end
