module DayTwelve.Code where

import Json.Decode exposing (..)
import DayTwelve.Input exposing (input, testInput)

props : Decoder (List (String, Int))
props =
  oneOf
    [ intList
    , stringy
    , (lazy (\_ -> sObject))
    , (lazy (\_ -> sList))
    , succeed []
    ]

sObject : Decoder (List (String, Int))
sObject =
  let keyVals = keyValuePairs props in
    customDecoder keyVals stripKeys

-- Uncomment this and use for part 2

-- sObject : Decoder (List (String, Int))
-- sObject =
--   let keyVals = keyValuePairs props in
--   let foo = customDecoder keyVals stripKeys in
--     customDecoder foo checkForRed

-- checkForRed a =
--   let hasRed = List.any (\(str, _) -> str == "red") a in
--     if hasRed then
--       Ok []
--     else
--       Ok a

sList : Decoder (List (String, Int))
sList =
  let listVals = list props in
  let foo = customDecoder listVals flatten in
    customDecoder foo stripReds

stripReds a =
  let withoutReds = List.filter (\(str, _) -> str /= "red") a in
    Ok withoutReds

stripKeys : List (String, List (String ,Int)) -> Result String (List (String ,Int))
stripKeys =
  Ok << List.foldl (\(_, nums) memo -> memo ++ nums) []

flatten : List (List (String, Int)) -> Result String (List (String, Int))
flatten =
  Ok << List.foldl (++) []

intList : Decoder (List (String, Int))
intList =
  customDecoder int (\a -> Ok [("", a)])

stringy : Decoder (List (String, Int))
stringy =
  customDecoder string (\a -> Ok [(a, 0)])

lazy : (() -> Decoder a) -> Decoder a
lazy thunk =
  customDecoder value
      (\js -> decodeValue (thunk ()) js)


run inp =
  let res = decodeString sObject inp in
    case res of
      Ok nums ->
        List.foldl (\(_, num) res -> res + num) 0 nums
      Err err ->
        let foo = Debug.log "Oh noes" err in
          -1


-- part1 input === 119433
-- part2 input === 68466
