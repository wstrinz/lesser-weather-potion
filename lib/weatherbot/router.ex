defmodule Weatherbot.Router do
  use Plug.Router
  use Plug.Debugger, otp_app: :weatherbot

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json, :urlencoded]
  plug :match
  plug :dispatch

  post "/webhook" do
    spawn fn ->
      Weatherbot.WeatherFetcher.daily_and_hourly_forecasts
      |> Weatherbot.SlackSender.sendmsg
    end

    send_resp(conn, 200, ~s({"text":"ok"}))
  end

  get "/hello" do
    send_resp(conn, 200, "ohai")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
