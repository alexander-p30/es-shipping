defmodule EsShipping.Harbors.Commands.GetTest do
  use EsShipping.DataCase, async: true

  alias EsShipping.Harbors.Commands.Get

  @id Ecto.UUID.generate()

  describe "new/1" do
    test "return a get command struct with the passed id" do
      assert %Get{id: @id} == Get.new(%{id: @id})
    end
  end
end
