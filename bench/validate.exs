inputs = %{
  "valid map with nested list" => {Enum.map(1..100, &(%{
    a: "a",
    b: true,
    c: ["a", "b", false],
    d: [[1, 2, 3], [4, 5, 6]],
    f: "123456789",
    index: &1,
  })), list: [
    map: %{
      a: :binary,
      b: :boolean,
      c: [list: [or: [:binary, :boolean]]],
      d: [list: [list: :integer]],
      e: [and: [:optional, :binary]],
      f: [and: [:binary, length: [min: 1, max: 10]]],
      index: [and: [:integer, in_range: [min: 0]]],
    },
  ]},
  "invalid map with nested list" => {Enum.map(1..100, &(%{
    a: 1,
    b: "b",
    c: {"a", "b", false},
    d: [[1, 2, "3"], [4, false, 6]],
    e: -1,
    f: "1234567891011",
    index: &1 - 10,
  })), list: [
    map: %{
      a: :binary,
      b: :boolean,
      c: [list: [or: [:binary, :boolean]]],
      d: [list: [list: :integer]],
      e: [and: [:optional, :binary]],
      f: [and: [:binary, length: [min: 1, max: 10]]],
      index: [and: [:integer, in_range: [min: 0]]],
    },
  ]},
}

opts = [
  memory_time: 2,
  inputs: inputs,
  formatters: [
    &Benchee.Formatters.HTML.output/1,
    &Benchee.Formatters.CSV.output/1,
    &Benchee.Formatters.Console.output/1,
  ],
  formatter_options: [
    html: [
      file: "bench_output/validate.html",
    ],
    csv: [
      file: "bench_output/validate.csv"
    ],
  ],
]

Benchee.run(%{
  "validate" => fn({data, schema}) ->
    Is.validate(data, schema)
  end,
}, opts)
