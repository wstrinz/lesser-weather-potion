defmodule Weatherbot.SlackReceiver do
  @default_ignore_list ~w{AVIATION... MARINE... .AVIATION .MARINE}

  def handle_forecast_request([code | _otherstuff]) do
    Weatherbot.WeatherFetcher.get_section_list(code, @default_ignore_list)
    |> Enum.join("\n")
  end

  def help_msg do
    "Usage: `get_forecast <city_code>`"
  end

  def response_for_parsed_message([ cmd | rest]) do
    case cmd do
      "get_forecast" -> handle_forecast_request(rest)
      _ -> help_msg
    end
  end

  def parse_message(msg) do
    pieces = msg
    |> String.split(" ")
    |> Enum.slice(1..-1)
  end

  def handle_message(msg) do
    msg["text"]
    |> parse_message
    |> response_for_parsed_message
    |> Weatherbot.SlackSender.sendmsg
  end
end