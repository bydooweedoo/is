defmodule Is.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :is,
      version: "1.0.0",
      elixir: "~> 1.6",
      description: "Fast, extensible and easy to use data structure validation with nested structures support.",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive],#[plt_add_deps: true],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
      ],
      package: package(),
      source_url: "https://github.com/bydooweedoo/is",
      docs: [
        main: "Is",
        groups_for_modules: groups_for_modules(),
      ],
    ]
  end

  def package() do
    [
      name: "is",
      licenses: ["MIT"],
      maintainers: ["Rémi Marek"],
      links: %{"GitHub" => "https://github.com/bydooweedoo/is"},
      source_url: "https://github.com/bydooweedoo/is",
    ]
  end

  def groups_for_modules() do
    [
      "Validators": [
        Is.Validators.And,
        Is.Validators.Atom,
        Is.Validators.Binary,
        Is.Validators.Boolean,
        Is.Validators.Equals,
        Is.Validators.Fn,
        Is.Validators.If,
        Is.Validators.InRange,
        Is.Validators.Inclusion,
        Is.Validators.Integer,
        Is.Validators.Length,
        Is.Validators.List,
        Is.Validators.Map,
        Is.Validators.MapKeys,
        Is.Validators.Number,
        Is.Validators.Optional,
        Is.Validators.Or,
        Is.Validators.Tuple,
        Is.Validators.Validator,
        Is.Validators.With,
      ],
      "Protocols": [
        Is.AliasType,
        Is.Validators.Length.Of,
      ],
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
      {:benchee, "~> 0.13", only: :dev},
      {:benchee_csv, "~> 0.8", only: :dev},
      {:benchee_html, "~> 0.5", only: :dev},
      {:credo, "~> 0.9", only: :dev},
      {:dialyxir, "~> 0.5", only: :dev},
      {:ex_doc, "~> 0.18", only: :dev},
      {:excoveralls, "~> 0.8", only: :test},
      {:remix, "~> 0.0.2", only: :dev},
    ]
  end
end
