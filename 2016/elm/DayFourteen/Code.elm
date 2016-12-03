module DayFourteen.Code where

import Array exposing (Array)
import Maybe
import String
import DayFourteen.Input exposing (input, testInput)

type alias Reindeer =
    { dist: Int
    , time: Int
    , rest: Int
    }

-- Parse Input

parseInput : String -> List Reindeer
parseInput =
  List.map parseDeer << String.lines

parseDeer : String -> Reindeer
parseDeer str =
  let parts = Array.fromList (String.words str) in
  let dist = parseIntAt parts 3 in
  let time = parseIntAt parts 6 in
  let rest = parseIntAt parts 13 in
    { dist = dist, time = time, rest = rest }

parseIntAt : Array String -> Int -> Int
parseIntAt parts i =
  let str = Maybe.withDefault "" (Array.get i parts) in
    Result.withDefault 0 (String.toInt str)

-- Part 1 Code

getDistance : Int -> Reindeer -> Int
getDistance time deer =
  let x = time // (deer.time + deer.rest) in
  let y = time `rem` (deer.time + deer.rest) in
    ((x * deer.time) + (min y deer.time)) * deer.dist

driver1 : Int -> String -> Int
driver1 time str =
  let data = parseInput str in
  let times = List.map (getDistance time) data in
    Maybe.withDefault -1 (List.maximum times)

-- Part 2 Code

tick : Int -> (Int, Reindeer) -> (Int, (Int, Reindeer))
tick time (score, deer) =
  let dist = getDistance time deer in
    (dist, (score, deer))

findWinningDist : List (Int, (Int, Reindeer)) -> Int
findWinningDist deers =
  let nums = List.map fst deers in
    Maybe.withDefault -1 (List.maximum nums)

giveAward : Int -> (Int, (Int, Reindeer)) -> (Int, Reindeer)
giveAward max (dist, (score, deer)) =
  if dist == max then (score + 1, deer) else (score, deer)

reducer : Int -> List (Int, Reindeer) -> List (Int, Reindeer)
reducer time memo =
  let deers = List.map (tick time) memo in
  let max = findWinningDist deers in
    List.map (giveAward max) deers

driver2 : Int -> String -> Int
driver2 time str =
  let data = parseInput str in
  let init = List.map ((,) 0) data in
  let deers = List.foldl reducer init [1..time] in
  let scores = List.map fst deers in
    Maybe.withDefault -1 (List.maximum scores)

-- Drivers

part1 = driver1 2503 input -- 2640
test1 = driver1 1000 testInput -- 1120

part2 = driver2 2503 input -- 1102
test2 = driver2 1000 testInput -- 689
