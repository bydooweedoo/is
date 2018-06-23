defmodule Is.Validators.Inclusion do
  @moduledoc """
  Inclusion validator.

  Can use list or map for faster lookup.
  When using map only key matters.

  ## Examples

      iex> Is.validate(10, inclusion: [1, 10])
      []

      iex> Is.validate(10, inclusion: %{1 => true, 10 => true})
      []

      iex> Is.validate(11, inclusion: [1, 10])
      [{:error, [], "must be one of the value [1, 10]"}]

      iex> Is.validate(11, inclusion: %{1 => true, 10 => true})
      [{:error, [], "must be one of the value %{1 => true, 10 => true}"}]

  """
  def validate(data, options) when is_list(options) do
    case data in options do
      true -> :ok
      false -> {:error, "must be one of the value #{inspect options}"}
    end
  end

  def validate(data, options) when is_map(options) do
    case Map.has_key?(options, data) do
      true -> :ok
      false -> {:error, "must be one of the value #{inspect options}"}
    end
  end

  def validate(_data, _options) do
    {:error, "inclusion: options must be a list or a map"}
  end
end
