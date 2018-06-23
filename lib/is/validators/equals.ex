defmodule Is.Validators.Equals do
  @moduledoc ~S"""
  Equal validator.

  ## Examples

      iex> Is.validate("else", equals: "else")
      []

      iex> Is.validate("something", equals: "else")
      [{:error, [], "must equals \"else\""}]

  """
  def validate(data, value) do
    case data === value do
      true -> :ok
      false -> {:error, "must equals #{inspect value}"}
    end
  end
end
