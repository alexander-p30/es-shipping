defmodule EsShipping.Factory.Ships do
  alias EsShipping.Ship
  alias EsShipping.Ship.Commands.{Create, Move}

  defmacro __using__(_) do
    quote do
      def ship_factory do
        %Ship{
          name: "HMS Something",
          is_active: true,
          is_docked: true,
          x_pos: 0,
          y_pos: 0
        }
      end

      def create_ship_factory do
        %Create{
          id: Ecto.UUID.generate(),
          name: "Flying Dutchman",
          is_active: true,
          is_docked: true,
          x_pos: 0,
          y_pos: 0
        }
      end

      def move_ship_factory do
        %Move{
          id: Ecto.UUID.generate(),
          x_pos: 672,
          y_pos: 378,
          received_coordinates: [:x_pos, :y_pos]
        }
      end
    end
  end
end
