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

  def sendmsg(msg) do
    msg
    |> chunks_for
    |> List.flatten
    |> Enum.map(&SlackWebhook.send/1)
    |> IO.inspect
  end
end