defmodule ErllambdaElixirExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :erllambda_elixir_example,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:erllambda, "~> 2.0"},
      {:mix_erllambda, "~> 1.0"},
      {:jiffy, "~> 0.15.2"}
    ]
  end
end
