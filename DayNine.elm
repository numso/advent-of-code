module DayNine where

import Dict exposing (Dict)
import Set exposing (Set)
import String

type alias Cities = Set String
type alias Distances = Set Int
type alias Legs = Dict (String, String) Int

---- Program Logic ---------------------

driver : Legs -> Cities -> Int -> String -> Distances -> Distances
driver legs cities dist city resp =
  let cities = Set.remove city cities in
    if Set.isEmpty cities then
      Set.insert dist resp
    else
      Set.foldl (reducer legs cities dist city) resp cities

reducer : Legs -> Cities -> Int -> String -> String -> Distances -> Distances
reducer legs cities dist city c resp =
  let d = getDistance legs city c in
    driver legs cities (dist + (getDistance legs city c)) c resp

getDistance : Legs -> String -> String -> Int
getDistance legs c1 c2 =
  let try1 = Dict.get (c1, c2) legs in
  let try2 = Dict.get (c2, c1) legs in
    case (try1, try2) of
      (Just v, _) -> v
      (_, Just v) -> v
      _ -> 0

---- Parse Input -----------------------

parse : String -> (Legs, Cities)
parse str =
  let parts = String.split "\n" str in
  let info = List.filterMap extractLeg parts in
  let legs = List.foldl (\(c1, c2, d) dict -> Dict.insert (c1, c2) d dict) Dict.empty info in
  let cities = List.foldl (\(c1, c2, _) arr -> c1 :: c2 :: arr) [] info in
    (legs, Set.fromList cities)

extractLeg : String -> Maybe (String, String, Int)
extractLeg str =
  case String.split " = " str of
    [cities, dist] ->
      let numDist = Result.withDefault 0 (String.toInt dist) in
      case String.split " to " cities of
        [c1, c2] ->
          Just (c1, c2, numDist)
        _ ->
          Nothing
    _ ->
      Nothing

---- Driver Code -----------------------

compute : (List Int -> Maybe Int) -> String -> Int
compute fn input =
  let (legs, cities) = parse input in
  let set = Set.foldl (driver legs cities 0) Set.empty cities in
    case fn (Set.toList set) of
      Just v ->
        v
      Nothing ->
        -1

part1 : String -> Int
part1 = compute List.minimum

part2 : String -> Int
part2 = compute List.maximum

-- part1 input === 207
-- part2 input === 804

-- part1 test === 605
-- part2 test === 982