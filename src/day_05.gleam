import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile as file

const example = "
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"

pub fn main() {
  let assert 143 = part1(example)
  let assert Ok(input) = file.read("src/day_05.input")
  part1(input) |> int.to_string |> io.println
}

fn parse_input(input: String) -> #(List(#(Int, Int)), List(List(Int))) {
  let #(rules, updates) =
    input
    |> string.trim
    |> string.split("\n")
    |> list.split_while(fn(line) { line != "" })

  let rules =
    rules
    |> list.map(fn(line) {
      let assert Ok(#(first, second)) = string.split_once(line, "|")
      let assert Ok(first) = int.parse(first)
      let assert Ok(second) = int.parse(second)
      #(first, second)
    })

  // Remove empty line the input was split on
  let updates =
    list.drop(updates, 1)
    |> list.map(fn(line) {
      string.split(line, ",")
      |> list.map(fn(num) {
        let assert Ok(num) = int.parse(num)
        num
      })
    })

  #(rules, updates)
}

fn part1(input: String) -> Int {
  let #(rules, updates) = parse_input(input)

  updates
  |> list.filter(fn(update) {
    list.all(rules, fn(rule) {
      let #(first, second) = rule
      let first_index =
        list.take_while(update, fn(num) { num != first }) |> list.length()
      let second_index =
        list.take_while(update, fn(num) { num != second }) |> list.length()
      let len = list.length(update)
      first_index == len || second_index == len || first_index < second_index
    })
  })
  |> list.map(fn(update) {
    let assert Ok(middle) =
      list.split(update, { list.length(update) - 1 } / 2).1 |> list.first()
    middle
  })
  |> list.fold(0, fn(acc, num) { acc + num })
}
