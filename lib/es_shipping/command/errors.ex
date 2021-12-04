defmodule EsShipping.Command.Errors do
  @moduledoc """
  Resolves error parsing for commands.  
  """

  alias Ecto.Changeset, as: C
  alias EsShipping.Harbors.Commands.CreateHarbor, as: CH

  @harbors_field_errors [
    {:name, :must_have_name},
    {:is_active, :must_have_is_active},
    {:x_pos, :x_pos_must_be_higher_than_0},
    {:y_pos, :y_pos_must_be_higher_than_0}
  ]

  @field_errors @harbors_field_errors

  @spec parse_error(changeset :: Ecto.Changeset.t()) :: atom()
  def parse_error(%C{valid?: true}),
    do: raise(ArgumentError, "Only invalid changesets can be parsed.")

  Enum.each(@field_errors, fn {field, error} ->
    def parse_error(%C{data: %CH{}, errors: [{unquote(field), _} | _]}), do: unquote(error)
  end)
end
