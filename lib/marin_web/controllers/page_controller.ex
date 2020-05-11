defmodule MarinWeb.PageController do
  use MarinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
