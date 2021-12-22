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
    {Harbors, [:get], :id, :must_have_an_id}
  ]

  @field_errors @harbors_field_errors

  @typep changeset_data :: %{entity: module(), error_fields: list(atom()), command: atom()}
  @typep error_entity :: module()
  @typep error_commands :: list(atom())
  @typep error_field :: atom()
  @typep error_message :: atom()
  @typep error_specification :: {error_entity(), error_commands(), error_field(), error_message()}
  @typep error_message_list :: list(atom())

  @spec parse(changeset :: C.t()) :: error_message_list()
  def parse(%C{valid?: true}),
    do: raise(ArgumentError, "Only invalid changesets can be parsed for errors.")

  def parse(%C{data: %entity{}, errors: errors, changes: %{command: command}}) do
    changeset_data = %{entity: entity, error_fields: Keyword.keys(errors), command: command}

    Enum.reduce(@field_errors, [], &do_parse(changeset_data, &1, &2))
  end

  @spec do_parse(changeset_data(), error_specification(), error_message_list()) ::
          error_message_list()
  defp do_parse(changeset_data, {err_entity, err_commands, err_field, err_message}, acc) do
    entities_match? = changeset_data.entity == err_entity
    commands_match? = changeset_data.command in err_commands
    fields_match? = err_field in changeset_data.error_fields

    if entities_match? and commands_match? and fields_match?, do: [err_message | acc], else: acc
  end
end
