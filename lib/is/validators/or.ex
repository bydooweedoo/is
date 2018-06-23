defmodule Is.Validators.Or do
  @moduledoc """
  OR logic operators for validators.

  ## Examples

      iex> Is.validate(10, or: [:integer, :binary])
      []

      iex> Is.validate(10, or: [:binary, :boolean])
      [{:error, [], "must satisfies at least one of conditions [:binary, :boolean]"}]

  """
  def validate(data, conditions) when is_list(conditions) do
    case Enum.reduce_while(conditions, data, &validate_option/2) do
      :ok -> :ok
      _ -> {:error, "must satisfies at least one of conditions #{inspect conditions}"}
    end
  end

  def validate_option(condition, data) do
    case Is.validate(data, condition, [], true) do
      :break -> {:halt, {:ok, data}}
      [] -> {:halt, :ok}
      _ -> {:cont, data}
    end
  end
end
