defmodule Is.Validator do
  @moduledoc """
  Helpers to retrieve or validate validator.
  """

  require Logger

  @doc ~S"""
  Convert list of validators into map with their atom underscore name as key, and module name as value.

  ## Examples

      iex> to_map([])
      %{}

      iex> to_map([Is.Validators.Binary, Is.Validators.Boolean, Is.Validators.Map])
      %{
        binary: Is.Validators.Binary,
        boolean: Is.Validators.Boolean,
        map: Is.Validators.Map,
      }

      iex> to_map([Is.Validators.Unknown])
      %{}

  """
  @spec to_map([atom]) :: %{required(atom) => atom}
  def to_map(validators) do
    Enum.reduce(validators, %{}, fn(validator, acc) ->
      if is_valid?(validator) === true do
        name = validator
        |> Module.split()
        |> List.last()
        |> Macro.underscore()
        |> String.to_atom()
        Map.put_new(acc, name, validator)
      else
        Logger.warn "is: Please check validator #{inspect validator} exists and export validate(data, options)"
        acc
      end
    end)
  end

  @doc ~S"""
  Check if given validator is valid or not.

  ## Examples

      iex> is_valid?(Is.Validators.Binary)
      true

      iex> is_valid?(nil)
      false

      iex> is_valid?(Enum)
      false

      iex> is_valid?(:binary)
      false

  """
  @spec is_valid?(atom) :: boolean
  def is_valid?(validator) do
    Code.ensure_compiled?(validator) and
    function_exported?(validator, :validate, 2)
  end

  @doc ~S"""
  Returns validator corresponding to given id.

  ## Examples

      iex> get(%{binary: Is.Validators.Binary}, :binary)
      {:ok, Is.Validators.Binary}

      iex> get(%{binary: Is.Validators.Binary}, :unknown)
      {:error, "Validator :unknown does not exist"}

  """
  @spec get(%{required(atom) => atom}, atom) :: {:ok, atom} | {:error, any}
  def get(validators_map, id) do
    case Map.get(validators_map, id) do
      nil -> {:error, "Validator #{inspect id} does not exist"}
      validator -> {:ok, validator}
    end
  end
end
