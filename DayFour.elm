module DayFour where

import String
import Hash

input4 = "yzbqklnj"

checkHash : Int -> String -> Bool
checkHash len str =
  let res = Hash.md5 str in
    (String.left len res) == (String.repeat len "0")

findHash : String -> Int -> Int -> Int
findHash input len num =
  let res = checkHash len (input ++ (toString num)) in
    if res then num else findHash input len (num + 1)

part1 input = findHash input 5 0

part2 input = findHash input 6 0

-- part1 input4 === 282749
-- part2 input4 === 9962624
