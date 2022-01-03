defmodule EsShipping.Harbor.Commands.GetTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Command
  alias EsShipping.Harbor.Commands.Get

  @id Ecto.UUID.generate()

  describe "new/1" do
    test "return a get command struct with the passed id" do
      assert %Get{id: @id} == Get.new(%{id: @id})
    end
  end

  describe "implementation of validate" do
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
end
