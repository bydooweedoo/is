defmodule Is.Validators.Map do
  @moduledoc """
  Validation for map.

  ## Examples

      iex> Is.validate(%{a: true}, :map)
      []

      iex> Is.validate(%{a: true}, map: false)
      [{:error, [], "must not be a map"}]

      iex> Is.validate(%{a: true}, map: %{a: :boolean})
      []

      iex> Is.validate(10, map: %{a: :binary})
      [{:error, [], "map: data is not a map or options are invalid"}]

      iex> Is.validate(%{a: true}, map: %{a: :binary})
      [{:error, [:a], "must be a binary"}]

      iex> Is.validate(%{a: "ok"}, map: %{a: :binary})
      []

      iex> Is.validate(%{a: "ok"}, map: %{a: [binary: false]})
      [{:error, [:a], "must not be a binary"}]

      iex> Is.validate(%{a: %{b: %{c: true}}}, map: %{a: %{b: %{c: :boolean}}})
      []

      iex> Is.validate(%{a: %{b: %{c: true}}}, map: %{a: [map: %{b: [map: %{c: :boolean}]}]})
      []

      iex> Is.validate(%{a: %{b: %{c: true}}}, map: %{a: [map: %{b: [map: %{c: [boolean: false]}]}]})
      [{:error, [:a, :b, :c], "must not be a boolean"}]

      iex> Is.validate(%{a: %{b: %{c: true}}}, %{a: %{b: %{c: :binary}, d: :boolean}})
      [{:error, [:a, :b, :c], "must be a binary"}, {:error, [:a, :d], "must be a boolean"}]

  """
  def validate(data, is) when is_boolean(is) do
    case is_map(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be a map"}
      false when is === false -> {:error, "must not be a map"}
    end
  end

  def validate(data, schema) when is_map(data) and is_map(schema) do
    Enum.reduce(schema, [], fn({key, options}, acc) ->
      value = Map.get(data, key)
      acc ++ Is.validate(value, options, [key], true)
    end)
  end

  def validate(_data, _options) do
    {:error, "map: data is not a map or options are invalid"}
  end
end

defimpl Is.AliasType, for: Map do
  def get(_) do
    {:ok, :map}
  end
end
