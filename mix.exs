defmodule Weatherbot.Mixfile do
  use Mix.Project

  def project do
    [app: :weatherbot,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :plug, :httpoison],
     mod: {Weatherbot, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:slack_webhook, "~> 0.1.0"},
     {:poison, "~> 3.0"},
     {:exvcr, "~> 0.8"},
     {:floki, "~> 0.11.0"},
     {:dialyxir, "~> 0.4", only: [:dev], runtime: false},
     {:poison, "~> 3.0"}]
  end
end
