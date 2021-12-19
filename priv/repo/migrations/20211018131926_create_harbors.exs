defmodule EsShipping.Repo.Migrations.Creates do
  use Ecto.Migration

  def change do
    create table(:harbors) do
      add :name, :string

      add :x_pos, :integer
      add :y_pos, :integer

      add :is_active, :boolean

      timestamps()
    end

    create constraint(:harbors, :positive_x_pos,
             check: "x_pos >= 0",
             comment: "Assures x position is at least 0"
           )

    create constraint(:harbors, :positive_y_pos,
             check: "y_pos >= 0",
             comment: "Assures y position is at least 0"
           )

    create unique_index(:harbors, [:x_pos, :y_pos], where: "is_active")
  end
end
