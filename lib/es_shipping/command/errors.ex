defmodule EsShipping.Command.Errors do
  @moduledoc """
  Resolves error parsing for commands.  
  """

  alias Ecto.Changeset, as: C
  alias EsShipping.Harbors.Commands.CreateHarbor, as: CH

  @spec parse_error(changeset :: Ecto.Changeset.t()) :: atom()
  def parse_error(%C{valid?: true}),
    do: raise(ArgumentError, "Only invalid changesets can be parsed.")

  def parse_error(%C{data: %CH{}, errors: [name: _]}), do: :must_have_name
  def parse_error(%C{data: %CH{}, errors: [is_active: _]}), do: :must_have_is_active
  def parse_error(%C{data: %CH{}, errors: [x_pos: _]}), do: :x_pos_must_be_above_0
  def parse_error(%C{data: %CH{}, errors: [y_pos: _]}), do: :y_pos_must_be_above_0
end
