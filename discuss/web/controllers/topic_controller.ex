defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def index(conn, params) do
    IO.inspect conn.assigns
    IO.inspect params
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  # conn represents both incoming and outgoing requests
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset # Here is where we define custom vars to template
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

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
    # case Repo.get(Topic, topic_id) do
    #   {:ok, topic} -> redirect(to: topic_path(conn, :new, changeset: topic))
    #   {:error, changeset} ->
    # end

  end
end