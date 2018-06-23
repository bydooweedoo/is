defmodule Is.Validators.InRange do
  @moduledoc """
  In range validator (inclusive).

  ## Examples

      iex> Is.validate(10, in_range: [1, 10])
      []

      iex> Is.validate(10, in_range: [min: 1])
      []

      iex> Is.validate(10, in_range: [max: 10])
      []

      iex> Is.validate(10, in_range: [min: 1, max: 10])
      []

      iex> Is.validate(11, in_range: [1, 10])
      [{:error, [], "must be between 1 and 10 inclusive"}]

      iex> Is.validate(-1, in_range: [1, 10])
      [{:error, [], "must be between 1 and 10 inclusive"}]

      iex> Is.validate(2, in_range: [min: 3])
      [{:error, [], "must at least be 3"}]

      iex> Is.validate(4, in_range: [max: 3])
      [{:error, [], "must at most be 3"}]

      iex> Is.validate(2, in_range: [min: 3, max: 4])
      [{:error, [], "must be between 3 and 4 inclusive"}]

      iex> Is.validate(4, in_range: [max: 3])
      [{:error, [], "must at most be 3"}]

      iex> Is.validate("a", in_range: [1, 10])
      [{:error, [], "in_range: value is not a number or options are invalid"}]

  """
  def validate(data, [min, max]) when is_number(min) and is_number(max) do
    validate(data, [min: min, max: max])
  end

  def validate(data, options) when is_number(data) and is_list(options) do
    min = Keyword.get(options, :min)
    max = Keyword.get(options, :max)
    validate_with_range(data, [min, max])
  end

  def validate(_data, _range) do
    {:error, "in_range: value is not a number or options are invalid"}
  end

  defp validate_with_range(size, [min, max]) do
    cond do
      is_number(min) and is_number(max) ->
        if size >= min and size <= max do
          :ok
        else
          {:error, "must be between #{min} and #{max} inclusive"}
        end
      is_number(min) and not is_number(max) ->
        if size >= min do
          :ok
        else
          {:error, "must at least be #{min}"}
        end
      is_number(max) and not is_number(min) ->
        if size <= max do
          :ok
        else
          {:error, "must at most be #{max}"}
        end
      true -> {:error, "length: value is not a binary or options are not valid"}
    end
  end
end
