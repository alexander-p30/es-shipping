defmodule EsShipping.Factory.Harbors do
  defmacro __using__(_) do
    quote do
      alias EsShipping.Harbor
      alias EsShipping.Harbors.Commands.Create
      alias EsShipping.Harbors.Commands.Update
      alias EsShipping.Harbors.Events.Created
      alias EsShipping.Harbors.Events.Updated
      alias EsShipping.Harbors.Projection

      def harbor_factory(attrs) do
        harbor = %Harbor{name: "a name", is_active: true, x_pos: 0, y_pos: 0}

        merge_attributes(harbor, attrs)
      end

      def harbor_projection_factory(attrs) do
        projection = %Projection{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }

        merge_attributes(projection, attrs)
      end

      def create_harbor_factory(attrs) do
        command = %Create{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }

        merge_attributes(command, attrs)
      end

      def harbor_created_factory(attrs) do
        event = %Created{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }

        merge_attributes(event, attrs)
      end

      def update_harbor_factory(attrs) do
        command = %Update{
          id: Ecto.UUID.generate(),
          name: "some other name",
          is_active: true,
          x_pos: 123,
          y_pos: 987,
          received_fields: ~w(id name is_active x_pos y_pos)a
        }

        merge_attributes(command, attrs)
      end

      def harbor_updated_factory(attrs) do
        event = %Updated{
          id: Ecto.UUID.generate(),
          name: "some other name",
          is_active: true,
          x_pos: 123,
          y_pos: 987
        }

        merge_attributes(event, attrs)
      end
    end
  end
end
