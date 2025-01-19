import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "
3   4
4   3
2   5
1   3
3   9
3   3
"

/// Inspired by https://dev.to/sethcalebweeks/advent-of-code-1-in-gleam-20bn
pub fn main() {
  let assert 11 = part1(example)
  let assert Ok(input) = file.read("src/day_01.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> #(List(Int), List(Int)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.fold(#([], []), fn(acc, line) {
    let #(left_list, right_list) = acc
    let assert [left, right] = string.split(line, "   ")
    let assert Ok(left) = int.parse(left)
    let assert Ok(right) = int.parse(right)

    // List order doesn't matter, as the list will be sorted later anyway
    #([left, ..left_list], [right, ..right_list])
  })
}

fn part1(input: String) -> Int {
  let #(left_list, right_list) = parse_input(input)
  let left_list = list.sort(left_list, by: int.compare)
  let right_list = list.sort(right_list, by: int.compare)

  list.zip(left_list, right_list)
  |> list.fold(0, fn(sum, pair) {
    let #(left, right) = pair
    sum + int.absolute_value(left - right)
  })
}
