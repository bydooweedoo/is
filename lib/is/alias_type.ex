defprotocol Is.AliasType do
  @moduledoc ~S"""
  Defines validator alias for a given type.

  It allows to use value type to call a specific validator.

  For now, only `Map` type (`Is.Validators.Map`) has a type alias enabled.

  ## Example

    These two lines are equivalent:

      iex> Is.validate(%{a: true}, map: %{a: :boolean})
      []

      iex> Is.validate(%{a: true}, %{a: :boolean})
      []

    Because we define an alias type for `Map`:

      defimpl Is.AliasType, for: Map do
        def get(_) do
          {:ok, :map}
        end
      end

    You can also provide default options when returning an alias type:

      defimpl Is.AliasType, for: MyStruct do
        def get(_) do
          {:ok, :map, %{a: :boolean}}
        end
      end

    Which will allow us to valid `MyStruct` data using:

      iex> Is.validate(%MyStruct{a: 1}, %MyStruct{})
      [{:error, [:a], "must be a boolean"}]

  """
  # @fallback_to_any true
  @doc ~S"""
  Get type alias for given value.
  """
  @spec get(any) :: {:ok, atom} | {:ok, atom, any} | {:error, any}
  def get(value)
end

# defimpl Is.AliasType, for: Any do

#   require Logger

#   def get(value) do
#     Logger.warn "is: No validator alias found for #{inspect value}"
#     Logger.warn "is: Please implement protocol Is.Alias for #{inspect value}"
#     {:error, "No validator alias found for #{inspect value}"}
#   end
# end
