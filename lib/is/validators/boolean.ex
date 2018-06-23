defmodule Is.Validators.Boolean do
  @moduledoc """
  Validation for boolean.

  ## Examples

      iex> Is.validate(true, :boolean)
      []

      iex> Is.validate(1, :boolean)
      [{:error, [], "must be a boolean"}]

      iex> Is.validate(true, boolean: false)
      [{:error, [], "must not be a boolean"}]

      iex> Is.validate(true, [boolean: false])
      [{:error, [], "must not be a boolean"}]

  """
  def validate(data, is) when is_boolean(is) do
    case is_boolean(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be a boolean"}
      false when is === false -> {:error, "must not be a boolean"}
    end
  end
end
