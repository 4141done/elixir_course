defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
    
  end

  # _params here is what is returned from init/1
  # Must return a connection
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user) # Puts in conn.assigns
      true ->
        assign(conn, :user, nil) # Returns a conn
    end
  end
end