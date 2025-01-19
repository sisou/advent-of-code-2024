import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import simplifile as file

const example = "
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
"

pub fn main() {
  let assert 161 = part1(example)
  let assert Ok(input) = file.read("src/day_03.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> List(#(Int, Int)) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  re
  |> regexp.scan(input)
  |> list.map(fn(match) {
    let assert [Some(left), Some(right)] = match.submatches
    let assert Ok(left) = int.parse(left)
    let assert Ok(right) = int.parse(right)
    #(left, right)
  })
}

fn part1(input: String) -> Int {
  let pairs = parse_input(input)

  pairs
  |> list.map(fn(pair) {
    let #(left, right) = pair
    left * right
  })
  |> list.fold(0, fn(sum, product) { sum + product })
}
