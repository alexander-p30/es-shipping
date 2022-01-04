defmodule EsShipping.Repo.Migrations.CreateShips do
  use Ecto.Migration

  def change do
    create table(:ships) do
      add :name, :string

      add :is_active, :boolean
      add :is_docked, :boolean

      add :x_pos, :integer
      add :y_pos, :integer

      timestamps()
    end

    create constraint(:ships, :positive_x_pos,
             check: "x_pos >= 0",
             comment: "Assures x position is at least 0"
           )

    create constraint(:ships, :positive_y_pos,
             check: "y_pos >= 0",
             comment: "Assures y position is at least 0"
           )
  end
end
