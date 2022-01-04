defmodule EsShipping.Factory do
  use ExMachina.Ecto, repo: EsShipping.Repo

  use EsShipping.Factory.Harbors
  use EsShipping.Factory.Ships

  @spec json_params_for(factory :: atom(), attrs :: map() | Keyword.t(), opts :: Keyword.t()) ::
          map()
  def json_params_for(factory, attrs \\ %{}, opts \\ [])

  def json_params_for(factory, attrs, opts) when is_atom(factory) do
    factory
    |> build(attrs)
    |> Map.from_struct()
    |> to_json()
    |> drop_unwanted_fields()
    |> apply_opts(opts)
  end

  def to_json(v) when is_struct(v), do: to_json(Map.from_struct(v))
  def to_json(%{} = map), do: Map.new(map, fn {k, v} -> {to_json(k), to_json(v)} end)
  def to_json(v) when is_boolean(v), do: v
  def to_json(v) when is_atom(v), do: "#{v}"
  def to_json(v) when not is_tuple(v), do: v

  defp drop_unwanted_fields(data), do: Map.drop(data, [:received_fields])

  defp apply_opts(data, [{:id, _} | opts]) do
    if opts[:id] do
      apply_opts(data, opts)
    else
      apply_opts(Map.drop(data, ["id"]), opts)
    end
  end

  defp apply_opts(data, []), do: data
end
