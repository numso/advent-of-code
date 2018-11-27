module DaySix where

import Array exposing (Array)
import String

type Action
  = TurnOn
  | TurnOff
  | Toggle

type alias Instruction =
  { action: Action
  , start: (Int, Int)
  , end: (Int, Int)
  }

gen = Array.repeat 1000
initialData = gen (gen 0)

sum = Array.foldl (+) 0
countData data = sum (Array.map (sum) data)

-- Run Instruction ----------------

executeBinary : Action -> Int -> Int
executeBinary action num =
  case action of
    TurnOn ->
      1
    TurnOff ->
      0
    Toggle ->
      if num == 1 then 0 else 1

executeAnalog : Action -> Int -> Int
executeAnalog action num =
  case action of
    TurnOn ->
      num + 1
    TurnOff ->
      max 0 (num - 1)
    Toggle ->
      num + 2

computeInstruction : (Action -> Int -> Int) -> Instruction -> Array (Array Int)  -> Array (Array Int)
computeInstruction fn {action, start, end} data =
  fillCol (fn action) start end data

fillCol : (Int -> Int) -> (Int, Int) -> (Int, Int) -> Array (Array Int) -> Array (Array Int)
fillCol fn (x, y) (x2, y2) data =
  if y2 - y >= 0 then
    let row = Maybe.withDefault Array.empty (Array.get y data) in
    let newRow = fillRow x x2 row fn in
    fillCol fn (x, (y + 1)) (x2, y2) (Array.set y newRow data)
  else
    data

fillRow : Int -> Int -> Array Int -> (Int -> Int) -> Array Int
fillRow x x2 data fn =
  if x2 - x >= 0 then
    let newVal = fn (Maybe.withDefault 0 (Array.get x data)) in
      fillRow (x + 1) x2 (Array.set x newVal data) fn
  else
    data

-- Parse Instructions ---------------

getInstructions : String -> List Instruction
getInstructions input =
  List.filterMap parseLine (String.split "\n" input)

parseLine : String -> Maybe Instruction
parseLine str =
  if String.startsWith "turn off" str then
    buildInstr TurnOff str
  else if String.startsWith "turn on" str then
    buildInstr TurnOn str
  else
    buildInstr Toggle ("fill " ++ str)

buildInstr : Action -> String -> Maybe Instruction
buildInstr action str =
  case String.split " " str of
    [_, _, first, _, second] ->
      Just { action = action, start = parseNums first, end = parseNums second }
    _ ->
      Nothing

parseNums : String -> (Int, Int)
parseNums str =
  case String.split "," str of
    [x, y] -> (toInt x, toInt y)
    _ -> (0, 0)

toInt : String -> Int
toInt str = Result.withDefault 0 (String.toInt str)

-- Get the answers --------------

compute : (Action -> Int -> Int) -> String -> Int
compute fn input =
  countData (List.foldl (computeInstruction fn) initialData (getInstructions input))

part1 : String -> Int
part1 = compute executeBinary

part2 : String -> Int
part2 = compute executeAnalog

-- part1 DaySix.input === 400410
-- part2 DaySix.input === 15343601
