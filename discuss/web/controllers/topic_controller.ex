defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  def new(conn, _params) do
    IO.puts "++++++"
    IO.inspect conn
    IO.puts "++++++"
    IO.puts _params
    render conn, "new.html"
  end
end