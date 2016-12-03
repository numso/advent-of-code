module DayThirteen.Code where

import Maybe
import Set
import String
import DayThirteen.Input exposing (input, testInput)

type alias Relationship = (String, String, Int)

parseInput : String -> List Relationship
parseInput inp =
  List.filterMap createRelation (String.split "\n" inp)

createRelation : String -> Maybe Relationship
createRelation str =
  case String.split " " str of
    [from, _, sentiment, count, _, _, _, _, _, _, to] ->
      let dir = if sentiment == "gain" then 1 else -1 in
        case String.toInt count of
          Ok num ->
            Just (from, String.dropRight 1 to, dir * num)
          Err _ ->
            Nothing
    _ ->
      Nothing

getGuests : List Relationship -> List String
getGuests relations =
  Set.toList (List.foldl (\(p1, _, _) -> Set.insert p1) Set.empty relations)

generateOrders : List String -> List (List String)
generateOrders persons =
  if List.length persons == 1 then
    [persons]
  else
    List.foldl (reducer persons) [] persons

reducer : List String -> String -> List (List String) -> List (List String)
reducer persons p list =
  let leftover = List.filter ((/=) p) persons in
  let lists = generateOrders leftover in
  let foo = List.map ((::) p) lists in
    list ++ foo

buildScores : List Relationship -> List (List String) -> List Int
buildScores relations people =
  List.map (getScore relations) people

getScore : List Relationship -> List String -> Int
getScore relations people =
  let couples = buildCoupleList people in
  let first = Maybe.withDefault "" (List.head people) in
  let last = Maybe.withDefault "" (List.head (List.reverse people)) in
  let couples = (first, last) :: couples in
    List.sum (List.map (getCoupleScore relations) couples)

buildCoupleList : List String -> List (String, String)
buildCoupleList people =
  case people of
    p1 :: p2 :: rest -> (p1, p2) :: (buildCoupleList (p2 :: rest))
    _ -> []

getCoupleScore : List Relationship -> (String, String) -> Int
getCoupleScore relations (first, last) =
  let relevant = List.filter (\(p1, p2, _) -> (p1 == first && p2 == last) || (p1 == last && p2 == first)) relations in
    List.sum (List.map (\(_, _, num) -> num) relevant)

driver extras str =
  let data = parseInput str in
  let guests = extras ++ (getGuests data) in
  let orders = generateOrders guests in
  let scores = buildScores data orders in
    Maybe.withDefault -1 (List.maximum scores)

part1 = driver [] input -- 709
test1 = driver [] testInput -- 330

part2 = driver ["me"] input -- 668
test2 = driver ["me"] testInput -- 286
