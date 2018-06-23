defmodule Is.Validators.And do
  @moduledoc """
  AND logic operators for validators.

  ## Examples

      iex> Is.validate(10, and: [:integer, equals: 10])
      []

      iex> Is.validate(nil, and: [:optional, :integer, equals: 10])
      []

      iex> Is.validate(10, and: [integer: false, equals: 10])
      [{:error, [], "must not be an integer"}]

      iex> Is.validate(10, and: [:integer, equals: 11])
      [{:error, [], "must equals 11"}]

  """
  @spec validate(any, Keyword.t) :: :ok | [{:error, [any], binary}]
  def validate(data, conditions) when is_list(conditions) do
    case Enum.reduce_while(conditions, {:ok, data}, &validate_option/2) do
      {:ok, _data} -> :ok
      {:error, error} -> error
    end
  end

  def validate_option(condition, {:ok, data}) do
    case Is.validate(data, condition, [], true) do
      :break -> {:halt, {:ok, data}}
      [] -> {:cont, {:ok, data}}
      errors -> {:halt, {:error, errors}}
    end
  end
end
