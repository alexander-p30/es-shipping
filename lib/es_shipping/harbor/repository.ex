defmodule EsShipping.Harbor.Repository do
  @moduledoc """
  Read model fetching queries.
  """

  import Ecto.Query

  alias EsShipping.Harbor.Projection
  alias EsShipping.Repo

  @spec get_by(fields :: Keyword.t() | map()) :: list(Projection.t())
  def get_by(fields) do
    fields
    |> Enum.reduce(Projection, fn
      {col, nil}, query -> where(query, [harbor], harbor |> field(^col) |> is_nil())
      params, query -> where(query, ^[params])
    end)
    |> Repo.all()
  end

  @spec unique_position?(x_pos :: non_neg_integer(), y_pos :: non_neg_integer()) :: boolean()
  def unique_position?(x_pos, y_pos) do
    active_harbor_in_position_exists? =
      Projection
      |> where(is_active: true, x_pos: ^x_pos, y_pos: ^y_pos)
      |> limit(1)
      |> Repo.exists?()

    not active_harbor_in_position_exists?
  end
end
