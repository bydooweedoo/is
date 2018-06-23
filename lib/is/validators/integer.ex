defmodule Is.Validators.Integer do
  @moduledoc """
  Validation for integer.

  ## Examples

      iex> Is.validate(10, :integer)
      []

      iex> Is.validate("str", :integer)
      [{:error, [], "must be an integer"}]

      iex> Is.validate(10, integer: false)
      [{:error, [], "must not be an integer"}]

      iex> Is.validate(10, [integer: false])
      [{:error, [], "must not be an integer"}]

  """
  def validate(data, is) when is_boolean(is) do
    case is_integer(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be an integer"}
      false when is === false -> {:error, "must not be an integer"}
    end
  end
end
