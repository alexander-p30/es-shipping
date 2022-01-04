defmodule EsShipping.CommandTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Command
  alias EsShipping.Harbor

  describe "validate/1" do
    test "return a command struct when the command values are valid" do
      valid_command = build(:create_harbor)

      assert {:ok, valid_command} == Command.validate(valid_command)
    end

    test "return an invalid changeset when the command values are invalid" do
      invalid_command = build(:create_harbor, name: nil)

      assert {:error, %Ecto.Changeset{valid?: false}} = Command.validate(invalid_command)
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
           }, fn _ -> %Harbor{} end, &build(:create_harbor, &1), &build(:harbor_created, &1)},
          {%{
             id: Ecto.UUID.generate(),
             name: "updated harbor name",
             is_active: false,
             x_pos: 12_038,
             y_pos: 0
           }, fn %{id: id} -> %Harbor{id: id} end, &build(:update_harbor, &1),
           &build(:harbor_updated, &1)},
          {%{
             id: Ecto.UUID.generate(),
             name: "A harbor",
             is_active: false,
             x_pos: 123,
             y_pos: 321
           }, &build(:harbor, &1), &build(:get_harbor, &1), &build(:harbor_got, &1)}
        ],
        fn {attrs, build_aggregate_fn, build_command_fn, build_event_fn} ->
          aggregate = build_aggregate_fn.(attrs)
          command = build_command_fn.(attrs)
          event = build_event_fn.(attrs)

          assert event == Command.to_event(command, aggregate)
        end
      )
    end
  end
end
