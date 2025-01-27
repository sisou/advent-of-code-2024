import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "
2333133121414131402
"

pub fn main() {
  let assert 1928 = part1(example)
  let assert Ok(input) = file.read("src/day_09.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> #(List(#(Int, Int)), List(Int)) {
  let line = input |> string.trim

  line
  |> string.to_graphemes()
  |> list.sized_chunk(2)
  |> list.index_map(fn(pair, file_value) {
    case pair {
      [file_size, free_size] -> {
        let assert Ok(file_size) = int.parse(file_size)
        let assert Ok(free_size) = int.parse(free_size)
        let file = #(file_value, file_size)
        #(file, free_size)
      }
      [file_size] -> {
        let assert Ok(file_size) = int.parse(file_size)
        let file = #(file_value, file_size)
        #(file, 0)
      }
      _ -> panic as "Bad list"
    }
  })
  |> list.unzip()
}

fn compress(
  index: Int,
  acc: Int,
  files: List(#(Int, Int)),
  free_space: List(Int),
) {
  case files {
    [] -> acc
    [file, ..files] -> {
      let #(file_value, file_size) = file
      let acc =
        list.range(index, index + file_size - 1)
        |> list.fold(acc, fn(acc, i) { acc + i * file_value })
      let index = index + file_size

      case files, free_space {
        [], _ -> acc
        _, [] -> compress(index, acc, files, free_space)
        _, [0, ..free_space] -> compress(index, acc, files, free_space)
        _, [free, ..free_space] -> {
          // Fill free space with last file chunks
          let #(acc, files) =
            list.range(index, index + free - 1)
            |> list.fold(#(acc, list.reverse(files)), fn(acc, i) {
              let #(acc, files) = acc
              let #(file, files) = case files {
                // No more files, return a dummy file that ends the loop without affecting the result
                [] -> #(#(0, 1), [])
                [file, ..files] -> #(file, files)
              }
              let #(file_value, file_size) = file
              let acc = acc + i * file_value
              case file_size {
                1 -> #(acc, files)
                _ -> #(acc, [#(file_value, file_size - 1), ..files])
              }
            })
          compress(index + free, acc, list.reverse(files), free_space)
        }
      }
    }
  }
}

fn part1(input: String) -> Int {
  let #(files, free_space) = parse_input(input)
  compress(0, 0, files, free_space)
}
