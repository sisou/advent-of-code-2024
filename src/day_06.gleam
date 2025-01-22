import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

const example = "
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"

pub fn main() {
  let assert 41 = part1(example)
  let assert Ok(input) = file.read("src/day_06.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> #(#(Int, Int), List(#(Int, Int)), #(Int, Int)) {
  let lines =
    input
    |> string.trim
    |> string.split("\n")

  let height = list.length(lines)
  let width = lines |> list.first() |> result.unwrap("") |> string.length()

  let #(start, obstacles) =
    lines
    |> list.index_fold(#(#(0, 0), []), fn(acc, line, y) {
      let #(start, obstacles) =
        line
        |> string.to_graphemes()
        |> list.index_fold(acc, fn(acc, cell, x) {
          let #(start, obstacles) = acc

          case cell {
            "." -> #(start, obstacles)
            "#" -> #(start, [#(x, y), ..obstacles])
            "^" -> #(#(x, y), obstacles)
            _ -> panic as "unexpected cell"
          }
        })
      #(start, obstacles)
    })

  #(start, obstacles, #(width, height))
}

fn walk(
  position: #(Int, Int),
  vector: #(Int, Int),
  obstacles: List(#(Int, Int)),
  size: #(Int, Int),
  walked: List(#(Int, Int)),
) -> Int {
  let next_position = #(position.0 + vector.0, position.1 + vector.1)

  // Check that next position is within bounds
  case next_position {
    #(x, y) if x < 0 || x >= size.0 || y < 0 || y >= size.1 ->
      list.length(walked)
    _ -> {
      // Check if we'd hit an obstacle
      case list.any(obstacles, fn(obstacle) { obstacle == next_position }) {
        True -> {
          // Turn right 90 degrees and walk there instead
          let new_vector = case vector {
            #(0, -1) -> #(1, 0)
            #(1, 0) -> #(0, 1)
            #(0, 1) -> #(-1, 0)
            #(-1, 0) -> #(0, -1)
            _ -> panic as "unexpected vector"
          }
          // We didn't move, so we don't count this step
          walk(position, new_vector, obstacles, size, walked)
        }
        // Continue walking in the same direction, counting this step
        False -> {
          // Check if we've been here before
          let new_walked = case
            list.any(walked, fn(walked_position) {
              walked_position == next_position
            })
          {
            True -> walked
            // If not, add the walked position to the list
            False -> [next_position, ..walked]
          }
          walk(next_position, vector, obstacles, size, new_walked)
        }
      }
    }
  }
}

fn part1(input: String) -> Int {
  let #(start, obstacles, size) = parse_input(input)
  walk(start, #(0, -1), obstacles, size, [start])
}
