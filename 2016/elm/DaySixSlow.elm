module DaySixSlow where

-- Turns out Sets are a lot slower than I realized. I
-- rewrote this using arrays and it went much faster :)
-- See DaySix.elm

import Set
import String

type Instruction
  = TurnOn (Int, Int) (Int, Int)
  | TurnOff (Int, Int) (Int, Int)
  | Toggle (Int, Int) (Int, Int)
  | Invalid

computeInstruction instr set =
  case instr of
    TurnOn (x, y) (x2, y2) ->
      Set.union set (fillCol x y x2 y2 Set.empty)
    TurnOff (x, y) (x2, y2) ->
      Set.diff set (fillCol x y x2 y2 Set.empty)
    Toggle (x, y) (x2, y2) ->
      fillCol x y x2 y2 set
    Invalid ->
      set

fillRow : Int -> Int -> Int -> Set.Set (Int, Int) -> Set.Set (Int, Int)
fillRow x y endX set =
  if endX - x >= 0 then
    if Set.member (x, y) set then
      fillRow (x + 1) y endX (Set.remove (x, y) set)
    else
      fillRow (x + 1) y endX (Set.insert (x, y) set)
  else
    set

fillCol : Int -> Int -> Int -> Int -> Set.Set (Int, Int) -> Set.Set (Int, Int)
fillCol x y endX endY set =
  if endY - y >= 0 then
    fillCol x (y + 1) endX endY (fillRow x y endX set)
  else
    set

parseLine str =
  if String.startsWith "turn off" str then
    buildDatum TurnOff str False
  else if String.startsWith "turn on" str then
    buildDatum TurnOn str False
  else
    buildDatum Toggle str True

buildDatum instr str test =
  let chunks = String.split " " str in
    case (test, chunks) of
      (True, [_, first, _, second]) ->
        instr (parseNums first) (parseNums second)
      (False, [_, _, first, _, second]) ->
        instr (parseNums first) (parseNums second)
      _ ->
        Invalid

parseNums chunk =
  let parts = String.split "," chunk in
    case parts of
      [x, y] -> (toInt x, toInt y)
      _ -> (0, 0)

toInt str =
  case String.toInt str of
    Ok num -> num
    Err _ -> 0

part1 input =
  Set.size
  <| List.foldl computeInstruction Set.empty
  <| List.map parseLine (String.split "\n" input)

-- part1 DaySix.input === 400410
-- part2 DaySix.input === ???
