defmodule EsShipping.HarborTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Harbor

  @attrs %{
    id: Ecto.UUID.generate(),
    name: "Sydney harbor",
    is_active: true,
    x_pos: 238,
    y_pos: 101_010
  }

  setup_all do
    %{command: build(:create_harbor, @attrs), event: build(:harbor_created, @attrs)}
  end

  describe "execute/2" do
    test "return harbor created event when create harbor command is valid", ctx do
      assert ctx.event == Harbor.execute(%Harbor{}, ctx.command)
    end

    test "return an error atom when create harbor command is invalid", ctx do
      ctx = put_in(ctx.command.name, nil)
      assert {:error, :must_have_name} == Harbor.execute(%Harbor{}, ctx.command)
    end

    test "raise when identity field is not nil and command is create harbor", ctx do
      assert_raise FunctionClauseError, fn ->
        Harbor.execute(%Harbor{id: Ecto.UUID.generate()}, ctx.command)
      end
    end
  end

  describe "apply/2" do
    test "return a mutated harbor struct with event attributes", ctx do
      mutated_harbor = %Harbor{
        id: ctx.event.id,
        name: ctx.event.name,
        is_active: ctx.event.is_active,
        x_pos: ctx.event.x_pos,
        y_pos: ctx.event.y_pos
      }

      assert mutated_harbor == Harbor.apply(%Harbor{}, ctx.event)
      assert mutated_harbor == Harbor.apply(%Harbor{name: "some name"}, ctx.event)
    end
  end
end
