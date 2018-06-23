inputs = %{
  "binary(10)" => "1234567890",
  "list(10)" => [1, 2, 3, 4, 5, 6, 7, 8, 9, 0],
  "tuple(10)" => {1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
}

opts = [
  inputs: inputs,
  formatters: [
    &Benchee.Formatters.HTML.output/1,
    &Benchee.Formatters.CSV.output/1,
    &Benchee.Formatters.Console.output/1,
  ],
  formatter_options: [
    html: [
      file: "bench_output/validators/length.html",
    ],
    csv: [
      file: "bench_output/validators/length.html"
    ],
  ],
]

Benchee.run(%{
  "length: 10" => fn(value) ->
    Is.validate(value, length: 10)
  end,
  "length: 9" => fn(value) ->
    Is.validate(value, length: 9)
  end,
  "length: [1, 10]" => fn(value) ->
    Is.validate(value, length: [1, 10])
  end,
  "length: [min: 1]" => fn(value) ->
    Is.validate(value, length: [min: 1])
  end,
  "length: [max: 10]" => fn(value) ->
    Is.validate(value, length: [max: 10])
  end,
  "length: [min: 1, max: 10]" => fn(value) ->
    Is.validate(value, length: [min: 1, max: 10])
  end,
}, opts)
