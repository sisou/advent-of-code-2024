import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

const example = "
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
"

pub fn main() {
  let assert 36 = part1(example)
  let assert Ok(input) = file.read("src/day_10.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> Dict(Int, List(#(Int, Int))) {
  let lines =
    input
    |> string.trim
    |> string.split("\n")

  lines
  |> list.index_fold(dict.new(), fn(acc, line, y) {
    line
    |> string.to_graphemes()
    |> list.index_fold(acc, fn(acc, char, x) {
      let assert Ok(num) = int.parse(char)
      let coords = dict.get(acc, num) |> result.unwrap([])
      dict.insert(acc, num, [#(x, y), ..coords])
    })
  })
}

fn climb(
  elevation: Int,
  position: #(Int, Int),
  elevations: Dict(Int, List(#(Int, Int))),
) -> List(#(Int, Int)) {
  case elevation {
    9 -> [position]
    _ -> {
      let next_positions =
        dict.get(elevations, elevation + 1)
        |> result.unwrap([])
        |> list.filter(fn(coord) {
          let #(x, y) = coord
          let #(px, py) = position
          let dx = x - px
          let dy = y - py
          let distance = dx * dx + dy * dy
          distance == 1
        })

      case next_positions {
        [] -> []
        _ ->
          next_positions
          |> list.map(fn(next_position) {
            climb(elevation + 1, next_position, elevations)
          })
          |> list.flatten()
      }
    }
  }
}

fn part1(input: String) -> Int {
  let elevations = parse_input(input)

  let trailheads = dict.get(elevations, 0) |> result.unwrap([])

  trailheads
  |> list.map(fn(trailhead) {
    climb(0, trailhead, elevations) |> list.unique() |> list.length()
  })
  |> list.fold(0, int.add)
}
