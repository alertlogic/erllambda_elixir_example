defmodule MicroserviceHttpEndpointElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :microservice_http_endpoint_elixir,
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
      {:erllambda, git: "git@github.com:alertlogic/erllambda.git"},
      {:mix_erllambda, git: "git@github.com:alertlogic/mix_erllambda.git"},
      {:jiffy, "~> 0.15.2"}
    ]
  end
end
