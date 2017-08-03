defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, params) do
    IO.inspect conn.assigns
    IO.inspect params
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  # conn represents both incoming and outgoing requests
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset # Here is where we define custom vars to template
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
    |> build_assoc(:topics)
    |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
        render conn, "index.html", flash: %{message: "Created!"}
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn,:index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted!")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    IO.puts "hey buddy"
    case Repo.get(Topic, topic_id) do
      topic = %Topic{} ->
        if topic.user_id == conn.assigns.user.id do
          conn
        else
          conn
          |> put_flash(:error, "This is not yours to do")
          |> redirect(to: topic_path(conn, :index))
          |> halt()
        end

      nil ->
        conn
        |> put_flash(:error, "Topic does not exist")
        |> redirect(to: topic_path(conn, :index))
        |> halt()

      {:error} ->
        IO.puts "Error getting topic id"
    end
  end
end