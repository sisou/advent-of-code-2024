import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "
125 17
"

pub fn main() {
  let assert 55_312 = part1(example)
  let assert Ok(input) = file.read("src/day_11.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> List(Int) {
  let line =
    input
    |> string.trim

  line
  |> string.split(" ")
  |> list.map(fn(num) {
    let assert Ok(num) = int.parse(num)
    num
  })
}

fn blink(stones: List(Int)) -> List(Int) {
  stones
  |> list.map(fn(stone) {
    case stone {
      0 -> [1]
      _ -> {
        let stone_str = int.to_string(stone)
        let length = string.length(stone_str)
        case length % 2 {
          0 -> {
            let assert Ok(left) =
              stone_str |> string.slice(0, length / 2) |> int.parse()
            let assert Ok(right) =
              stone_str |> string.slice(length / 2, length / 2) |> int.parse()
            [left, right]
          }
          _ -> [stone * 2024]
        }
      }
    }
  })
  |> list.flatten()
}

fn part1(input: String) -> Int {
  let stones = parse_input(input)
  list.range(1, 25)
  |> list.fold(stones, fn(stones, _) { blink(stones) })
  |> list.length()
}
