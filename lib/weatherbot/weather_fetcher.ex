defmodule Weatherbot.WeatherFetcher do
  @darksky_url "https://api.forecast.io/forecast/#{Application.get_env(:weatherbot, :darksky_key)}/43.063929,-89.414104"

  def get_forecast do
    HTTPoison.get!(@darksky_url).body
    |> Poison.Parser.parse!
  end

  def hourly_forecast do
    get_forecast
    |> Map.get("hourly")
    |> Map.get("summary")
  end

  def daily_forecast do
    get_forecast
    |> Map.get("daily")
    |> Map.get("summary")
  end

  def daily_and_hourly_forecasts do
    ~s"""
    Hourly
    #{hourly_forecast}

    Daily
    #{daily_forecast}
    """
  end
end
