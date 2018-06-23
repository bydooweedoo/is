defmodule Is.Validators.Length do
  @moduledoc """
  Length validator.

  You can implement the protocol `Is.Validators.Length.Of` to get custom structure length.

  ## Examples

      iex> Is.validate("1", length: 1)
      []

      iex> Is.validate("123", length: [min: 3])
      []

      iex> Is.validate("123", length: [max: 3])
      []

      iex> Is.validate("123", length: [min: 1, max: 3])
      []

      iex> Is.validate([1, 2, 3], length: [min: 1, max: 3])
      []

      iex> Is.validate([1, 2, 3], length: [1, 3])
      []

      iex> Is.validate("12", length: 4)
      [{:error, [], "length must equals to 4"}]

      iex> Is.validate("12", length: [min: 3])
      [{:error, [], "length must at least be 3"}]

      iex> Is.validate("1234", length: [max: 3])
      [{:error, [], "length must at most be 3"}]

      iex> Is.validate("1234", length: [min: 1, max: 3])
      [{:error, [], "length must be between 1 and 3 inclusive"}]

      iex> Is.validate("1234", length: [1, 3])
      [{:error, [], "length must be between 1 and 3 inclusive"}]

  """
  def validate(data, num) when is_number(num) do
    with {:ok, size} <- Is.Validators.Length.Of.get_length(data) do
      case size === num do
        true -> :ok
        false -> {:error, "length must equals to #{num}"}
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  def validate(data, [min, max]) when is_number(min) and is_number(max) do
    validate(data, [min: min, max: max])
  end

  def validate(data, options) when is_list(options) do
    min = Keyword.get(options, :min)
    max = Keyword.get(options, :max)
    with {:ok, size} <- Is.Validators.Length.Of.get_length(data) do
      validate_with_range(size, [min, max])
    else
      {:error, error} -> {:error, error}
    end
  end

  def validate(_data, _options) do
    {:error, "length: value is not a binary or list, or options are invalid"}
  end

  defp validate_with_range(size, [min, max]) do
    cond do
      is_number(min) and is_number(max) ->
        if size >= min and size <= max do
          :ok
        else
          {:error, "length must be between #{min} and #{max} inclusive"}
        end
      is_number(min) and not is_number(max) ->
        if size >= min do
          :ok
        else
          {:error, "length must at least be #{min}"}
        end
      is_number(max) and not is_number(min) ->
        if size <= max do
          :ok
        else
          {:error, "length must at most be #{max}"}
        end
      true -> {:error, "length: value is not a binary or options are invalid"}
    end
  end
end

defprotocol Is.Validators.Length.Of do
  @fallback_to_any true

  @spec get_length(any) :: {:ok, integer} | {:error, binary}
  def get_length(data)
end

defimpl Is.Validators.Length.Of, for: Any do
  def get_length(data) when is_binary(data) do
    {:ok, String.length(data)}
  end

  def get_length(data) when is_list(data) do
    {:ok, length(data)}
  end

  def get_length(data) when is_tuple(data) do
    {:ok, data |> Tuple.to_list() |> length()}
  end

  def get_length(_data) do
    {:error, "value length cannot be determined. Please implement protocol Is.Validators.Length.Of"}
  end
end
