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

  alias EsShipping.Harbor.Events.{Created, Updated}
  alias EsShipping.Harbor.Projection

  project(%Created{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :create_harbor, %Projection{
      id: event.id,
      name: event.name,
      is_active: event.is_active,
      x_pos: event.x_pos,
      y_pos: event.y_pos
    })
  end)

  project(%Updated{updated_fields: updated_fields} = event, _metadata, fn multi ->
    params = Map.from_struct(event)

    Ecto.Multi.update(multi, :update_harbor, fn _ ->
      updated_fields
      |> Map.new(fn field ->
        field = String.to_existing_atom(field)
        {field, Map.fetch!(params, field)}
      end)
      |> then(&Ecto.Changeset.change(%Projection{id: event.id}, &1))
    end)
  end)
end
