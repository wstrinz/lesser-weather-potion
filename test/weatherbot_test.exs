defmodule WeatherbotTest do
  use ExUnit.Case, async: true
  use Plug.Test

  doctest Weatherbot

  alias Weatherbot.Router

  @opts Router.init([])

  test "responds to greeting" do
    conn = conn(:get, "/hello", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ohai"
  end

  test "fetches some weather" do
    body = URI.encode_query(%{"text" => "wb get_forecast MKX"})
    conn = conn(:post, "/webhook", body)
           |> put_req_header("content-type", "application/x-www-form-urlencoded")
           |> Router.call(@opts)

    assert conn.params["text"]
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ack"
  end
end
