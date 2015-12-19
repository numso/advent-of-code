module DaySeven where

import Bitwise
import Dict exposing (Dict)
import String

type alias Register = Dict String Int

type Instruction
  = Assignment String String
  | And String String String
  | Or String String String
  | Not String String
  | RShift String String String
  | LShift String String String

------------------------- Execute Program -------------------------

executeCycle : Register -> List Instruction -> Register
executeCycle = List.foldl executeInstruction

executeInstruction : Instruction -> Register -> Register
executeInstruction instruction register =
  case instruction of
    Assignment from to ->
      case retrieveValue from register of
        Just num ->
          safeInsert to num register
        Nothing ->
          register
    And from1 from2 to ->
      let val1 = retrieveValue from1 register in
      let val2 = retrieveValue from2 register in
      case (val1, val2) of
        (Just num1, Just num2) ->
          safeInsert to (Bitwise.and num1 num2) register
        _ ->
          register
    Or from1 from2 to ->
      let val1 = retrieveValue from1 register in
      let val2 = retrieveValue from2 register in
      case (val1, val2) of
        (Just num1, Just num2) ->
          safeInsert to (Bitwise.or num1 num2) register
        _ ->
          register
    Not from to ->
      case retrieveValue from register of
        Just num ->
          let res = Bitwise.complement num in
          let val = if res < 0 then res + 65536 else res in
            safeInsert to val register
        Nothing ->
          register
    RShift from1 from2 to ->
      let val1 = retrieveValue from1 register in
      let val2 = retrieveValue from2 register in
      case (val1, val2) of
        (Just num1, Just num2) ->
          safeInsert to (Bitwise.shiftRight num1 num2) register
        _ ->
          register
    LShift from1 from2 to ->
      let val1 = retrieveValue from1 register in
      let val2 = retrieveValue from2 register in
      case (val1, val2) of
        (Just num1, Just num2) ->
          safeInsert to (Bitwise.shiftLeft num1 num2) register
        _ ->
          register

retrieveValue : String -> Register -> Maybe Int
retrieveValue key register =
  let
    maybeNum = String.toInt key
    savedVal = Dict.get key register
  in
    case (maybeNum, savedVal) of
      (Ok num, _) ->
        Just num
      (_, Just val) ->
        Just val
      _ ->
        Nothing

safeInsert : comparable -> v -> Dict comparable v -> Dict comparable v
safeInsert k v dict =
  if Dict.member k dict then
    dict
  else
    Dict.insert k v dict

--------------------------- Parse Input ---------------------------

parseInstructions : String -> List Instruction
parseInstructions input =
  List.filterMap parseInstruction (String.split "\n" input)

parseInstruction : String -> Maybe Instruction
parseInstruction str =
  let parts = String.split " -> " str in
    case parts of
      [expr, res] ->
        parseRest expr res
      _ ->
        Nothing

parseRest : String -> String -> Maybe Instruction
parseRest expr res =
  let chunks = String.split " " expr in
    if String.contains "AND" expr then
      case chunks of
        [x, _, y] -> Just (And x y res)
        _ -> Nothing
    else if String.contains "OR" expr then
      case chunks of
        [x, _, y] -> Just (Or x y res)
        _ -> Nothing
    else if String.contains "NOT" expr then
      case chunks of
        [_, x] -> Just (Not x res)
        _ -> Nothing
    else if String.contains "LSHIFT" expr then
      case chunks of
        [x, _, y] -> Just (LShift x y res)
        _ -> Nothing
    else if String.contains "RSHIFT" expr then
      case chunks of
        [x, _, y] -> Just (RShift x y res)
        _ -> Nothing
    else
      case chunks of
        [x] ->
          Just (Assignment x res)
        _ -> Nothing

--------------------------- Find Answers --------------------------

executeProgram : String -> List Instruction -> Register -> Int
executeProgram key instructions register =
  case retrieveValue key register of
    Just num ->
      num
    Nothing ->
      executeProgram key instructions (executeCycle register instructions)

part1 : String -> Int
part1 input =
  executeProgram "a" (parseInstructions input) Dict.empty

part2 : String -> Int
part2 input =
  executeProgram "a" (parseInstructions input) (Dict.singleton "b" (part1 input))

-- part1 DaySeven.input === 46065
-- part2 DaySeven.input === 14134
