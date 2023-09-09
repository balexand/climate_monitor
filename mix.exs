defmodule ClimateMonitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :climate_monitor,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bmp280, "~> 0.2.12"},
      {:req, "~> 0.4.2"}
    ]
  end
end
