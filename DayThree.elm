module DayThree where

import Set
import String

nextHouse (x, y) char =
  case char of
    "<" ->
      (x - 1, y)
    ">" ->
      (x + 1, y)
    "^" ->
      (x, y - 1)
    "v" ->
      (x, y + 1)
    _ ->
      (x, y)

givePresent fn coord houses input =
  let newHouses = Set.insert coord houses in
    case input of
      char :: arr ->
        givePresent fn (nextHouse coord char) newHouses (fn arr)
      [] ->
        newHouses

part1 input =
  String.split "" input
  |> givePresent identity (0, 0) Set.empty
  |> Set.size

part2 input =
  let inp = String.split "" input in
  let fn = givePresent (List.drop 1) (0, 0) in
  let first = fn Set.empty inp in
    fn first (List.drop 1 inp)
    |> Set.size

-- part1 input3 === 2565
-- part2 input3 === 2639
