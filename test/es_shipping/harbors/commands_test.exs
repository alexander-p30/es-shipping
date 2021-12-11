defmodule EsShipping.Harbors.CommandsTest do
  use EsShipping.DataCase, async: true

  alias EsShipping.Harbors.Commands
  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Update

  setup_all do
    create_command = %Create{
      id: Ecto.UUID.generate(),
      name: "Hamburg",
      is_active: true,
      x_pos: 0,
      y_pos: 0
    }

    update_command = %Update{
      name: "Bruges",
      is_active: true,
      x_pos: 12,
      y_pos: 55
    }

    %{create_command: create_command, update_command: update_command}
  end

  describe "validate/1 - create command" do
    test "return a valid create command changeset with an id when all params are valid", ctx do
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
    test "return a valid update command changeset with an id when all params are valid", ctx do
      assert %Ecto.Changeset{valid?: true} = Commands.validate(ctx.update_command)
    end

    test "return an invalid update command changeset when required params are missing" do
      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(%Update{})

      assert %{
               name: ["can't be blank"],
               is_active: ["can't be blank"],
               x_pos: ["can't be blank"],
               y_pos: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "return an invalid update command changeset when x_pos is invalid", ctx do
      command = %Update{ctx.update_command | x_pos: -1}

      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(command)
      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return an invalid update command changeset when y_pos is invalid", ctx do
      command = %Update{ctx.update_command | y_pos: -1}

      assert %Ecto.Changeset{valid?: false} = changeset = Commands.validate(command)
      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end
  end
end
