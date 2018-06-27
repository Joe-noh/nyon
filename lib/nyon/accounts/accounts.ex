defmodule Nyon.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Nyon.Repo

  alias Nyon.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    with {token, attrs} = Map.pop(attrs, "token"),
         magic_link = get_magic_link_by_token!(token) do
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    else
      error -> {:error, error}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Nyon.Accounts.MagicLink

  @doc """
  Returns the list of magic_links.

  ## Examples

      iex> list_magic_links()
      [%MagicLink{}, ...]

  """
  def list_magic_links do
    Repo.all(MagicLink)
  end

  @doc """
  Gets a single magic_link.

  Raises `Ecto.NoResultsError` if the Magic link does not exist.

  ## Examples

      iex> get_magic_link!(123)
      %MagicLink{}

      iex> get_magic_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_magic_link_by_token!(token) do
    now = NaiveDateTime.utc_now()

    MagicLink
    |> where([m], m.token == ^token)
    |> where([m], m.expired_at > ^now)
    |> order_by([m], desc: m.inserted_at)
    |> first()
    |> Repo.one!
  end

  @doc """
  Creates a magic_link.

  ## Examples

      iex> create_magic_link(%{field: value})
      {:ok, %MagicLink{}}

      iex> create_magic_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_magic_link(attrs \\ %{}) do
    %MagicLink{}
    |> MagicLink.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a magic_link.

  ## Examples

      iex> update_magic_link(magic_link, %{field: new_value})
      {:ok, %MagicLink{}}

      iex> update_magic_link(magic_link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_magic_link(%MagicLink{} = magic_link, attrs) do
    magic_link
    |> MagicLink.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MagicLink.

  ## Examples

      iex> delete_magic_link(magic_link)
      {:ok, %MagicLink{}}

      iex> delete_magic_link(magic_link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_magic_link(%MagicLink{} = magic_link) do
    Repo.delete(magic_link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking magic_link changes.

  ## Examples

      iex> change_magic_link(magic_link)
      %Ecto.Changeset{source: %MagicLink{}}

  """
  def change_magic_link(%MagicLink{} = magic_link) do
    MagicLink.changeset(magic_link, %{})
  end
end
