defmodule Weatherbot.SlackSender do
  def chunks_for(msg) do
    if String.length(msg) >= 2000 do
      msg
      |> String.graphemes
      |> Enum.chunk(2000)
      |> Enum.map(&Enum.join/1)
    else
      [msg]
    end
  end

  def post_to_slack(encoded_msg) do
    HTTPoison.post(Application.get_env(:weatherbot, :incoming_slack_webhook), encoded_msg)
  end

  def post_string(msg) do
    Poison.encode!(%{
      "username" => "forecast-bot",
      "icon_emoji" => ":cloud:",
      "text" => msg
      })
    |> post_to_slack
  end

  def sendmsg(msg) do
    msg
    |> chunks_for
    |> List.flatten
    |> Enum.map(&post_string/1)
    |> IO.inspect
  end
end