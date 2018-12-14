defmodule Nyon.Identities.TwitterAccount do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Nyon.Identities.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "twitter_accounts" do
    field :twitter_id, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(twitter_account, attrs) do
    twitter_account
    |> cast(attrs, [:twitter_id])
    |> validate_required([:twitter_id])
    |> unique_constraint(:twitter_id)
    |> assoc_constraint(:user, name: :twitter_accounts_user_id_fkey)
  end

  def find_by_twitter_id(twitter_id) do
    __MODULE__
    |> where(twitter_id: ^twitter_id)
    |> Nyon.Repo.one()
  end
end
