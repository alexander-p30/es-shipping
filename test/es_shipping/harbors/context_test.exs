defmodule EsShipping.Harbors.ContextTest do
  use EsShipping.DataCase, async: false

  import EsShipping.Factory

  alias EsShipping.EventSourcing.CommandedApp
  alias EsShipping.Harbor
  alias EsShipping.Harbors.Context
  alias EsShipping.Harbors.Projection
  alias EsShipping.Repo

  describe "create_harbor/1" do
    setup do
      %{params: json_params_for(:create_harbor)}
    end

    test "return an aggregate state when params are valid", %{params: params} do
      %{"name" => name, "is_active" => is_active, "x_pos" => x_pos, "y_pos" => y_pos} = params

      assert {:ok,
              %Harbor{
                id: id,
                name: ^name,
                is_active: ^is_active,
                x_pos: ^x_pos,
                y_pos: ^y_pos
              }} = Context.create_harbor(params)

      assert Ecto.UUID.cast!(id)
    end

    test "persist read model projection in database", %{params: params} do
      assert {:ok, %Harbor{} = harbor} = Context.create_harbor(params)

      projection = Repo.one(Projection)

      assert Map.from_struct(harbor) ==
               Map.take(projection, [:id, :name, :is_active, :x_pos, :y_pos])

      assert_in_delta NaiveDateTime.diff(projection.inserted_at, NaiveDateTime.utc_now()), 0, 1
      assert_in_delta NaiveDateTime.diff(projection.updated_at, NaiveDateTime.utc_now()), 0, 1
    end

    test "return invalid changeset when name is invalid", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               params |> Map.put("name", nil) |> Context.create_harbor()

      assert %{name: ["can't be blank"]} == errors_on(changeset)
    end

    test "return invalid changeset when active status is invalid", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               params |> Map.put("is_active", nil) |> Context.create_harbor()

      assert %{is_active: ["can't be blank"]} == errors_on(changeset)
    end

    test "return invalid changeset when x_pos is invalid", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               params |> Map.put("x_pos", -40) |> Context.create_harbor()

      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return invalid changeset when y_pos is invalid", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               params |> Map.put("y_pos", -1_273_182) |> Context.create_harbor()

      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end
  end

  describe "update_harbor/1" do
    setup do
      {:ok, %{id: "" <> _} = harbor} =
        CommandedApp.dispatch(
          build(:create_harbor,
            id: Ecto.UUID.generate(),
            name: "Victoria",
            is_active: true,
            x_pos: 444,
            y_pos: 888
          ),
          returning: :aggregate_state
        )

      update_params =
        json_params_for(:update_harbor,
          id: harbor.id,
          name: "New York",
          x_pos: 1402,
          y_pos: 9991
        )

      %{harbor: harbor, params: update_params}
    end

    test "return an aggregate state when params are valid", ctx do
      %{"name" => name, "x_pos" => x_pos, "y_pos" => y_pos} = ctx.params

      assert {:ok,
              %Harbor{
                id: id,
                name: ^name,
                is_active: true,
                x_pos: ^x_pos,
                y_pos: ^y_pos
              }} = Context.update_harbor(ctx.params)

      assert id == ctx.harbor.id
    end

    test "return invalid changeset when name is invalid", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               Context.update_harbor(%{"id" => params["id"], "name" => nil})

      assert %{name: ["can't be blank"]} == errors_on(changeset)
    end

    test "return invalid changeset when active status is invalid", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               Context.update_harbor(%{"id" => params["id"], "is_active" => nil})

      assert %{is_active: ["can't be blank"]} == errors_on(changeset)
    end

    test "return invalid changeset when x_pos is present but y_pos not", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               Context.update_harbor(%{"id" => params["id"], "x_pos" => -3})

      assert %{x_pos: ["coordinates must come in pairs"]} == errors_on(changeset)
    end

    test "return invalid changeset when y_pos is present but x_pos not", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               Context.update_harbor(%{"id" => params["id"], "y_pos" => -321})

      assert %{y_pos: ["coordinates must come in pairs"]} == errors_on(changeset)
    end

    test "return invalid changeset when x_pos or y_pos are invalid", %{params: params} do
      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               Context.update_harbor(%{"id" => params["id"], "x_pos" => 123, "y_pos" => -321})

      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)

      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               Context.update_harbor(%{"id" => params["id"], "x_pos" => -123, "y_pos" => 321})

      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return internal error when id is not associated with any harbor" do
      assert {:error, {:internal, :harbor_not_found}} ==
               Context.update_harbor(%{"id" => Ecto.UUID.generate()})
    end
  end

  describe "get_harbor/1" do
    setup do
      {:ok, harbor} =
        CommandedApp.dispatch(
          build(:create_harbor,
            id: Ecto.UUID.generate(),
            name: "Victoria",
            is_active: true,
            x_pos: 444,
            y_pos: 888
          ),
          returning: :aggregate_state
        )

      %{harbor: harbor}
    end

    test "return harbor with requested id", %{harbor: harbor} do
      assert {:ok, harbor} == Context.get_harbor(harbor.id)
    end

    test "return internal error when id is not associated with any harbor" do
      assert {:error, {:internal, :harbor_not_found}} ==
               Context.get_harbor(Ecto.UUID.generate())
    end
  end
end
