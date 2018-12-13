defmodule NyonWeb.Schema.Objects do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, non_null(:string)
  end
end
