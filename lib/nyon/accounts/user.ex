defmodule Nyon.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string

    has_many :posts, Nyon.Notes.Post, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> downcase_email()
    |> validate_name_format()
    |> validate_length(:name, min: 3)
    |> validate_required([:name, :email])
    |> unique_constraint(:email, name: :users_email_index)
  end

  defp downcase_email(changeset) do
    case get_change(changeset, :email, nil) do
      nil ->
        changeset
      email ->
        changeset |> put_change(:email, String.downcase(email))
    end
  end

  defp validate_name_format(changeset) do
    case get_change(changeset, :name, nil) do
      nil ->
        changeset
      name ->
        validate_name_format(changeset, name)
    end
  end

  defp validate_name_format(changeset, name) do
    if String.match?(name, ~r/\A\w+\z/) && !String.match?(name, ~r/\A_+\z/) do
      changeset
    else
      changeset |> add_error(:name, "is invalid format")
    end
  end
end
