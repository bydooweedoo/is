defmodule Is.Validators.Binary do
  @moduledoc """
  Validation for binary.

  ## Examples

      iex> Is.validate("str", :binary)
      []

      iex> Is.validate(1, :binary)
      [{:error, [], "must be a binary"}]

      iex> Is.validate("str", binary: false)
      [{:error, [], "must not be a binary"}]

      iex> Is.validate("str", [binary: false])
      [{:error, [], "must not be a binary"}]

  """
  def validate(data, is) when is_boolean(is) do
    case is_binary(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be a binary"}
      false when is === false -> {:error, "must not be a binary"}
    end
  end
end
