defmodule NyonWeb.Router do
  use NyonWeb, :router

  forward "/graphql", Absinthe.Plug,
    schema: NyonWeb.Schema,
    json_codec: Phoenix.json_library()

  if Mix.env() == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: NyonWeb.Schema,
      interface: :simple,
      json_codec: Phoenix.json_library()
  end
end
