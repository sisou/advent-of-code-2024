import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "

"

pub fn main() {
  let assert _ = part1(example)
  let assert Ok(input) = file.read("src/day_x.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> List(String) {
  let lines =
    input
    |> string.trim
    |> string.split("\n")

  lines
}

fn part1(input: String) -> Int {
  let lines = parse_input(input)
  0
}
