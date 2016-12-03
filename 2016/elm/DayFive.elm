module DayFive where

import String

toNum bool =
  case bool of
    True ->
      1
    False ->
      0

isDouble str =
  let parts = String.split "" str in
  case parts of
    [a, b] ->
      a == b
    _ ->
      False

hasVowels str =
  String.filter (\c -> String.contains (String.fromChar c) "aeiou") str
  |> String.length
  |> (\num -> num >= 3)

hasDouble str =
  let part = String.left 2 str in
  let res = isDouble part in
    case (res, part) of
      (True, _) ->
        True
      (_, "") ->
        False
      _ ->
        hasDouble (String.dropLeft 1 str)

excludesPattern str =
  not
  <| List.any (\s -> String.contains s str)
  <| ["ab", "cd", "pq", "xy"]

hasPair str =
  let first = String.left 2 str in
  let res = String.contains first (String.dropLeft 2 str) in
    case (res, first) of
      (_, "") ->
        False
      (True, _) ->
        True
      _ ->
        hasPair (String.dropLeft 1 str)

hasDupeBetween str =
  let first = String.slice 0 1 str in
  let second = String.slice 2 3 str in
  let equal = first == second in
    case (equal, second) of
      (True, _) ->
        True
      (_, "") ->
        False
      _ ->
        hasDupeBetween (String.dropLeft 1 str)


isNice str =
  hasVowels str && hasDouble str && excludesPattern str

isNice2 str =
  hasPair str && hasDupeBetween str

part1 input =
  String.lines input
  |> List.map isNice
  |> List.map toNum
  |> List.sum

part2 input =
  String.lines input
  |> List.map isNice2
  |> List.map toNum
  |> List.sum

-- part1 input5 === 258
-- part2 input5 === 53
