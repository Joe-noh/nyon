defmodule NyonWeb.Schema.IdentityTypes do
  use Absinthe.Schema.Notation

  alias NyonWeb.IdentityResolver

  object :identity_queries do
    field :user, :user do
      arg :id, type: non_null(:id)

      resolve &IdentityResolver.find_user/3
    end
  end

  object :identity_mutations do
    field :create_user, type: :user do
      arg :name, non_null(:string)

      resolve &IdentityResolver.create_user/3
    end
  end
end
