defmodule EsShipping.Harbor.Projector do
  @moduledoc """
  Projects events to the read model's table
  in database.
  """

  alias EsShipping.EventSourcing.CommandedApp

  use Commanded.Projections.Ecto,
    application: CommandedApp,
    repo: EsShipping.Repo,
    name: :v1_harbors_projector,
    consistency: :strong

  alias EsShipping.Harbor.Events.Created
  alias EsShipping.Harbor.Projection

  project(%Created{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :harbor, %Projection{
      id: event.id,
      name: event.name,
      is_active: event.is_active,
      x_pos: event.x_pos,
      y_pos: event.y_pos
    })
  end)
end
