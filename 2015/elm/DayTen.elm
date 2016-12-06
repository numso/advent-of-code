module DayTen where

import String

chunkify : String -> List String
chunkify str =
  let chunks = String.split "" str in
  let res = List.foldl appendChar [] chunks in
    List.reverse res

appendChar : String -> List String -> List String
appendChar char res =
  let last = List.head res in
    case last of
      Just c ->
        if (String.left 1 c) == char then
          (c ++ char) :: (List.drop 1 res)
        else
          char :: res
      Nothing ->
        [char]

count : List String -> String
count strs =
  List.foldl (\str res -> res ++ translate str) "" strs

translate : String -> String
translate str =
  let count = String.length str in
  let num = String.left 1 str in
    toString count ++ num

iterate : String -> String
iterate = chunkify >> count


execute : String -> Int -> String
execute str count =
  if count <= 0 then
    str
  else
    execute (iterate str) (count - 1)

part1 : String -> Int
part1 str = String.length (execute str 40)

part2 : String -> Int
part2 str = String.length (execute str 50)

-- part1 input === 492982
-- part2 input === 6989950
