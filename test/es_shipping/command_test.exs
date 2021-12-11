defmodule EsShipping.CommandTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Command

  describe "validate/1" do
    test "return a command struct when it is valid according to its changeset" do
      valid_command = build(:create_harbor)

      assert {:ok, valid_command} == Command.validate(valid_command)
    end

    test "return an invalid changeset when the command is not valid according to its changeset" do
      invalid_command = build(:create_harbor, name: nil)

      assert {:error, %Ecto.Changeset{valid?: false}} = Command.validate(invalid_command)
    end
  end

  describe "parse_error/1" do
    test "raise when changeset is valid" do
      assert_raise ArgumentError, "Only invalid changesets can be parsed for errors.", fn ->
        Command.parse_error(%Ecto.Changeset{valid?: true})
      end
    end

    test "convert changeset error of an invalid field value to a descriptive atom" do
      Enum.each(
        [
          {build(:create_harbor, name: nil), :must_have_name},
          {build(:create_harbor, is_active: nil), :must_have_is_active},
          {build(:create_harbor, x_pos: -1), :x_pos_must_be_higher_than_0},
          {build(:create_harbor, y_pos: nil), :y_pos_must_be_higher_than_0}
        ],
        fn {invalid_command, descriptive_atom} ->
          assert descriptive_atom == invalid_command |> run_validation() |> Command.parse_error()
        end
      )
    end

    test "always convert first changeset error of an invalid field value to a descriptive atom " <>
           "when there are multiple errors" do
      changeset_with_multiple_errors =
        :create_harbor |> build(name: nil, is_active: nil) |> run_validation()

      assert %{name: ["can't be blank"], is_active: ["can't be blank"]} ==
               errors_on(changeset_with_multiple_errors)

      assert :must_have_name == Command.parse_error(changeset_with_multiple_errors)

      changeset_with_multiple_errors =
        :create_harbor |> build(is_active: nil, x_pos: -1) |> run_validation()

      assert %{is_active: ["can't be blank"], x_pos: ["must be greater than or equal to 0"]} ==
               errors_on(changeset_with_multiple_errors)

      assert :x_pos_must_be_higher_than_0 == Command.parse_error(changeset_with_multiple_errors)
    end
  end

  describe "to_event/1" do
    test "return corresponding event with correct data" do
      Enum.each(
        [
          {%{
             id: Ecto.UUID.generate(),
             name: "harbor name",
             is_active: true,
             x_pos: 255,
             y_pos: 64
           }, &build(:create_harbor, &1), &build(:harbor_created, &1)}
        ],
        fn {attrs, build_command_fn, build_event_fn} ->
          assert build_event_fn.(attrs) == Command.to_event(build_command_fn.(attrs))
        end
      )
    end
  end

  defp run_validation(%{} = command),
    do: Command.Validations.get_validator(command).validate(command)
end
