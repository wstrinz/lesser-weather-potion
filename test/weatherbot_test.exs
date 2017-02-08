defmodule WeatherbotTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Plug.Test

  doctest Weatherbot

  alias Weatherbot.Router
  alias Weatherbot.WeatherFetcher, as: WF

  @opts Router.init([])

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "responds to greeting" do
    conn = conn(:get, "/hello", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ohai"
  end

  test "fetches some weather" do
    use_cassette "forecast_discussion" do
      body = URI.encode_query(%{"text" => "wb get_forecast MKX"})
      conn = conn(:post, "/webhook", body)
             |> put_req_header("content-type", "application/x-www-form-urlencoded")
             |> Router.call(@opts)

      assert conn.params["text"]
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == ~s({"text":"ok"})
    end
  end

  test "fetches hourly weather" do
    use_cassette "forecastio" do
      assert WF.hourly_forecast == "Partly cloudy until tomorrow morning."
    end
  end

  test "fetches daily weather" do
    use_cassette "forecastio" do
      assert WF.daily_forecast == "No precipitation throughout the week, with temperatures rising to 48°F on Tuesday."
    end
  end
end
