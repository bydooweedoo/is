defmodule Is.Validators.Validator do
  @moduledoc """
  Use given validator module to validate data.

  ## Examples

      iex> Is.validate(10, validator: Is.Validators.Integer)
      []

      iex> Is.validate("str", validator: Is.Validators.Integer)
      [{:error, [], "must be an integer"}]

      iex> Is.validate(10, validator: [Is.Validators.Integer, false])
      [{:error, [], "must not be an integer"}]

      iex> Is.validate(%{a: 10}, validator: [Is.Validators.Map, %{a: :binary}])
      [{:error, [:a], "must be a binary"}]

      iex> Is.validate("str", validator: Enum)
      [{:error, [], "validator: options must be a valid validator module"}]

      iex> Is.validate("str", validator: "test")
      [{:error, [], "validator: options must be a valid validator module"}]

  """
  def validate(data, validator) when is_atom(validator) do
    validate(data, [validator, true])
  end

  def validate(data, [validator | extra_args]) when is_atom(validator) do
    if Is.Validator.is_valid?(validator) do
      case apply(validator, :validate, [data] ++ extra_args) do
        :ok -> :ok
        :break -> :break
        {:error, error} -> {:error, error}
        error -> error
      end
    else
      {:error, "validator: options must be a valid validator module"}
    end
  end

  def validate(_data, _options) do
    {:error, "validator: options must be a valid validator module"}
  end
end
