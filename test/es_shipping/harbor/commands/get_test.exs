defmodule EsShipping.Harbor.Commands.GetTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Command
  alias EsShipping.Harbor.Commands.Get
  alias EsShipping.Harbor.Events.Got

  @id Ecto.UUID.generate()

  describe "new/1" do
    test "return a get command struct with the passed id" do
      assert %Get{id: @id} == Get.new(%{id: @id})
    end
  end

  describe "implementation of validation" do
    setup do
      %{command: build(:get_harbor)}
    end

    test "return get struct when all params are valid", %{command: command} do
      assert {:ok, command} == Command.validate(command)
    end

    test "return invalid changeset when id is invalid" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Command.validate(%Get{})
      assert {:error, %Ecto.Changeset{valid?: false}} = Command.validate(%Get{id: "some string"})
    end
  end

  describe "implementation of conversion" do
    setup do
      harbor = build(:harbor)
      %{command: build(:get_harbor, id: harbor.id), harbor: harbor}
    end

    test "return got event", %{command: command, harbor: harbor} do
      assert %Got{
               id: command.id,
               name: harbor.name,
               is_active: harbor.is_active,
               x_pos: harbor.x_pos,
               y_pos: harbor.y_pos
             } == Command.to_event(command, harbor)
    end
  end
end
