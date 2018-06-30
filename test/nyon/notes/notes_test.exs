defmodule Nyon.NotesTest do
  use Nyon.DataCase

  alias Nyon.{Notes, Accounts}

  describe "posts" do
    alias Nyon.Notes.Post

    @post_attrs %{body: "Hello World"}
    @user_attrs %{name: "john_doe", email: "hello@example.com"}

    setup do
      {:ok, user} = Accounts.create_user(@user_attrs)

      %{user: user}
    end

    test "get_post!/1 returns the post with given id", %{user: user} do
      {:ok, post} = Notes.create_post(user, @post_attrs)
      assert Notes.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post", %{user: user} do
      assert {:ok, %Post{} = post} = Notes.create_post(user, %{body: "Hello"})
      assert post.body == "Hello"
    end

    test "create_post/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Notes.create_post(user, %{body: ""})
    end

    test "delete_post/1 deletes the post", %{user: user} do
      {:ok, post} = Notes.create_post(user, @post_attrs)
      assert {:ok, %Post{}} = Notes.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset", %{user: user} do
      {:ok, post} = Notes.create_post(user, @post_attrs)
      assert %Ecto.Changeset{} = Notes.change_post(post)
    end
  end
end
