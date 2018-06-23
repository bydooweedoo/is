defmodule Is.Validators.List do
  @moduledoc ~S"""
  Validation for list.

  ## Examples

      iex> Is.validate([], :list)
      []

      iex> Is.validate([], list: false)
      [{:error, [], "must not be a list"}]

      iex> Is.validate(["a", "b", "c"], list: :binary)
      []

      iex> Is.validate(%{value: ["a", true, "c"]}, map: %{value: [list: [or: [:binary, :boolean]]]})
      []

      iex> Is.validate(%{value: ["a", true, 1]}, map: %{value: [list: [or: [:binary, :boolean]]]})
      [{:error, [:value, 2], "must satisfies at least one of conditions [:binary, :boolean]"}]

      iex> Is.validate(["a", 1, 2], list: [binary: false])
      [{:error, [0], "must not be a binary"}]

      iex> Is.validate(["a", "b", :c], list: :binary)
      [{:error, [2], "must be a binary"}]

      iex> Is.validate([%{ok: true}, %{ok: true}, %{ok: false}], list: [map: %{ok: [equals: true]}])
      [{:error, [2, :ok], "must equals true"}]

      iex> Is.validate("test", unknown: true)
      {:error, "Validator :unknown does not exist"}

  """
  def validate(data, is) when is_boolean(is) do
    case is_list(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be a list"}
      false when is === false -> {:error, "must not be a list"}
    end
  end

  def validate(values, schema) when is_list(values) do
    Enum.reduce(values, {0, []}, fn(value, {index, acc}) ->
      {index + 1, acc ++ Is.validate(value, schema, [index], true)}
    end)
    |> elem(1)
  end

  def validate(_values, _schema) do
    {:error, "must be a list"}
  end
end

# defimpl Is.AliasType, for: List do
#   def get([]) do
#     {:ok, :list}
#   end

#   def get([options]) do
#     {:ok, :list, options}
#   end

#   def get(options) do
#     {:ok, :list, [{:or, options}]}
#   end
# end
