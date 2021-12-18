defmodule EsShipping.Harbors.Repository do
  @moduledoc """
  Read model fetching queries.
  """

  import Ecto.Query

  alias EsShipping.Harbors.Projection
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
end
