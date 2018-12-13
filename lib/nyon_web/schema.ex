defmodule NyonWeb.Schema do
  use Absinthe.Schema

  import_types NyonWeb.Schema.Objects
  import_types NyonWeb.Schema.IdentityTypes

  query do
    import_fields :identity_queries
  end

  mutation do
    import_fields :identity_mutations
  end
end
