defmodule EsShipping.Factory.Harbors do
  alias EsShipping.Harbor
  alias EsShipping.Harbor.Commands.{Create, Get, Update}
  alias EsShipping.Harbor.Events.{Created, Got, Updated}
  alias EsShipping.Harbor.Projection

  defmacro __using__(_) do
    quote do
      def harbor_factory do
        %Harbor{name: "a name", is_active: true, x_pos: 0, y_pos: 0}
      end

      def harbor_projection_factory do
        %Projection{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }
      end

      def create_harbor_factory do
        %Create{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }
      end

      def harbor_created_factory do
        %Created{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }
      end

      def update_harbor_factory do
        %Update{
          id: Ecto.UUID.generate(),
          name: "some other name",
          is_active: true,
          x_pos: 123,
          y_pos: 987,
          received_fields: ~w(id name is_active x_pos y_pos)a
        }
      end

      def harbor_updated_factory do
        %Updated{
          id: Ecto.UUID.generate(),
          name: "some other name",
          is_active: true,
          x_pos: 123,
          y_pos: 987,
          updated_fields: ~w(id name is_active x_pos y_pos)a
        }
      end

      def get_harbor_factory(attrs),
        do: merge_attributes(%Get{id: Ecto.UUID.generate()}, Map.take(attrs, [:id]))

      def harbor_got_factory do
        event = %Got{
          id: Ecto.UUID.generate(),
          name: "some harbor",
          is_active: false,
          x_pos: 92_347,
          y_pos: 0
        }
      end
    end
  end
end
