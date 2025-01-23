import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import simplifile as file

const example = "
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"

pub fn main() {
  let assert 14 = part1(example)
  let assert Ok(input) = file.read("src/day_08.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> #(Dict(String, List(#(Int, Int))), #(Int, Int)) {
  let lines =
    input
    |> string.trim
    |> string.split("\n")

  let height = list.length(lines)
  let width = lines |> list.first() |> result.unwrap("") |> string.length()

  let antennas =
    lines
    |> list.index_fold(dict.new(), fn(acc, line, y) {
      line
      |> string.to_graphemes()
      |> list.index_fold(acc, fn(acc, char, x) {
        case char {
          "." -> acc
          _ -> {
            let locations = dict.get(acc, char) |> result.unwrap([])
            acc |> dict.insert(char, [#(x, y), ..locations])
          }
        }
      })
    })

  #(antennas, #(width, height))
}

fn part1(input: String) -> Int {
  let #(antennas, #(width, height)) = parse_input(input)

  antennas
  |> dict.fold(set.new(), fn(acc, _char, locations) {
    list.combination_pairs(locations)
    |> list.fold(acc, fn(acc, pair) {
      let #(a, b) = pair
      let distance = #(b.0 - a.0, b.1 - a.1)
      acc
      |> set.insert(#(a.0 - distance.0, a.1 - distance.1))
      |> set.insert(#(b.0 + distance.0, b.1 + distance.1))
    })
  })
  |> set.filter(fn(location) {
    let #(x, y) = location
    x >= 0 && x < width && y >= 0 && y < height
  })
  |> set.size()
}
