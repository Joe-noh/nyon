defmodule Nyon.Identities do
  alias Ecto.Multi
  alias Nyon.Repo
  alias Nyon.Identities.{User, TwitterAccount}

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:twitter_account)
  end

  def create_user(%{"name" => name, "display_name" => display_name, "twitter_id" => twitter_id}) do
    Multi.new()
    |> Multi.insert(:user, User.changeset(%User{}, %{name: name, display_name: display_name}))
    |> Multi.run(:twitter_account, fn repo, %{user: user} ->
      user
      |> Ecto.build_assoc(:twitter_account)
      |> TwitterAccount.changeset(%{twitter_id: twitter_id})
      |> repo.insert()
    end)
    |> Repo.transaction()
  end

  def update_user(%User{} = user, %{"display_name" => display_name}) do
    user
    |> User.changeset(%{display_name: display_name})
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
