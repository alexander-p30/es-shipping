defmodule EsShipping.Harbors.CommandsTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Harbors.Commands
  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Update

  setup_all do
    create_command =
      build(:create_harbor,
        id: Ecto.UUID.generate(),
        name: "Hamburg",
        is_active: true,
        x_pos: 0,
        y_pos: 0
      )

    update_command =
      build(:update_harbor,
        name: "Bruges",
        is_active: true,
        x_pos: 12,
        y_pos: 55,
        received_fields: [:name, :is_active, :x_pos, :y_pos]
      )

    %{create_command: create_command, update_command: update_command}
  end

  describe "validate/1 - create command" do
    test "return a valid create command changeset when all params are valid", ctx do
      assert %Ecto.Changeset{valid?: true} = Commands.validate(ctx.create_command)
    end

    test "return an invalid create command changeset when required params are missing" do
      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(%Create{})

      assert %{
               id: ["can't be blank"],
               name: ["can't be blank"],
               is_active: ["can't be blank"],
               x_pos: ["can't be blank"],
               y_pos: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "return an invalid create command changeset when x_pos is invalid", ctx do
      command = %Create{ctx.create_command | x_pos: -1}

      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(command)
      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return an invalid create command changeset when y_pos is invalid", ctx do
      command = %Create{ctx.create_command | y_pos: -1}

      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(command)
      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end
  end

  describe "validate/1 - update command" do
    test "return a valid update command changeset when all params are valid", ctx do
      assert %Ecto.Changeset{valid?: true} = Commands.validate(ctx.update_command)
    end

    test "update command should only validate received fields" do
      assert %Ecto.Changeset{valid?: true} =
               Commands.validate(%Update{
                 name: "A name",
                 x_pos: -123_813,
                 y_pos: -12_983_123,
                 received_fields: [:name]
               })
    end

    test "return an invalid update command changeset when x_pos is invalid" do
      command = %Update{x_pos: -1, received_fields: [:x_pos]}

      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(command)
      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return an invalid update command changeset when y_pos is invalid" do
      command = %Update{y_pos: -1, received_fields: [:y_pos]}

      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(command)
      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end
  end
end
