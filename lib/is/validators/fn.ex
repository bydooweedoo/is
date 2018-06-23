defmodule Is.Validators.Fn do
  @moduledoc ~S"""
  Validation using custom functions.

  ## Examples

      iex> Is.validate(1, fn: &is_number/1)
      []

      iex> Is.validate(true, fn: &is_number/1)
      [{:error, [], "must satisfies &:erlang.is_number/1"}]

      iex> starts_with? = fn(value, prefix) ->
      ...>   if String.starts_with?(value, prefix) do
      ...>     :ok
      ...>   else
      ...>     {:error, "must start with #{inspect prefix}"}
      ...>   end
      ...> end
      iex> Is.validate("https://elixir-lang.org", fn: [starts_with?, "http"])
      []
      iex> Is.validate("elixir-lang.org", fn: [starts_with?, "http"])
      [{:error, [], "must start with \"http\""}]

      iex> Is.validate(12, fn: {1, 2})
      [{:error, [], "fn: options are invalid"}]

  """
  def validate(data, func) when is_function(func) do
    validate(data, [func])
  end

  def validate(data, [func | extra_args]) when is_function(func) do
    case apply(func, [data] ++ extra_args) do
      true -> :ok
      false -> {:error, "must satisfies #{inspect func}"}
      :ok -> :ok
      :break -> :break
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def validate(_data, _options) do
    {:error, "fn: options are invalid"}
  end
end
