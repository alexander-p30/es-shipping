defmodule EsShipping.CommandTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Command

  describe "validate/1" do
    defmodule ValidCommand do
      defstruct [:a_field]
      def changeset(_ \\ nil, _), do: %Ecto.Changeset{valid?: true}
    end

    defmodule InvalidCommand do
      defstruct []
      def changeset(_ \\ nil, _), do: %Ecto.Changeset{valid?: false}
    end

    test "return a command struct when it is valid according to its changeset" do
      valid_command = %ValidCommand{a_field: :some_value}

      assert {:ok, valid_command} == Command.validate(valid_command)
    end

    test "return an invalid changeset when the command is not valid according to its changeset" do
      invalid_command = %InvalidCommand{}

      assert {:error, %Ecto.Changeset{valid?: false}} = Command.validate(invalid_command)
    end
  end

  describe "parse_error/1" do
    test "raise when changeset is valid" do
      assert_raise ArgumentError, "Only invalid changesets can be parsed.", fn ->
        Command.parse_error(%Ecto.Changeset{valid?: true})
      end
    end

    test "convert changeset error in an invalid field to a descriptive atom" do
      Enum.each(
        [
          {build(:create_harbor, name: nil), :must_have_name},
          {build(:create_harbor, is_active: nil), :must_have_is_active},
          {build(:create_harbor, x_pos: -1), :x_pos_must_be_above_0},
          {build(:create_harbor, y_pos: nil), :y_pos_must_be_above_0}
        ],
        fn {invalid_command, descriptive_atom} ->
          assert descriptive_atom == Command.parse_error(run_changeset(invalid_command))
        end
      )
    end
  end

  describe "to_event/1" do
    test "return corresponding event with correct data" do
      Enum.each(
        [
          {%{name: "harbor name", is_active: true, x_pos: 255, y_pos: 64},
           &build(:create_harbor, &1), &build(:harbor_created, &1)}
        ],
        fn {attrs, build_command_fn, build_event_fn} ->
          assert build_event_fn.(attrs) == Command.to_event(build_command_fn.(attrs))
        end
      )
    end
  end

  defp run_changeset(%command_module{} = command), do: command_module.changeset(command)
end