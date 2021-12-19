defmodule EsShipping.Command.Errors do
  @moduledoc """
  Resolves error parsing for commands.  
  """

  alias Ecto.Changeset, as: C
  alias EsShipping.Harbors.Commands, as: Harbors

  @harbors_field_errors [
    {Harbors, [:create, :update], :name, :must_have_name},
    {Harbors, [:create, :update], :is_active, :must_have_is_active},
    {Harbors, [:create, :update], :x_pos, :x_pos_must_be_higher_than_0},
    {Harbors, [:create, :update], :y_pos, :y_pos_must_be_higher_than_0},
    {Harbors, :get, :id, :must_have_an_id}
  ]

  @field_errors @harbors_field_errors

  @spec parse_error(changeset :: C.t()) :: atom()
  def parse_error(%C{valid?: true}),
    do: raise(ArgumentError, "Only invalid changesets can be parsed for errors.")

  Enum.each(@field_errors, fn
    {entity, [_ | _] = commands, field, error} ->
      Enum.each(commands, fn command ->
        def parse_error(%C{
              data: %unquote(entity){},
              errors: [{unquote(field), _} | _],
              changes: %{command: unquote(command)}
            }),
            do: unquote(error)
      end)

    {entity, command, field, error} ->
      def parse_error(%C{
            data: %unquote(entity){},
            errors: [{unquote(field), _} | _],
            changes: %{command: unquote(command)}
          }),
          do: unquote(error)
  end)
end
