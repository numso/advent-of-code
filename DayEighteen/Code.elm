module DayEighteen.Code where

import Array exposing (Array)
import String

-- Parse Input

parseInput : String -> Array (Array Bool)
parseInput str =
  let lines = String.lines str in
    Array.fromList (List.map parseLine lines)

parseLine : String -> Array Bool
parseLine line =
  let words = String.split "" line in
    Array.fromList (List.map ((==) "#") words)

-- Code

tick : Array (Array Bool) -> Array (Array Bool)
tick board =
  Array.indexedMap (\x row -> (Array.indexedMap (\y cell -> tickCell board x y) row)) board

tickCell : Array (Array Bool) -> Int -> Int -> Bool
tickCell board x y =
  let nums = [
      getCell board (x - 1) (y - 1)
    , getCell board (x) (y - 1)
    , getCell board (x + 1) (y - 1)
    , getCell board (x - 1) y
    , getCell board (x + 1) y
    , getCell board (x - 1) (y + 1)
    , getCell board (x) (y + 1)
    , getCell board (x + 1) (y + 1)
    ]
  in
  let count = List.sum nums in
    case (count, getCell board x y) of
      (2, 1) -> True
      (3, _) -> True
      _ -> False

getCell : Array (Array Bool) -> Int -> Int -> Int
getCell board x y =
  let row = Maybe.withDefault Array.empty (Array.get x board) in
  let cell = Maybe.withDefault False (Array.get y row) in
    if cell == True then 1 else 0

setCell : Array (Array Bool) -> Int -> Int -> Array (Array Bool)
setCell board x y =
  Array.set x (Array.set y True (Maybe.withDefault Array.empty (Array.get x board))) board

count : Array (Array Bool) -> Int
count board =
  Array.foldl countLine 0 board

countLine : Array Bool -> Int -> Int
countLine line count =
  Array.foldl (\a b -> if a then b + 1 else b) count line

lightCorners : Array (Array Bool) -> Array (Array Bool)
lightCorners board =
  let len = (Array.length board) - 1 in
    List.foldl (\(x, y) res -> setCell res x y) board [(0, 0), (0, len), (len, 0), (len, len)]

runGame : (Array (Array Bool) -> Array (Array Bool)) -> Int -> String -> Int
runGame fn iters inp =
  let board = parseInput inp in
  let final = List.foldl (\_ b -> tick (fn b)) board [1..iters] in
    count (fn final)
