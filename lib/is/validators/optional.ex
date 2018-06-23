defmodule Is.Validators.Optional do
  @moduledoc """
  Optional validator.

  ## Examples

      iex> Is.validate(%{a: true}, :optional)
      []

      iex> Is.validate(nil, :optional)
      []

      iex> Is.validate(nil, optional: false)
      [{:error, [], "is required"}]

  """
  def validate(data, true) do
    case is_nil(data) === true do
      true -> :break
      _ -> :ok
    end
  end

  def validate(data, false) do
    case is_nil(data) === true do
      true -> {:error, "is required"}
      false -> :ok
    end
  end
end
