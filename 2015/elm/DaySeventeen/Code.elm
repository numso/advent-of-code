module DaySeventeen.Code where

import DaySeventeen.Input exposing (input, testInput)

findCombinations : Int -> Int -> List Int -> List Int
findCombinations used total nums =
  if total < 0 then
    []
  else if total == 0 then
    [used]
  else
    case nums of
      head :: rest ->
        findCombinations (used + 1) (total - head) rest ++ findCombinations used total rest
      [] ->
        []

totalCombinations : Int -> List Int -> Int
totalCombinations total nums =
  List.length (findCombinations 0 total nums)

minCombinations : Int -> List Int -> Int
minCombinations total nums =
  let res = findCombinations 0 total nums in
  let minNum = Maybe.withDefault -1 (List.minimum res) in
    List.length (List.filter (\n -> n == minNum) res)

-- Drivers

part1 = totalCombinations 150 input -- 1304
test1 = totalCombinations 25 testInput -- 4

part2 = minCombinations 150 input -- 18
test2 = minCombinations 25 testInput -- 3
