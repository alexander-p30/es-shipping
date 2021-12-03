defmodule EsShipping.Factory do
  use ExMachina.Ecto, repo: EsShipping.Repo

  use EsShipping.Factory.Harbors
end
