defmodule Is.Validators.If do
  @moduledoc ~S"""
  IF operator for validators.

  ## Examples

      iex> Is.validate("else", if: [:binary, equals: "else"])
      []

      iex> Is.validate("else", [
      ...>   if: [:binary, equals: "else"],
      ...> ])
      []

      iex> Is.validate("something", [
      ...>   if: [:binary, equals: "else"],
      ...> ])
      [{:error, [], "must equals \"else\""}]

      iex> Is.validate(1, [
      ...>   if: [:binary, equals: "else"],
      ...> ])
      []

  """
  def validate(data, options) do
    [condition | rest] = options
    case Is.validate(data, condition, [], true) do
      [] -> Is.validate(data, rest, [], true)
      _ -> :ok
    end
  end
end
