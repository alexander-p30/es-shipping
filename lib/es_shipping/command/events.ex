defmodule EsShipping.Command.Events do
  @moduledoc """
  Resolves command to event conversion.
  """

  alias EsShipping.Command
  alias EsShipping.Event

  alias EsShipping.Harbor.Commands.Create, as: CH
  alias EsShipping.Harbor.Commands.Get, as: GH
  alias EsShipping.Harbor.Commands.Update, as: UH
  alias EsShipping.Harbor.Events.Created, as: HC
  alias EsShipping.Harbor.Events.Got, as: HG
  alias EsShipping.Harbor.Events.Updated, as: HU

  @spec from_command(aggregate :: Command.aggregate(), command :: Command.t()) :: Event.t()
  def from_command(_, %CH{} = cmd),
    do: %HC{
      id: cmd.id,
      name: cmd.name,
      is_active: cmd.is_active,
      x_pos: cmd.x_pos,
      y_pos: cmd.y_pos
    }

  def from_command(_, %UH{} = cmd),
    do: %HU{
      id: cmd.id,
      name: cmd.name,
      is_active: cmd.is_active,
      x_pos: cmd.x_pos,
      y_pos: cmd.y_pos
    }

  def from_command(aggregate, %GH{} = cmd),
    do: %HG{
      id: cmd.id,
      name: aggregate.name,
      is_active: aggregate.is_active,
      x_pos: aggregate.x_pos,
      y_pos: aggregate.y_pos
    }
end
