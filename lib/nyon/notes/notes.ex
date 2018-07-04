defmodule Nyon.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false
  alias Nyon.Repo

  alias Nyon.Notes.Post

  def list_posts do
    Post
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
