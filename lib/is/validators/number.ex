defmodule Is.Validators.Number do
  @moduledoc """
  Validation for number.

  ## Examples

      iex> Is.validate(10, :number)
      []

      iex> Is.validate(10.10, :number)
      []

      iex> Is.validate("str", :number)
      [{:error, [], "must be an number"}]

      iex> Is.validate(10, number: false)
      [{:error, [], "must not be an number"}]

      iex> Is.validate(10, [number: false])
      [{:error, [], "must not be an number"}]

  """
  def validate(data, is) when is_boolean(is) do
    case is_number(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be an number"}
      false when is === false -> {:error, "must not be an number"}
    end
  end
end
