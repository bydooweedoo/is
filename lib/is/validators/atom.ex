defmodule Is.Validators.Atom do
  @moduledoc """
  Validation for atom.

  ## Examples

      iex> Is.validate(:ok, :atom)
      []

      iex> Is.validate(1, :atom)
      [{:error, [], "must be a atom"}]

      iex> Is.validate(:ok, atom: false)
      [{:error, [], "must not be a atom"}]

      iex> Is.validate(:ok, [atom: false])
      [{:error, [], "must not be a atom"}]

  """
  def validate(data, is) when is_boolean(is) do
    case is_atom(data) === is do
      true -> :ok
      false when is === true -> {:error, "must be a atom"}
      false when is === false -> {:error, "must not be a atom"}
    end
  end
end
