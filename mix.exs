defmodule UeberauthPocket.Mixfile do
  use Mix.Project

  @version "1.0.1"

  @url "https://github.com/tsubery/ueberauth_pocket"
  def project do
    [app: :ueberauth_pocket,
     version: @version,
     name: "Ueberauth Pocket",
     package: package(),
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: @url,
     homepage_url: @url,
     description: description(),
     deps: deps(),
     docs: docs()]
  end

  def application do
    [applications: [:logger, :ueberauth, :httpoison]]
  end

  defp deps do
    [{:ueberauth, "~> 0.4"},
     {:httpoison, "~> 0.10.0"},
     {:poison, "~> 3.0.0"},
     {:credo, "~> 0.5", only: [:dev, :test]},
     # docs dependencies
     {:earmark, "~> 0.2", only: :dev},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  defp description do
    "An Ueberauth strategy for using Pocket to authenticate your users."
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Gal Tsubery"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub": @url,
        "Pocket": "https://getpocket.com"
      }]
  end
end
