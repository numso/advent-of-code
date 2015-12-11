module DayOne where

import String

countCharacters input char =
  String.filter (\c -> c == char) input
  |> String.length

findBasement prevCurFloor i input =
  let woo = String.uncons input in
    case woo of
      Just (char, rest) ->
        let curFloor = getCurFloor prevCurFloor char in
        let isBasement = curFloor < 0 in
          case isBasement of
            True ->
              i
            False ->
              findBasement curFloor (i + 1) rest
      Nothing ->
        -1

getCurFloor prev char =
  case char of
    '(' -> prev + 1
    ')' -> prev - 1
    _ -> prev

part1 input =
  countCharacters input '(' - countCharacters input ')'

part2 = findBasement 0 1

-- part1 input1 === 138
-- part2 input1 === 1771
