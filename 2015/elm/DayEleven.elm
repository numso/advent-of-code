module DayEleven where

import Char
import Regex
import String

letters : String
letters = "abcdefghijklmnopqrstuvwxyz"

straights : List String
straights = buildStraights letters

buildStraights : String -> List String
buildStraights str =
  let next = String.left 3 str in
    if String.length next == 3 then
      next :: buildStraights (String.dropLeft 1 str)
    else
      []

pairs : List String
pairs = List.map (String.repeat 2) (String.split "" letters)

increment : String -> String
increment str =
  let chars = String.toList str in
  let new = bump 0 (List.reverse chars) in
    String.fromList (List.reverse new)

bump : Int -> List Char -> List Char
bump place chars =
  let char = Maybe.withDefault 'a' (List.head (List.drop place chars)) in
  let code = (Char.toCode char) + 1 in
    if List.member code [105, 108, 111] then
      (List.take place chars) ++ [Char.fromCode (code + 1)] ++ (List.drop (place + 1) chars)
    else if code <= 122 then
      (List.take place chars) ++ [Char.fromCode code] ++ (List.drop (place + 1) chars)
    else
      let newChars = (List.take place chars) ++ ['a'] ++ (List.drop (place + 1) chars) in
        bump (place + 1) newChars

validate : String -> Bool
validate str =
  let
    hasStraight = Regex.contains (Regex.regex (String.join "|" straights)) str
    hasPairs = Regex.find (Regex.AtMost 2) (Regex.regex (String.join "|" pairs)) str
    hasInvalid = Regex.contains (Regex.regex "[ilo]") str
  in
    hasStraight && (List.length hasPairs >= 2) && not hasInvalid

findValid : String -> String
findValid str =
  if validate str then
    str
  else
    findValid (increment str)


part1 : String -> String
part1 = findValid << increment

part2 : String -> String
part2 = part1 << part1

-- part1 input = hepxxyzz
-- part2 input = heqaabcc
