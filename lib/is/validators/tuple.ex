defmodule Is.Validators.Tuple do
  @moduledoc ~S"""
  Validation for tuple.

  ## Examples

      iex> Is.validate({}, :tuple)
      []

      iex> Is.validate({}, tuple: false)
      [{:error, [], "must not be a tuple"}]

      iex> Is.validate({"a", "b", "c"}, tuple: :binary)
      []

      iex> Is.validate(%{value: {"a", true, "c"}}, map: %{value: [tuple: [or: [:binary, :boolean]]]})
      []

      iex> Is.validate({:error, "error message"}, tuple: {:atom, :binary})
      []

      iex> Is.validate({:error, "error message"}, tuple: {:atom, :boolean})
      [{:error, [1], "must be a boolean"}]

  """
  def validate(data, is) when is_boolean(is) do
    case is_tuple(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be a tuple"}
      false when is === false -> {:error, "must not be a tuple"}
    end
  end

  def validate(values, schema) when is_tuple(values) and is_tuple(schema) do
    values
    |> Tuple.to_list()
    |> Enum.reduce({0, []}, fn(value, {index, errors}) ->
      {index + 1, errors ++ Is.validate(value, elem(schema, index), [index], true)}
    end)
    |> elem(1)
  end

  def validate(values, schema) when is_tuple(values) do
    values
    |> Tuple.to_list()
    |> Enum.reduce({0, []}, fn(value, {index, acc}) ->
      {index + 1, acc ++ Is.validate(value, schema, [index], true)}
    end)
    |> elem(1)
  end

  def validate(_values, _schema) do
    {:error, "must be a tuple"}
  end
end
