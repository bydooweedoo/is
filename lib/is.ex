defmodule Is do
  @moduledoc ~S"""
  Fast, extensible and easy to use data structure validation with nested structures support.
  """

  alias Is.{AliasType, Validator, Validators}

  @validators_map Validator.to_map(
    Application.get_env(:is, :validators, Validators.get_default())
  )

  @doc ~S"""
  Validate data with schema and return list of errors.

  ## Examples

      iex> validate(true, :boolean)
      []

      iex> validate(true, boolean: true)
      []

      iex> validate(true, boolean: false)
      [{:error, [], "must not be a boolean"}]

      iex> validate(true, or: [:boolean, :atom])
      []

      iex> validate(:ok, or: [:boolean, :atom])
      []

      iex> data = Enum.map(1..10, &(%{
      ...>   a: "a",
      ...>   b: true,
      ...>   c: ["a", "b", false],
      ...>   d: [[1, 2, 3], [4, 5, 6]],
      ...>   index: &1,
      ...> }))
      iex> schema = [list: [map: %{
      ...>   a: :binary,
      ...>   b: :boolean,
      ...>   c: [list: [or: [:binary, :boolean]]],
      ...>   d: [list: [list: :integer]],
      ...>   e: [and: [:optional, :binary]],
      ...>   index: [and: [:integer, in_range: [min: 0]]],
      ...> }]]
      iex> validate(data, schema)
      []

      iex> data = Enum.map(1..2, &(%{
      ...>   a: 1,
      ...>   b: "b",
      ...>   c: {"a", "b", false},
      ...>   d: [[1, 2, "3"], [4, false, 6]],
      ...>   e: -1,
      ...>   f: "1234567891011",
      ...>   index: &1 - 10,
      ...> }))
      iex> schema = [list: [map: %{
      ...>   a: :binary,
      ...>   b: :boolean,
      ...>   c: [list: [or: [:binary, :boolean]]],
      ...>   d: [list: [list: :integer]],
      ...>   e: [and: [:optional, :binary]],
      ...>   index: [and: [:integer, in_range: [min: 0]]],
      ...> }]]
      iex> validate(data, schema)
      [
        {:error, [0, :a], "must be a binary"},
        {:error, [0, :b], "must be a boolean"},
        {:error, [0, :c], "must be a list"},
        {:error, [0, :d, 0, 2], "must be an integer"},
        {:error, [0, :d, 1, 1], "must be an integer"},
        {:error, [0, :e], "must be a binary"},
        {:error, [0, :index], "must at least be 0"},
        {:error, [1, :a], "must be a binary"},
        {:error, [1, :b], "must be a boolean"},
        {:error, [1, :c], "must be a list"},
        {:error, [1, :d, 0, 2], "must be an integer"},
        {:error, [1, :d, 1, 1], "must be an integer"},
        {:error, [1, :e], "must be a binary"},
        {:error, [1, :index], "must at least be 0"},
      ]

      iex> validate(%{}, :unknown)
      {:error, "Validator :unknown does not exist"}

  """
  @spec validate(any, any) :: :break | [{:error, [any], binary}]
  def validate(data, validator) do
    validate(data, validator, [], false)
  end

  @doc """
  Validate data with schema and return list of errors prepend with path, or internal status if nested.

  Use given path to prepend all errors.

  If nested is true will return internal status (like `:break`),
  else will always return normalized errors.
  """
  @spec validate(any, any, [any], boolean) :: :break | [{:error, [any], binary}]
  def validate(data, validator, path, nested) when is_atom(validator) do
    validate(data, [{validator, true}], path, nested)
  end

  def validate(data, validator, path, nested) when is_tuple(validator) do
    validate(data, [validator], path, nested)
  end

  def validate(data, [{validator, options}], path, nested) when is_atom(validator) do
    with {:ok, validator} <- get_validator(validator) do
      case apply(validator, :validate, [data, options]) do
        :ok -> []
        :break when nested === true -> :break
        :break when nested === false -> []
        {:error, nested_path, error} -> [{:error, path ++ nested_path, error}]
        {:error, error} -> [{:error, path, error}]
        errors when is_list(errors) -> normalize_errors(errors, path)
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  def validate(data, options, path, nested) do
    case get_alias(options) do
      {:ok, type} -> validate(data, [{type, options}], path, nested)
      {:ok, type, nested_options} ->
        validate(data, [{type, nested_options}], path, nested)
      {:error, error} -> {:error, error}
    end
  end

  @doc ~S"""
  Returns true if data is valid, else false.

  ## Examples

      iex> valid?(true, :boolean)
      true

      iex> valid?(true, boolean: true)
      true

      iex> valid?(true, boolean: false)
      false

      iex> valid?(true, or: [:boolean, :atom])
      true

      iex> valid?(:ok, or: [:boolean, :atom])
      true

      iex> data = Enum.map(1..10, &(%{
      ...>   a: "a",
      ...>   b: true,
      ...>   c: ["a", "b", false],
      ...>   d: [[1, 2, 3], [4, 5, 6]],
      ...>   index: &1,
      ...> }))
      iex> schema = [list: [map: %{
      ...>   a: :binary,
      ...>   b: :boolean,
      ...>   c: [list: [or: [:binary, :boolean]]],
      ...>   d: [list: [list: :integer]],
      ...>   e: [and: [:optional, :binary]],
      ...>   index: [and: [:integer, in_range: [min: 0]]],
      ...> }]]
      iex> valid?(data, schema)
      true

      iex> data = Enum.map(1..2, &(%{
      ...>   a: 1,
      ...>   b: "b",
      ...>   c: {"a", "b", false},
      ...>   d: [[1, 2, "3"], [4, false, 6]],
      ...>   e: -1,
      ...>   f: "1234567891011",
      ...>   index: &1 - 10,
      ...> }))
      iex> schema = [list: [map: %{
      ...>   a: :binary,
      ...>   b: :boolean,
      ...>   c: [list: [or: [:binary, :boolean]]],
      ...>   d: [list: [list: :integer]],
      ...>   e: [and: [:optional, :binary]],
      ...>   index: [and: [:integer, in_range: [min: 0]]],
      ...> }]]
      iex> valid?(data, schema)
      false

      iex> valid?(true, {:boolean, true})
      true

      iex> valid?(%{a: true}, %{a: :boolean})
      true

      iex> valid?(%{}, :unknown)
      {:error, "Validator :unknown does not exist"}

  """
  @spec valid?(any, any) :: boolean | {:error, binary}
  def valid?(data, validator) do
    valid?(data, validator, [], false)
  end

  @spec valid?(any, any, [any], boolean) :: boolean | {:error, binary}
  def valid?(data, validator, path, nested) when is_atom(validator) do
    valid?(data, [{validator, true}], path, nested)
  end

  def valid?(data, validator, path, nested) when is_tuple(validator) do
    valid?(data, [validator], path, nested)
  end

  def valid?(data, [{validator, options}], _path, _nested) when is_atom(validator) do
    with {:ok, validator} <- get_validator(validator) do
      case apply(validator, :validate, [data, options]) do
        :ok -> true
        [] -> true
        :break -> true
        _ -> false
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  def valid?(data, options, path, nested) do
    case get_alias(options) do
      {:ok, type} -> valid?(data, [{type, options}], path, nested)
      {:ok, type, nested_options} ->
        valid?(data, [{type, nested_options}], path, nested)
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Returns validator associate with given id if any.
  """
  @spec get_validator(atom) :: {:ok, atom} | {:error, any}
  def get_validator(id) do
    Validator.get(@validators_map, id)
  end

  @doc """
  Returns alias associate with given value if any.
  """
  @spec get_alias(any) :: {:ok, atom} | {:ok, atom, boolean | Keyword.t} |
    {:error, any}
  def get_alias(value) do
    AliasType.get(value)
  end

  @doc """
  Returns given errors normalized.
  """
  @spec normalize_errors([any], [any]) :: [{:error, [any], [any]}]
  def normalize_errors(errors, path) when is_list(errors) and is_list(path) do
    Enum.map(errors, fn
      {:error, error} -> {:error, path, error}
      {:error, nested_path, error} -> {:error, path ++ nested_path, error}
      {nested_path, error} -> {:error, path ++ nested_path, error}
    end)
  end
end
