# Is

Fast, extensible and easy to use data structure validation for [elixir](https://github.com/elixir-lang/elixir) with nested structures support.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `is` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:is, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/is](https://hexdocs.pm/is).

## Example

```elixir
iex> data = Enum.map(1..2, &(%{
...>   a: 1,
...>   b: "b",
...>   c: {"a", "b", false},
...>   d: [[1, 2, "3"], [4, false, 6]],
...>   e: -1,
...>   f: "1234567891011",
...>   index: &1 - 10,
...> }))
iex> schema = [list: [map: %{
...>   a: :binary,
...>   b: :boolean,
...>   c: [list: [or: [:binary, :boolean]]],
...>   d: [list: [list: :integer]],
...>   e: [and: [:optional, :binary]],
...>   index: [and: [:integer, in_range: [min: 0]]],
...> }]]
iex> Is.validate(data, schema)
[
  {:error, [0, :a], "must be a binary"},
  {:error, [0, :b], "must be a boolean"},
  {:error, [0, :c], "must be a list"},
  {:error, [0, :d, 0, 2], "must be an integer"},
  {:error, [0, :d, 1, 1], "must be an integer"},
  {:error, [0, :e], "must be a binary"},
  {:error, [0, :index], "must at least be 0"},
  {:error, [1, :a], "must be a binary"},
  {:error, [1, :b], "must be a boolean"},
  {:error, [1, :c], "must be a list"},
  {:error, [1, :d, 0, 2], "must be an integer"},
  {:error, [1, :d, 1, 1], "must be an integer"},
  {:error, [1, :e], "must be a binary"},
  {:error, [1, :index], "must at least be 0"},
]
```

Validations
-----------

### Basic types

#### :atom

Test if data is an atom or not

```elixir
iex> Is.validate(:value, :atom)
[]

iex> Is.validate(:value, atom: true)
[]

iex> Is.validate(1, :atom)
[{:error, [], "must be a atom"}]

iex> Is.validate(:value, atom: false)
[{:error, [], "must not be a atom"}]
```

#### :binary

Test if data is a binary or not

```elixir
iex> Is.validate("value", :binary)
[]

iex> Is.validate("value", binary: true)
[]

iex> Is.validate(1, :binary)
[{:error, [], "must be a binary"}]

iex> Is.validate("value", binary: false)
[{:error, [], "must not be a binary"}]
```

#### :boolean

Test if data is a boolean or not

```elixir
iex> Is.validate(true, :boolean)
[]

iex> Is.validate(true, boolean: true)
[]

iex> Is.validate(1, :boolean)
[{:error, [], "must be a boolean"}]

iex> Is.validate(true, boolean: false)
[{:error, [], "must not be a boolean"}]
```

#### :equals

Test if data equals given value

```elixir
iex> Is.validate(true, equals: true)
[]

iex> Is.validate("str", equals: "str")
[]

iex> Is.validate(1, equals: true)
[{:error, [], "must equals true"}]
```

#### :fn

Test if data equals given value

```elixir
iex> Is.validate(1, fn: &is_number/1)
[]

iex> Is.validate(true, fn: &is_number/1)
[{:error, [], "must satisfies &:erlang.is_number/1"}]

iex> starts_with? = fn(value, prefix) ->
...>   if String.starts_with?(value, prefix) do
...>     :ok
...>   else
...>     {:error, "must start with #{inspect prefix}"}
...>   end
...> end
iex> Is.validate("https://elixir-lang.org", fn: [starts_with?, "http"])
[]
iex> Is.validate("elixir-lang.org", fn: [starts_with?, "http"])
[{:error, [], "must start with \"http\""}]

iex> Is.validate(12, fn: {1, 2})
[{:error, [], "fn: options are invalid"}]
```