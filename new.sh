#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <integer>"
  exit 1
fi

day=$1

if ! [[ "$day" =~ ^[0-9]+$ ]]; then
  echo "Error: Argument is not an integer."
  exit 1
fi

if [ "$day" -lt 10 ]; then
  day=$(printf "%02d" "$day")
fi

cp "template.gleam" "src/day_${day}.gleam"
touch "src/day_${day}.input"

echo "Created files for day: $day"
