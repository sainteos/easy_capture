defmodule EasyCapture.Mixfile do
  use Mix.Project

  def project do
    [app: :easy_capture,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      applications: [:logger],
      mod: {EasyCapture, []}
    ]
  end

  defp deps do
    [
      {:ffmpex, "~> 0.5"},
      {:elixir_ale, "~> 1.0"}
    ]
  end
end
