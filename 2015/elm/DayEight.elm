module DayEight where

import Regex exposing (regex, replace)
import String

---- Program Logic ---------------------

codeLen : String -> Int
codeLen = String.length

strLen : (Regex.Match -> String) -> Int -> String -> Int
strLen fn offset str =
  String.length (encode fn str) + offset

encode : (Regex.Match -> String) -> String -> String
encode replaceFn str =
  List.foldl (findReplace replaceFn) str  ["\\\\\"", "\\\\\\\\", "\\\\x[0-9a-f]{2}"]

findReplace : (Regex.Match -> String) -> String -> String -> String
findReplace replaceFn pattern =
  replace Regex.All (regex pattern) replaceFn

---- Helper Functions ------------------

unescape : a -> String
unescape _ = "A"

escape : { a | match : String } -> String
escape {match} = if String.contains "x" match then "AAAAA" else "AAAA"

setup : (Regex.Match -> String) -> Int -> String -> (List Int, List Int)
setup fn offset input =
  let parts = String.split "\n" input in
  let code = List.map codeLen parts in
  let str = List.map (strLen fn offset) parts in
    (code, str)

---- Driver Code -----------------------

part1 : String -> Int
part1 input =
  let (code, str) = setup unescape -2 input in
    List.sum code - List.sum str

part2 : String -> Int
part2 input =
  let (code, str) = setup escape 4 input in
    List.sum str - List.sum code

-- part1 input === 1333
-- part2 input === 2046
