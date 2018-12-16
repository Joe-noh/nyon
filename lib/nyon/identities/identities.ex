defmodule Nyon.Identities do
  require Ecto.Query

  alias Ecto.Multi
  alias Nyon.Repo
  alias Nyon.Identities.{User, TwitterAccount}

  def get_user!(id) do
    User |> Repo.get!(id)
  end

  def get_twitter_account(twitter_id) do
    TwitterAccount
    |> Ecto.Query.where(twitter_id: ^twitter_id)
    |> Repo.one()
    |> Repo.preload(:user)
  end

  def create_user(params = %{"twitter_id" => twitter_id}) do
    case get_twitter_account(twitter_id) do
      nil ->
        do_create_user(params)

      account ->
        user = account |> Ecto.assoc(:user) |> Repo.one()
        {:ok, user}
    end
  end

  defp do_create_user(%{
         "name" => name,
         "display_name" => display_name,
         "twitter_id" => twitter_id,
         "avatar_url" => avatar_url
       }) do
    Multi.new()
    |> Multi.insert(
      :user,
      User.changeset(%User{}, %{
        name: name,
        display_name: display_name,
        avatar_url: avatar_url
      })
    )
    |> Multi.run(:twitter_account, fn repo, %{user: user} ->
      user
      |> Ecto.build_assoc(:twitter_account)
      |> TwitterAccount.changeset(%{twitter_id: twitter_id})
      |> repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} ->
        {:ok, user}

      {:error, _failed, changeset, _changes} ->
        {:error, changeset}
    end
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
