import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"

pub fn main() {
  let assert 3749 = part1(example)
  let assert Ok(input) = file.read("src/day_07.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> List(#(Int, List(Int))) {
  let lines =
    input
    |> string.trim
    |> string.split("\n")

  lines
  |> list.map(fn(line) {
    let assert Ok(#(value, nums)) = line |> string.split_once(": ")

    let assert Ok(value) = int.parse(value)

    let nums =
      nums
      |> string.split(" ")
      |> list.map(fn(num) {
        let assert Ok(num) = int.parse(num)
        num
      })

    #(value, nums)
  })
}

fn operate(target: Int, current: Int, nums: List(Int)) -> Bool {
  case nums {
    [] -> current == target
    [num, ..rest] ->
      operate(target, current + num, rest)
      || operate(target, current * num, rest)
  }
}

fn part1(input: String) -> Int {
  let calibrations = parse_input(input)

  calibrations
  |> list.filter(fn(calibration) {
    let #(target, nums) = calibration
    let #(start, nums) = case nums {
      [start, ..nums] -> #(start, nums)
      [] -> panic as "empty nums"
    }
    operate(target, start, nums)
  })
  |> list.fold(0, fn(acc, calibration) { acc + calibration.0 })
}
