import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"

pub fn main() {
  let assert 18 = part1(example)
  let assert Ok(input) = file.read("src/day_04.input")
  part1(input) |> int.to_string |> io.println
}

// Returns a list of four lists: horizontal lines, vertical lines, and both types of diagonal lines
fn parse_input(input: String) -> List(List(String)) {
  let horizontal =
    input
    |> string.trim
    |> string.split("\n")

  let assert Ok(first_line) = list.first(horizontal)
  let width = string.length(first_line)
  let height = list.length(horizontal)

  let vertical =
    horizontal
    |> list.fold(list.repeat("", width), fn(acc, line) {
      let letters = string.to_graphemes(line)
      list.zip(acc, letters)
      |> list.map(fn(pair) { pair.0 <> pair.1 })
    })

  let diagonal_right: List(String) = []

  // Top-left-to-bottom-right diagonals from top left going right
  let diagonal_right =
    list.range(0, width - 1)
    |> list.fold(diagonal_right, fn(acc, start_column) {
      let chars =
        list.range(start_column, width - 1)
        |> list.fold(#(0, ""), fn(acc, column) {
          let #(y, line) = acc

          let assert Ok(row) = list.take(horizontal, y + 1) |> list.last()

          #(y + 1, line <> string.slice(row, column, 1))
        })
      [chars.1, ..acc]
    })

  // Top-left-to-bottom-right diagonals from top left going down
  let diagonal_right =
    list.range(1, height - 1)
    |> list.fold(diagonal_right, fn(acc, start_row) {
      let chars =
        list.range(start_row, height - 1)
        |> list.fold(#(0, ""), fn(acc, row) {
          let #(x, line) = acc

          let assert Ok(column) = list.take(vertical, x + 1) |> list.last()

          #(x + 1, line <> string.slice(column, row, 1))
        })
      [chars.1, ..acc]
    })

  let diagonal_left: List(String) = []

  // Top-right-to-bottom-left diagonals from top right going left
  let diagonal_left =
    list.range(width - 1, 0)
    |> list.fold(diagonal_left, fn(acc, start_column) {
      let chars =
        list.range(start_column, 0)
        |> list.fold(#(0, ""), fn(acc, column) {
          let #(y, line) = acc

          let assert Ok(row) = list.take(horizontal, y + 1) |> list.last()

          #(y + 1, line <> string.slice(row, column, 1))
        })
      [chars.1, ..acc]
    })

  // Top-right-to-bottom-left diagonals from top right going down
  let diagonal_left =
    list.range(1, height - 1)
    |> list.fold(diagonal_left, fn(acc, start_row) {
      let chars =
        list.range(start_row, height - 1)
        |> list.fold(#(width - 1, ""), fn(acc, row) {
          let #(x, line) = acc

          let assert Ok(column) = list.take(vertical, x + 1) |> list.last()

          #(x - 1, line <> string.slice(column, row, 1))
        })
      [chars.1, ..acc]
    })

  [horizontal, vertical, diagonal_right, diagonal_left]
}

fn count_xmas(rows: List(String)) -> Int {
  rows
  |> list.map(fn(row) {
    row
    |> string.to_graphemes()
    |> list.window(4)
    |> list.filter(fn(window) {
      let chars = string.join(window, "")
      // Both forward and backward spellings counts
      chars == "XMAS" || chars == "SAMX"
    })
    |> list.length()
  })
  |> list.fold(0, fn(acc, count) { acc + count })
}

fn part1(input: String) -> Int {
  let lists = parse_input(input)

  lists
  |> list.map(count_xmas)
  |> list.fold(0, fn(acc, count) { acc + count })
}
