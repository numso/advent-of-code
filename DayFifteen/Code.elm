module DayFifteen.Code where

import Array exposing (Array)
import Maybe
import String
import DayFifteen.Input exposing (input, testInput)

type alias Ingredient =
    { attr: List Int
    , cal: Int
    }

-- Parse Input

parseInput : String -> List Ingredient
parseInput =
  List.map parseIngredient << String.lines

parseIngredient : String -> Ingredient
parseIngredient str =
  let parts = Array.fromList (String.words str) in
  let cap = parseCommaIntAt parts 2 in
  let dur = parseCommaIntAt parts 4 in
  let fla = parseCommaIntAt parts 6 in
  let tex = parseCommaIntAt parts 8 in
  let cal = parseIntAt parts 10 in
    { attr = [cap, dur, fla, tex], cal = cal }

parseCommaIntAt : Array String -> Int -> Int
parseCommaIntAt parts i =
  let strWithComma = Maybe.withDefault "" (Array.get i parts) in
  let str = String.dropRight 1 strWithComma in
    Result.withDefault 0 (String.toInt str)

parseIntAt : Array String -> Int -> Int
parseIntAt parts i =
  let str = Maybe.withDefault "" (Array.get i parts) in
    Result.withDefault 0 (String.toInt str)

-- Part 1 Code

getIngrScore : Int -> Ingredient -> Int
getIngrScore amount {attr} =
  let nums = List.map ((*) amount) attr in
    List.sum nums

{-

a + b + c + d = 100

(i1.capacity * a + i2.capacity * b + i3.capacity * c + i4.capacity * d)
* (i1.durability * a + i2.durability * b + i3.durability * c + i4.durability * d)
* (i1.flavor * a + i2.flavor * b + i3.flavor * c + i4.flavor * d)
* (i1.texture * a + i2.texture * b + i3.texture * c + i4.texture * d)

1. Reduce down to one variable
2. Solve d/dx of (1) = 0 (all local min/max)
3. Solve d/dx of (2) = 0 (which of them are max)

-}

dallin : Int -> List (Ingredient, Int) -> List (Ingredient, Int)
dallin tsps ingredients =
  List.map (\(ing, amount) -> ) ingredients

driver1 : String -> Int
driver1 str = 0

-- Part 2 Code

driver2 : String -> Int
driver2 str = 0

-- Drivers

part1 = driver1 input -- ???
test1 = driver1 testInput -- 62842880

-- part2 = driver2 input -- ???
-- test2 = driver2 testInput -- ???
