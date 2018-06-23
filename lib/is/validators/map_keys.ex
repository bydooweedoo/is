defmodule Is.Validators.MapKeys do
  @moduledoc """
  Validation for map keys.

  ## Examples

      iex> Is.validate(%{a: true}, map_keys: :atom)
      []

      iex> Is.validate(%{"a" => true, "b" => true}, map_keys: [or: [:atom, :binary]])
      []

      iex> Is.validate(%{a: true}, map_keys: :binary)
      [{:error, [], "map_keys: must be a binary"}]

      iex> Is.validate(true, map_keys: :binary)
      [{:error, [], "map_keys: value must be a map"}]

  """
  def validate(data, options) when is_map(data) do
    data
    |> Enum.reduce([], fn({key, _value}, acc) ->
      acc ++ Is.validate(key, options, [], true)
    end)
    |> format_errors()
  end

  def validate(_data, _options) do
    {:error, "map_keys: value must be a map"}
  end

  defp format_errors(errors) do
    Enum.map(errors, fn({:error, path, error}) ->
      {:error, path, "map_keys: #{error}"}
    end)
  end
end
