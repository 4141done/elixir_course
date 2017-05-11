defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic
  # conn represents both incoming and outgoing requests
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset # Here is where we define custom vars to template
  end

  def create(conn, params) do
    IO.inspect params
  end
end