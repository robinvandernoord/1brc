import gleam/io
import gleam/dict
import gleam/int
import gleam/float
import gleam/iterator
import gleam/list
import gleam/result
import gleam/string
import file_streams/read_text_stream

pub fn defer(cleanup, body) {
  let result = body()
  cleanup()
  Ok(result)
}

pub type Measurement {
  Measurement(min: Float, max: Float, sum: Float, cnt: Float)
}

fn new_measurement() {
  Measurement(
    min: 99_999_999_999_999_999_999.0,
    max: -99_999_999_999_999_999_999.0,
    sum: 0.0,
    cnt: 0.0,
  )
}

fn update_measurement(measurement: Measurement, value: Float) {
  Measurement(
    min: float.min(measurement.min, value),
    max: float.max(measurement.max, value),
    sum: float.add(measurement.sum, value),
    cnt: float.add(measurement.cnt, 1.0),
  )
}

fn try_parse_float(num_as_str: String) {
  num_as_str
  |> float.parse()
  |> result.unwrap(0.0)
}

fn parse_row(row) {
  let parts =
    row
    |> unwrap_or_panic
    |> string.trim_right
    |> string.split_once(";")
  case parts {
    Ok(#(name, num_as_str)) -> {
      let num = try_parse_float(num_as_str)

      #(name, num)
    }
    Error(_) -> {
      #("", 0.0)
    }
  }
}

fn unwrap_or_panic(opt) {
  case opt {
    Ok(value) -> value
    Error(_) -> panic as "unwrap or panic"
  }
}

fn update_dict(records, row: #(String, Float)) {
  let #(name, value) = row

  records
  |> dict.get(name)
  |> result.lazy_unwrap(new_measurement)
  |> update_measurement(value)
  |> dict.insert(records, name, _)
}

fn sort_by_name(a: #(String, any), b: #(String, any)) {
  // todo: generic?
  string.compare(a.0, b.0)
}

fn float_to_str(a_float: Float, precision: Int) -> String {
  let num =
    precision
    |> int.to_float()
    |> int.power(10, _)
    |> result.unwrap(1.0)

  a_float
  |> float.multiply(num)
  |> float.round()
  |> int.to_float()
  |> float.divide(num)
  |> result.unwrap(0.0)
  |> float.to_string()
}

fn report(tupl: #(String, Measurement)) {
  let m = tupl.1

  io.print(tupl.0)
  io.print("=")

  m.min
  |> float_to_str(1)
  |> io.print()

  io.print("/")

  m.sum
  |> float.divide(m.cnt)
  |> result.unwrap(0.0)
  |> float_to_str(1)
  |> io.print()

  io.print("/")

  m.max
  |> float_to_str(1)
  |> io.print()

  io.print(", ")
}

fn dump(value, count) {
  io.debug(count)
  value
}

pub fn main() {
  use reader <- result.try(read_text_stream.open("measurements.txt"))
  use <- defer(fn() { read_text_stream.close(reader) })

  io.print("{")

  Ok("")
  |> iterator.iterate(fn(_) { read_text_stream.read_line(reader) })
  |> iterator.drop(up_to: 1)
  |> iterator.take_while(result.is_ok)
  // |> iterator.take(1000)
  |> iterator.map(parse_row)
  |> iterator.fold(from: dict.new(), with: update_dict)
  |> dict.to_list()
  |> list.sort(sort_by_name)
  |> list.map(report)

  io.print("\u{08}\u{08}")
  io.print("}\n")
}
