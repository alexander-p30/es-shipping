defmodule EsShipping.Ship.Commands.CreateTest do
  use EsShipping.DataCase, async: false

  import EsShipping.Factory

  alias EsShipping.Command
  alias EsShipping.Ship.Commands.Create
  alias EsShipping.Ship.Events.Created

  describe "new/1" do
    test "return a create command struct with a generated id" do
      params = %{name: "HMS Ship", is_active: true, x_pos: 13_112, y_pos: 1_029_818}

      assert %Create{
               id: id,
               name: "HMS Ship",
               is_active: true,
               is_docked: true,
               x_pos: 13_112,
               y_pos: 1_029_818
             } = Create.new(params)

      assert Ecto.UUID.cast!(id)
    end
  end

  describe "implementation of validation" do
    setup do
      %{x_pos: x_pos, y_pos: y_pos} = create_ship = build(:create_ship)
      harbor = insert(:harbor_projection, x_pos: x_pos, y_pos: y_pos)
      %{command: create_ship, harbor: harbor}
    end

    test "return create struct when all params are valid", %{command: command, harbor: harbor} do
      assert command.x_pos == harbor.x_pos
      assert command.y_pos == harbor.y_pos
      assert {:ok, command} == Command.validate(command)
    end

    test "return invalid changeset when coordinates are invalid", %{command: command} do
      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               put_in(command.x_pos, -1) |> Command.validate()

      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               put_in(command.y_pos, -1) |> Command.validate()

      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return invalid changeset when coordinates do not match that of an active harbor", ctx do
      ctx = put_in(ctx.command.x_pos, 832)

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} = Command.validate(ctx.command)

      assert %{
               x_pos: ["no active harbor in coordinate pair"],
               y_pos: ["no active harbor in coordinate pair"]
             } ==
               errors_on(changeset)

      ctx = put_in(ctx.command.x_pos, ctx.harbor.x_pos)
      ctx.harbor |> Ecto.Changeset.change(%{is_active: false}) |> EsShipping.Repo.update!()

      assert ctx.command.x_pos == ctx.harbor.x_pos
      assert ctx.command.y_pos == ctx.harbor.y_pos
      assert {:error, %Ecto.Changeset{valid?: false} = changeset} = Command.validate(ctx.command)

      assert %{
               x_pos: ["no active harbor in coordinate pair"],
               y_pos: ["no active harbor in coordinate pair"]
             } ==
               errors_on(changeset)
    end
  end

  describe "implementation of conversion" do
    setup do
      %{command: build(:create_ship)}
    end

    test "return created event", %{command: command} do
      assert %Created{
               id: command.id,
               name: command.name,
               is_active: command.is_active,
               is_docked: command.is_active,
               x_pos: command.x_pos,
               y_pos: command.y_pos
             } == Command.to_event(command, nil)
    end
  end
end
