module DayTwo where

import String

parseInput input =
  String.split "\n" input
  |> List.map chunkToTuple

chunkToTuple chunk =
  let res = String.split "x" chunk in
  let foo = List.map String.toInt res in
  case foo of
    [Ok x, Ok y, Ok z] -> (x, y, z)
    _ -> (0, 0, 0)

getArea (w, h, l) =
  let x = w * h in
  let y = h * l in
  let z = w * l in
    2 * x + 2 * y + 2 * z + min x (min y z)

getStuff (w, h, l) =
  let x = 2 * (w + h) in
  let y = 2 * (h + l) in
  let z = 2 * (l + w) in
    w * h * l + min x (min y z)

getTotalPaper inputs =
  List.map getArea inputs
  |> List.sum

getTotalRibbon inputs =
  List.map getStuff inputs
  |> List.sum

part1 input =
  parseInput input
  |> getTotalPaper

part2 input =
  parseInput input
  |> getTotalRibbon

-- part1 input2 === 1588178
-- part2 input2 === 3783758
