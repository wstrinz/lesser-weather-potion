defmodule Weatherbot.WeatherFetcher do
  @url_base "http://forecast.weather.gov/product.php?site=CRH&product=AFD&issuedby="
  @forecastio_url "https://api.forecast.io/forecast/#{Application.get_env(:weatherbot, :forecastio_key)}/43.063929,-89.414104"
  @default_station "MKX"

  def url_for_site(site_code) do
    "#{@url_base}#{site_code}"
  end

  def get_forecast_discussion(site_code) do
    HTTPoison.get!(url_for_site(site_code)).body
  end

  def get_forecast_discussion do
    get_forecast_discussion(@default_station)
  end

  def get_forecast do
    HTTPoison.get!(@forecastio_url).body
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

  def parsed_forecast(forecast_body) do
    forecast_body
    |> Floki.parse
    |> Floki.find("pre.glossaryProduct")
    |> Floki.text
  end

  def forecast_sections(forecast_body) do
    parsed_forecast(forecast_body)
    |> String.split("&&")
    |> Enum.map(&String.strip/1)
  end

  def remove_ignored_sections(sections, ignore_list) do
    sections
    |> Enum.reject(fn sect -> Enum.any?(ignore_list, fn ig -> String.contains?(sect, ig) end) end)
  end

  def get_section_list(code, ignore_list) do
    get_forecast_discussion(code)
    |> forecast_sections
    |> remove_ignored_sections(ignore_list)
  end

  def run do
    get_section_list(@default_station, @section_ignore_strings)
    |> Weatherbot.SlackInterface.send_sections
  end
end
