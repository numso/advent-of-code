module DaySixteen.Code where

import Array exposing (Array)
import Dict exposing (Dict)
import Maybe
import String
import DaySixteen.Input exposing (input)

type alias Aunt = (Int, Dict String Int)
type alias Comparator = String -> Int -> Int -> Bool

-- Parse Input

parseInput : String -> List Aunt
parseInput =
  List.map parseAunt << String.lines

parseAunt : String -> Aunt
parseAunt str =
  let parts = String.words str in
  let num = parseCommaIntAt parts 1 in
  let attrs = List.drop 2 parts in
    (num, parseAttrs attrs)

parseAttrs : List String -> Dict String Int
parseAttrs chunks =
  case chunks of
    key :: val :: [] ->
        Dict.insert (String.dropRight 1 key) (toInt val) Dict.empty
    key :: val :: rest ->
        Dict.insert (String.dropRight 1 key) (toIntTrim 1 val) (parseAttrs rest)
    _ ->
      Dict.empty

parseCommaIntAt : List String -> Int -> Int
parseCommaIntAt parts i =
    toIntTrim 1 (Maybe.withDefault "" (Array.get i (Array.fromList parts)))

toInt : String -> Int
toInt = toIntTrim 0

toIntTrim : Int -> String -> Int
toIntTrim num str =
  let trimmed = String.dropRight num str in
    Result.withDefault 0 (String.toInt trimmed)

ticker : List (String, Int)
ticker = [
    ("children", 3)
  , ("cats", 7)
  , ("samoyeds", 2)
  , ("pomeranians", 3)
  , ("akitas", 0)
  , ("vizslas", 0)
  , ("goldfish", 5)
  , ("trees", 3)
  , ("cars", 2)
  , ("perfumes", 1)
  ]

-- Code

matchAttribute : Comparator -> Aunt -> (String, Int) -> Bool
matchAttribute fn (_, attrs) (key, val) =
  let attr = Dict.get key attrs in
    case attr of
      Just num ->
        fn key val num
      Nothing ->
        True

investigate : Comparator -> Aunt -> Bool
investigate fn aunt =
  List.all (matchAttribute fn aunt) ticker

simple : Comparator
simple _ val num =
  val == num

complex : Comparator
complex key val num =
  case key of
    "cats" ->
      num > val
    "trees" ->
      num > val
    "pomeranians" ->
      num < val
    "goldfish" ->
      num < val
    _ ->
      val == num

driver : Comparator -> String -> Int
driver fn str =
  let aunts = parseInput str in
  let filtered = List.filter (investigate fn) aunts in
  case filtered of
    [(num, _)] -> num
    _ -> -1

-- Drivers

part1 = driver simple input -- 103
part2 = driver complex input -- 405
