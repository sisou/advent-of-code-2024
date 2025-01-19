import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"

pub fn main() {
  let assert 2 = part1(example)
  let assert Ok(input) = file.read("src/day_02.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> List(List(Int)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    string.split(line, " ")
    |> list.map(fn(level) {
      let assert Ok(level) = int.parse(level)
      level
    })
  })
}

fn part1(input: String) -> Int {
  let reports = parse_input(input)

  list.filter(reports, fn(report) {
    let changes =
      list.window_by_2(report)
      |> list.map(fn(pair) {
        let #(left, right) = pair
        left - right
      })

    let all_increasing = list.all(changes, fn(change) { change > 0 })
    let all_decreasing = list.all(changes, fn(change) { change < 0 })

    let all_small =
      list.all(changes, fn(change) {
        int.absolute_value(change) <= 3 && int.absolute_value(change) >= 1
      })

    all_small && { all_increasing || all_decreasing }
  })
  |> list.length()
}
