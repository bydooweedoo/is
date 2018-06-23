defmodule Is.Validators.With do
  @moduledoc """
  Test returned value against validators.

  ## Examples

      iex> Is.validate(10, with: [&is_number/1, equals: true])
      []

      iex> Is.validate(10, with: [&(&1 * 2), in_range: [min: 30, max: 50]])
      [{:error, [], "must be between 30 and 50 inclusive"}]

  """
  def validate(data, [func, options]) when is_function(func) do
    Is.validate(func.(data), options)
  end

  def validate(_data, _options) do
    {:error, "with: options must be a list [function, validators]"}
  end
end
